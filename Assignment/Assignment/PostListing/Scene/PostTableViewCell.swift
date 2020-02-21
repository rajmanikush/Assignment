//
//  PostTableViewCell.swift
//  Assignment
//
//  Created by Rajmani Kushwaha on 21/02/20.
//  Copyright © 2020 Rajmani Kushwaha. All rights reserved.
//

import UIKit

class PostTableViewCell: UITableViewCell {

    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var createdAtLabel: UILabel!
    @IBOutlet private var switchSelection: UISwitch!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    internal func bindView(post: Post) {
        titleLabel.text = post.title
        createdAtLabel.text = post.createdAt
        switchSelection.isOn = post.isSelected
    }
}
