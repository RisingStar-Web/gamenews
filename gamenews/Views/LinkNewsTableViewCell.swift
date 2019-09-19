//
//  LinkNewsTableViewCell.swift
//  ecology
//
//  Created by Maxim Skorynin on 26/11/2018.
//  Copyright © 2018 Maxim Skorynin. All rights reserved.
//

import UIKit

class LinkNewsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var link: UILabel!
    @IBOutlet weak var hint: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        hint.textColor = UIColor.Default.date
        hint.font = hint.font?.withSize((hint.font?.pointSize)! + CGFloat(User.shared.fontSize))
        link.font = link.font?.withSize((link.font?.pointSize)! + CGFloat(User.shared.fontSize))

    }
    
    func configure(news : NewsData) {
        self.link.text = news.link
    }
    
}
