//
//  PostListingViewController.swift
//  Assignment
//
//  Created by Rajmani Kushwaha on 21/02/20.
//  Copyright © 2020 Rajmani Kushwaha. All rights reserved.
//

/*
 1. Fetch posts from this API https://hn.algolia.com/api/v1/search_by_date?tags=story&page=1 via a GET request.
 2. Display the posts in a list, with each element displaying the post title, created_at, as well as a switch/toggle that is deselected by default.
 3. Clicking a post should activate/deactivate the switch and select/deselect the post.
 4. The nav bar should display the number of the selected posts.
 5. Autoload more content by using query parameter “page” in the API.
 6: Add pull to refresh mechanism to the list
 */

import UIKit
import RxSwift

internal final class PostListingViewController: UIViewController {

    @IBOutlet private var tableView: UITableView!
    private let viewModel: ProductListViewModel = ProductListViewModel()
    private let refreshTrigger = PublishSubject<Void>()
    private let didSelectTrigger = PublishSubject<Int>()
    private let disposeBag = DisposeBag()
    
    internal override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
    }
    
    private func bindViewModel() {
        let input = ProductListViewModel.Input(didLoadTrigger: .just(()),
                                               refreshTrigger: refreshTrigger.asDriver(onErrorJustReturn: ()),
                                               didSelectTrigger: didSelectTrigger.asDriver(onErrorJustReturn: 0))
        let output = viewModel.transform(input: input)
        
        output.orderList
            .drive(onNext: { [weak self] posts in
                self?.tableView.reloadData()
            })
            .disposed(by: disposeBag)
    }
}

extension PostListingViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.postList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PostTableViewCell.reuseID, for: indexPath) as? PostTableViewCell else {
            assertionFailure("Unable to find Post TableView Cell")
            return UITableViewCell()
        }
        cell.bindView(post: viewModel.postList[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        didSelectTrigger.onNext(indexPath.row)
    }
}

