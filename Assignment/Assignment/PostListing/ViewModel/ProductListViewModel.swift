//
//  ProductListViewModel.swift
//  Assignment
//
//  Created by Rajmani Kushwaha on 21/02/20.
//  Copyright © 2020 Rajmani Kushwaha. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
import RxOptional

internal final class ProductListViewModel: ViewModelType {
    internal let useCase: PostListUseCase
    private(set) var postList: [Post] = []

    internal init(useCase: PostListUseCase = DefaultPostListUseCase()) {
        self.useCase = useCase
    }

    internal struct Input {
        internal let didLoadTrigger: Driver<Void>
        internal let refreshTrigger: Driver<Void>
        internal let didSelectTrigger: Driver<Int>
    }

    internal struct Output {
        internal let orderList: Driver<[Post]>
    }

    internal func transform(input: Input) -> Output {
        let postResponse = Driver.merge(input.didLoadTrigger,
                                        input.refreshTrigger)
            .flatMapLatest { [useCase] _ -> Driver<PostListResponse> in
                return useCase.getPostList()
                    .asDriver(onErrorDriveWith: .empty())
            }

        let orderList = postResponse.map { [weak self] response -> [Post]? in
            guard let self = self else { return nil }
            self.postList = response.postList ?? []
            return response.postList
        }.filterNil()

        return Output(
            orderList: orderList
        )
    }
}
