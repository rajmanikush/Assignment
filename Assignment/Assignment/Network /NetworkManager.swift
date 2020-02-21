//
//  NetworkManager.swift
//  Assignment
//
//  Created by Rajmani Kushwaha on 21/02/20.
//

import Foundation
import RxSwift

internal typealias NetworkRouterCompletion = (_ data: Data?, _ response: URLResponse?, _ error: Error?) -> Void

internal protocol NetworkRouter: AnyObject {
    associatedtype Target: TargetType
    func request(_ target: Target, completion: @escaping NetworkRouterCompletion)
    func cancel()
}

internal class NetworkManager<Target: TargetType>: NetworkRouter {
    private var task: URLSessionTask?

    internal func request(_ target: Target) -> Observable<Response> {
        let responseObservable = PublishSubject<Response>()

        request(target) { data, response, error in
            if let error = error {
                return responseObservable.onError(error)
            }

            if let data = data {
                let response = Response(statusCode: 1,
                                        data: data,
                                        request: nil,
                                        response: response)
                return responseObservable.onNext(response)
            }
        }
        return responseObservable
    }

    internal func request(_ target: Target, completion: @escaping NetworkRouterCompletion) {
        let session = URLSession.shared
        do {
            let request = try buildRequest(from: target)
            task = session.dataTask(with: request, completionHandler: { data, response, error in
                completion(data, response, error)
            })
        } catch {
            completion(nil, nil, error)
        }
        task?.resume()
    }

    internal func cancel() {
        task?.cancel()
    }

    fileprivate func buildRequest(from target: Target) throws -> URLRequest {
        var request = URLRequest(url: target.baseURL.appendingPathComponent(target.path),
                                 cachePolicy: .reloadIgnoringLocalAndRemoteCacheData,
                                 timeoutInterval: 10.0)

        request.httpMethod = target.method.rawValue
        do {
            switch target.task {
            case .request:
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            case let .requestParameters(bodyParameters,
                                        bodyEncoding,
                                        urlParameters):

                try configureParameters(bodyParameters: bodyParameters,
                                        bodyEncoding: bodyEncoding,
                                        urlParameters: urlParameters,
                                        request: &request)

            case let .requestParametersAndHeaders(bodyParameters,
                                                  bodyEncoding,
                                                  urlParameters,
                                                  additionalHeaders):

                try configureParameters(bodyParameters: bodyParameters,
                                        bodyEncoding: bodyEncoding,
                                        urlParameters: urlParameters,
                                        request: &request)
            }
            return request
        } catch {
            throw error
        }
    }

    fileprivate func configureParameters(bodyParameters: Parameters?,
                                         bodyEncoding: ParameterEncoding,
                                         urlParameters: Parameters?,
                                         request: inout URLRequest) throws {
        do {
            try bodyEncoding.encode(urlRequest: &request,
                                    bodyParameters: bodyParameters, urlParameters: urlParameters)
        } catch {
            throw error
        }
    }
}
