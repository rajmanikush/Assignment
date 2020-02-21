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
    func getPostList() -> Observable<PostListResponse>
}

internal class DefaultPostListUseCase: PostListUseCase {
    internal func getPostList() -> Observable<PostListResponse> {
        return NetworkManager<PostListTarget>()
            .request(.getPostList(page: 1))
            .map { (response) -> Response in
                print(String(data: response.data, encoding: .utf8))
                return response
            }
            .map(PostListResponse.self, atKeyPath: nil)
    }
}
