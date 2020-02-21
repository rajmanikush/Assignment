//
//  Observable+Response.swift
//  Assignment
//
//  Created by Rajmani Kushwaha on 21/02/20.
//

import Foundation
import RxSwift

/// Extension for processing raw NSData generated by network access.
extension ObservableType where E == Response {
    /// Maps received data at key path into a Decodable object. If the conversion fails, the signal errors.
    internal func map<D: Decodable>(_ type: D.Type, atKeyPath keyPath: String? = nil, using decoder: JSONDecoder = JSONDecoder()) -> Observable<D> {
        return flatMap { response -> Observable<D> in
            Observable.just(try response.map(type, atKeyPath: keyPath, using: decoder))
        }
    }
}
