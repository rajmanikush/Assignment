//
//  NetworkError.swift
//  Assignment
//
//  Created by Rajmani Kushwaha on 21/02/20.
//

import Foundation

internal enum NetworkError: Error {
    /// Indicates a response failed to map to a JSON structure.
    case jsonMapping(Response)

    /// Indicates a response failed to map to a String.
    case stringMapping(Response)

    /// Indicates a response failed to map to a Decodable object.
    case objectMapping(Swift.Error, Response)

    /// Indicates a response failed with an invalid HTTP status code.
    case statusCode(Response)

    /// Indicates that an `Endpoint` failed to map to a `URLRequest`.
    case requestMapping(String)
    case encodingFailed
    case missingURL
}

extension NetworkError {
    /// Depending on error type, returns a `Response` object.
    internal var response: Response? {
        switch self {
        case let .jsonMapping(response): return response
        case let .stringMapping(response): return response
        case let .objectMapping(_, response): return response
        case let .statusCode(response): return response
        case .requestMapping: return nil
        case .encodingFailed: return nil
        case .missingURL: return nil
        }
    }
}

// MARK: - Error Descriptions

extension NetworkError: LocalizedError {
    internal var errorDescription: String? {
        switch self {
        case .jsonMapping:
            return "Failed to map data to JSON."
        case .stringMapping:
            return "Failed to map data to a String."
        case .objectMapping:
            return "Failed to map data to a Decodable object."
        case .statusCode:
            return "Status code didn't fall within the given range."
        case .requestMapping:
            return "Failed to map Endpoint to a URLRequest."
        case .encodingFailed:
            return "Parameter encoding failed."
        case .missingURL:
            return "URL is nil."
        }
    }
}
