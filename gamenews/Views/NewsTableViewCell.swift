//
//  NewsTableViewCell.swift
//  ecology
//
//  Created by Maxim Skorynin on 16/11/2018.
//  Copyright © 2018 Maxim Skorynin. All rights reserved.
//

import Foundation
import UIKit
import Kingfisher

class NewsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var descriptioNews: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var picture: UIImageView!
    @IBOutlet weak var viewImage: UIView!
    @IBOutlet weak var viewCell: UIView!
    @IBOutlet weak var favorite: UIImageView!
    @IBOutlet weak var background: UIView!
    
    var isFavorite : Bool!
    var id : Int64!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setLayoutOptions()
        
        let tapper = UITapGestureRecognizer(target: self, action: #selector(setFavorite))
        tapper.cancelsTouchesInView = true
        favorite.addGestureRecognizer(tapper)
        favorite.isUserInteractionEnabled = true
    }
    
    @objc func setFavorite() {
        isFavorite = isFavorite ? false : true
        setImageFavorite()
        NewsDataManager.shared.updateFavorite(isFavorite: self.isFavorite, id: self.id)
    }
    
    func setLayoutOptions() {
        viewCell.layer.cornerRadius = 9
        viewImage.layer.cornerRadius = 9
        
        background.backgroundColor = UIColor.Default.background
        viewCell.backgroundColor = UIColor.Default.cell
        title.textColor = UIColor.Default.text
        descriptioNews.textColor = UIColor.Default.text
        date.textColor = UIColor.Default.date
        
        title.font = title.font.withSize(title.font.pointSize + CGFloat(User.shared.fontSize))
        descriptioNews.font = descriptioNews.font.withSize(descriptioNews.font.pointSize + CGFloat(User.shared.fontSize))
        date.font = date.font.withSize(date.font.pointSize + CGFloat(User.shared.fontSize))

    }
    
    func setImageFavorite() {
        self.favorite.image = isFavorite ? UIImage(named: "FavoriteNewsFill") : UIImage(named: "FavoriteNewsNoFill")
    }
    
    func configure(news : NewsData) {
        self.picture.loadPhoto(url: news.croppedPictUrl)
        self.title.text = news.title
        self.descriptioNews.text = news.shortDesc
        self.date.text = news.date
        self.isFavorite = news.isFavorite
        self.id = news.id
        self.setImageFavorite()
    }
}

extension UIImageView {
    func loadPhoto(url: String) {
        if !url.isEmpty {
            self.kf.setImage(with: URL(string: url), placeholder: nil, options: [.transition(ImageTransition.fade(0.5))], progressBlock: nil, completionHandler: nil)
        }
    }
}
