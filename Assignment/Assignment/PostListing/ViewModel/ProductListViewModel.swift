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
    
    // MARK: -  Variables
    internal let useCase: PostListUseCase
    private(set) var postList: [Post] = []
    private var currentPage = 1
    
    // MARK: - Init
    internal init(useCase: PostListUseCase = DefaultPostListUseCase()) {
        self.useCase = useCase
    }

    internal struct Input {
        internal let didLoadTrigger: Driver<Void>
        internal let refreshTrigger: Driver<Void>
        internal let loadMoreTrigger: Driver<Void>
        internal let didSelectTrigger: Driver<Int>
    }

    internal struct Output {
        internal let orderList: Driver<[Post]>
        internal let didSelected: Driver<Bool>
        internal let totalSelection: Driver<Int>
        internal let moveAt: Driver<Int>
    }

    internal func transform(input: Input) -> Output {
        
        let postResponse = Driver.merge(input.didLoadTrigger,
                                        input.refreshTrigger)
            .flatMapLatest { [useCase, currentPage] _ -> Driver<PostListResponse> in
                return useCase.getPostList(page: currentPage)
                    .asDriver(onErrorDriveWith: .empty())
            }

        let nextPageResponse = input.loadMoreTrigger
            .flatMapLatest { [useCase] _ -> Driver<PostListResponse> in
                self.currentPage = self.currentPage+1
                return useCase.getPostList(page: self.currentPage)
                .asDriver(onErrorDriveWith: .empty())
        }
        
        let moveAt = nextPageResponse.map { [weak self] response -> Int in
            guard let self = self, let newPost = response.postList else { return 0 }
            let oldCount = self.postList.count
            self.postList.append(contentsOf: newPost)
            return oldCount
        }
        
        let orderList = postResponse.map { [weak self] response -> [Post]? in
            guard let self = self else { return nil }
            self.postList = response.postList ?? []
            return response.postList
        }.filterNil()

        let didSelected = input.didSelectTrigger.map { [weak self] index -> Bool in
            guard let self = self else { return false }
            self.postList[index].isSelected = !(self.postList[index].isSelected ?? false)
            return self.postList[index].isSelected ?? false
        }
    
        let totalSelection = input.didSelectTrigger.map { [weak self] _  -> Int in
            guard let self = self else { return 0 }
            var total = 0
            for post in self.postList where post.isSelected == true {
                total = total + 1
            }
            return total
        }
        
    
        return Output(
            orderList: orderList,
            didSelected: didSelected,
            totalSelection: totalSelection,
            moveAt: moveAt
        )
    }
}
