//
//  PostListingViewController.swift
//  Assignment
//
//  Created by Rajmani Kushwaha on 21/02/20.
//  Copyright © 2020 Rajmani Kushwaha. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

internal final class PostListingViewController: UIViewController {

    // MARK: - IBOutlets and Variables

    @IBOutlet private var tableView: UITableView!
    private var refreshControl = UIRefreshControl()

    private let viewModel: ProductListViewModel = ProductListViewModel()
    private let refreshTrigger = PublishSubject<Void>()
    private let loadMoreTrigger = PublishSubject<Void>()
    private let didSelectTrigger = PublishSubject<Int>()
    private let disposeBag = DisposeBag()
    
    internal override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
        bindRefreshView()
    }
    
    private func bindRefreshView() {
        refreshControl.addTarget(self, action: #selector(self.refresh), for: UIControl.Event.valueChanged)
           tableView.addSubview(refreshControl)
    }
    
    @objc private func refresh(sender:AnyObject) {
        title = nil
        refreshTrigger.onNext(())
    }
   
    private func bindViewModel() {
        let input = ProductListViewModel.Input(didLoadTrigger: .just(()),
                                               refreshTrigger: refreshTrigger.asDriver(onErrorJustReturn: ()),
                                               loadMoreTrigger: loadMoreTrigger.asDriver(onErrorJustReturn: ()),
                                               didSelectTrigger: didSelectTrigger.asDriver(onErrorJustReturn: 0))
        let output = viewModel.transform(input: input)
        
        output.orderList
            .drive(onNext: { [weak self] posts in
                self?.refreshControl.endRefreshing()
                self?.tableView.reloadData()
            })
            .disposed(by: disposeBag)
        
        output.didSelected
            .drive(onNext: { [weak self] state in
                self?.tableView.reloadData()
            })
            .disposed(by: disposeBag)
        
        output.totalSelection
            .drive(onNext: { [weak self] total in
                self?.title = "Selected Post: \(total)"
            })
            .disposed(by: disposeBag)
        
        output.moveAt
        .drive(onNext: { [weak self] index in
            self?.tableView.reloadData()
            self?.tableView.scrollToRow(at: IndexPath(row: index, section: 0), at: .bottom, animated: false)
        })
        .disposed(by: disposeBag)
        
    }
}

// MARK: - TableView Methods

extension PostListingViewController: UITableViewDelegate, UITableViewDataSource {
    
    internal func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.postList.count
    }
    
    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PostTableViewCell.reuseID, for: indexPath) as? PostTableViewCell else {
            assertionFailure("Unable to find Post TableView Cell")
            return UITableViewCell()
        }
        cell.bindView(post: viewModel.postList[indexPath.row])
        return cell
    }
    
    internal func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        didSelectTrigger.onNext(indexPath.row)
    }
    
    /// We could have used prefetch Data source method but we need to support the project till iOS 8 so using the older way for this.
    internal func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == viewModel.postList.count - 1 {
            loadMoreTrigger.onNext(())
        }
    }
}

