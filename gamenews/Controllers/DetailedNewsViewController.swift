//
//  DetailedNewsViewController.swift
//  ecology
//
//  Created by Maxim Skorynin on 17/11/2018.
//  Copyright © 2018 Maxim Skorynin. All rights reserved.
//

import UIKit
import MBProgressHUD

class DetailedNewsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var favorite: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var titleNews: UITextView!
    @IBOutlet weak var dateNews: UILabel!
    @IBOutlet weak var pictureNews: UIImageView!
    
    var news : NewsData!
    var isFavorite : Bool!
    var id : Int64!
    
    override func viewDidLoad() {
        tableView.delegate = self
        tableView.dataSource = self
        
        let tapper = UITapGestureRecognizer(target: self, action: #selector(setFavorite))
        tapper.cancelsTouchesInView = true
        favorite.addGestureRecognizer(tapper)
        favorite.isUserInteractionEnabled = true
        
        titleNews.text = news.title
        dateNews.text = news.date
        pictureNews.loadPhoto(url: news.pictureUrl)
        isFavorite = news.isFavorite
        id = news.id
        setImageFavorite()

        setLayouOptions()
    }
    
    @objc func setFavorite() {
        isFavorite = isFavorite ? false : true
        setImageFavorite()
        NewsDataManager.shared.updateFavorite(isFavorite: self.isFavorite, id: self.id)
    }
    
    func setImageFavorite() {
        self.favorite.image = isFavorite ? UIImage(named: "FavoriteNewsFill") : UIImage(named: "FavoriteNewsNoFill")
    }
    
    func setLayouOptions() {
        self.view.layer.cornerRadius = 4
        self.title = "Новость в деталях"
        self.tableView.layer.cornerRadius = 8
        self.titleNews.sizeToFit()
        
        self.view.backgroundColor = UIColor.Default.background
        self.tableView.backgroundColor = UIColor.Default.cell
        self.titleNews.textColor = UIColor.Default.text
        self.dateNews.textColor = UIColor.Default.date
        
        titleNews.font = titleNews.font?.withSize((titleNews.font?.pointSize)! + CGFloat(User.shared.fontSize))
        dateNews.font = dateNews.font?.withSize((dateNews.font?.pointSize)! + CGFloat(User.shared.fontSize))


    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if news != nil {
            if indexPath.row == 0 {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: Cell.text) as? TextNewsTableViewCell else {
                    return UITableViewCell()
                }
                cell.configure(news: news)
                return cell
            } else {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: Cell.link) as? LinkNewsTableViewCell else {
                    return UITableViewCell()
                }
                cell.configure(news: news)
                return cell
            }
        } else {
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 1 {
            guard let url = URL(string: news.link) else { return }
            UIApplication.shared.open(url)
        }
    }
    @IBAction func sharedNews(_ sender: Any) {
        let shareActivity = UIActivityViewController(activityItems: [news.fullDesc, news.link, pictureNews.image!], applicationActivities: nil)
        shareActivity.completionWithItemsHandler = { (activity, success, items, error) in
            if success {
                let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
                hud.mode = .customView
                hud.label.text = "Успешно"
                
                hud.customView = UIImageView(image: #imageLiteral(resourceName: "Checkmark"))
                hud.hide(animated: true, afterDelay: 2)
            }
        }
        
        shareActivity.popoverPresentationController?.sourceView = self.view
        shareActivity.popoverPresentationController?.sourceRect = self.view.bounds
        
        self.present(shareActivity, animated: true)
    }
}
