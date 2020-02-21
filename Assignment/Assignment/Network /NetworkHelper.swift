//
//  NetworkHelper.swift
//  Assignment
//
//  Created by Rajmani Kushwaha on 21/02/20.
//

import Foundation

internal class NetworkHelper {
    static let environment: NetworkEnvironment = .production
}

internal enum NetworkEnvironment {
    case production
    case staging
}

extension String {
    internal static var graphQLString: String {
        switch NetworkHelper.environment {
        case .production: return "https://gql.tokopedia.com/graphql/"
        case .staging: return "https://gql-staging.tokopedia.com/graphql/"
        }
    }

    internal static var bookingUrl: String {
        switch NetworkHelper.environment {
        case .production: return "https://booking.tokopedia.com"
        case .staging: return "https://booking-staging.tokopedia.com"
        }
    }
}
