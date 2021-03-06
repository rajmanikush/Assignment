//
//  PostListTarget.swift
//  Assignment
//
//  Created by Rajmani Kushwaha on 21/01/20.
//

import Foundation

internal enum PostListTarget {
    case getPostList(page: Int)
}

extension PostListTarget: TargetType {
    var headers: HTTPHeaders? {
        return nil
    }

    var method: HTTPMethod {
        return .get
    }

    var baseURL: URL {
        let urlString: String
        switch self {
        case let .getPostList(page):
            urlString = "https://hn.algolia.com/api/v1/search_by_date?tags=story&page=\(page)"
        }
        return URL(string: urlString)!
    }

    var path: String {

        return "/"
    }

    internal var parameters: Parameters? {
        return nil
    }

    internal var parameterEncoding: ParameterEncoding {
        return .jsonEncoding
    }

    var task: HTTPTask {
        return .requestParametersAndHeaders(bodyParameters: parameters,
                                            bodyEncoding: parameterEncoding,
                                            urlParameters: parameters,
                                            additionHeaders: headers)
    }
}
