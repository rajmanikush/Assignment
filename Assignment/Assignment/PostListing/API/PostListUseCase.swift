//
//  PostListUseCase.swift
//  Assignment
//
//  Created by Rajmani Kushwaha on 21/02/20.
//

import Foundation
import RxCocoa
import RxSwift

internal protocol PostListUseCase {
    func getPostList(page: Int) -> Observable<PostListResponse>
}

internal class DefaultPostListUseCase: PostListUseCase {
    internal func getPostList(page: Int) -> Observable<PostListResponse> {
        
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        return NetworkManager<PostListTarget>()
            .request(.getPostList(page: page))
            .map(PostListResponse.self, atKeyPath: nil, using: decoder)
    }
}
