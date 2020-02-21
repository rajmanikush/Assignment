//
//  Response.swift
//  Assignment
//
//  Created by Rajmani Kushwaha on 21/02/20.
//

import Foundation

internal final class Response: CustomDebugStringConvertible, Equatable {
    /// The status code of the response.
    internal let statusCode: Int

    /// The response data.
    internal let data: Data

    /// The original URLRequest for the response.
    internal let request: URLRequest?

    /// The HTTPURLResponse object.
    internal let response: URLResponse?

    internal init(statusCode: Int, data: Data, request: URLRequest? = nil, response: URLResponse? = nil) {
        self.statusCode = statusCode
        self.data = data
        self.request = request
        self.response = response
    }

    /// A text description of the `Response`.
    internal var description: String {
        return "Status Code: \(statusCode), Data Length: \(data.count)"
    }

    /// A text description of the `Response`. Suitable for debugging.
    internal var debugDescription: String {
        return description
    }

    internal static func == (lhs: Response, rhs: Response) -> Bool {
        return lhs.statusCode == rhs.statusCode
            && lhs.data == rhs.data
            && lhs.response == rhs.response
    }
}

extension Response {
    /// Maps data received from the signal into a JSON object.
    ///
    /// - parameter failsOnEmptyData: A Boolean value determining
    /// whether the mapping should fail if the data is empty.
    internal func mapJSON(failsOnEmptyData: Bool = true) throws -> Any {
        do {
            return try JSONSerialization.jsonObject(with: data, options: .allowFragments)
        } catch {
            if data.count < 1, !failsOnEmptyData {
                return NSNull()
            }
            throw NetworkError.jsonMapping(self)
        }
    }

    internal func map<D: Decodable>(_: D.Type, atKeyPath keyPath: String? = nil, using decoder: JSONDecoder = JSONDecoder()) throws -> D {
        let serializeToData: (Any) throws -> Data? = { jsonObject in
            guard JSONSerialization.isValidJSONObject(jsonObject) else {
                return nil
            }
            do {
                return try JSONSerialization.data(withJSONObject: jsonObject)
            } catch {
                throw NetworkError.jsonMapping(self)
            }
        }
        let jsonData: Data
        if let keyPath = keyPath {
            guard let jsonObject = (try mapJSON() as? NSDictionary)?.value(forKeyPath: keyPath) else {
                throw NetworkError.jsonMapping(self)
            }

            if let data = try serializeToData(jsonObject) {
                jsonData = data
            } else {
                let wrappedJsonObject = ["value": jsonObject]
                let wrappedJsonData: Data
                if let data = try serializeToData(wrappedJsonObject) {
                    wrappedJsonData = data
                } else {
                    throw NetworkError.jsonMapping(self)
                }
                do {
                    return try decoder.decode(DecodableWrapper<D>.self, from: wrappedJsonData).value
                } catch {
                    throw NetworkError.objectMapping(error, self)
                }
            }
        } else {
            jsonData = data
        }
        do {
            return try decoder.decode(D.self, from: jsonData)
        } catch {
            throw NetworkError.objectMapping(error, self)
        }
    }
}

private struct DecodableWrapper<T: Decodable>: Decodable {
    let value: T
}
