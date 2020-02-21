//
//  PostTableViewCell.swift
//  Assignment
//
//  Created by Rajmani Kushwaha on 21/02/20.
//  Copyright © 2020 Rajmani Kushwaha. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class PostTableViewCell: UITableViewCell {

    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var createdAtLabel: UILabel!
    @IBOutlet private var switchSelection: UISwitch!

    private let switchSubject = PublishSubject<Bool>()
    internal var switchTrigger: Driver<Bool> {
        return switchSubject.asDriver(onErrorJustReturn: false)
    }
    internal let disposeBag = DisposeBag()

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    internal func bindView(post: Post) {
        titleLabel.text = post.title
        createdAtLabel.text = getFormattedDate(from: post.createdAt)
        switchSelection.isOn = post.isSelected ?? false
        
        switchSelection.rx.controlEvent(.valueChanged).asDriver().drive(onNext: { [weak self] _ in
            guard let self = self else { return }
            self.switchSelection.isOn = !self.switchSelection.isOn
            self.switchSubject.onNext(self.switchSelection.isOn)
        }).disposed(by: disposeBag)
    }
    
    private func getFormattedDate(from string: String) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.000Z"
        
        let date = dateFormatter.date(from: string)
        dateFormatter.dateFormat = "dd/MMMM/yyyy"
        
        if let date = date {
            return dateFormatter.string(from: date)
        } else {
            return nil
        }
    }
}
