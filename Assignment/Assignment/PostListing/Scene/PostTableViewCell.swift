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

internal final class PostTableViewCell: UITableViewCell {

    // MARK: - IBOutlets and Variables
    
    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var createdAtLabel: UILabel!
    @IBOutlet private var switchSelection: UISwitch!
    
    // MARK: - Methods
    
    internal func bindView(post: Post) {
        titleLabel.text = post.title
        createdAtLabel.text = getFormattedDate(from: post.createdAt)
        switchSelection.isOn = post.isSelected ?? false
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
