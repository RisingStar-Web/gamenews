//
//  FavoriteTableViewController.swift
//  gamenews
//
//  Created by Maxim Skorynin on 13/12/2018.
//  Copyright © 2018 Maxim Skorynin. All rights reserved.
//

import Foundation
import UIKit
import CoreStore

class FavoriteTableViewController: UITableViewController, ListObjectObserver {
    
    typealias ListEntityType = NewsData
    var favoriteNews : ListMonitor<NewsData>!
    
    var hint = UILabel()

    func listMonitorDidRefetch(_ monitor: ListMonitor<NewsData>) {
        self.tableView.reloadData()
    }

    func listMonitorWillChange(_ monitor: ListMonitor<NewsData>) {
        self.tableView.beginUpdates()
    }

    func listMonitorDidChange(_ monitor: ListMonitor<NewsData>) {
        self.tableView.endUpdates()
    }

    func listMonitor(_ monitor: ListMonitor<NewsData>, didInsertObject object: NewsData, toIndexPath indexPath: IndexPath) {
        self.tableView.insertRows(at: [indexPath], with: .none)
        showHint()
    }

    func listMonitor(_ monitor: ListMonitor<NewsData>, didDeleteObject object: NewsData, fromIndexPath indexPath: IndexPath) {
        self.tableView.deleteRows(at: [indexPath], with: .left)
        showHint()
    }

    func listMonitor(_ monitor: ListMonitor<NewsData>, didUpdateObject object: NewsData, atIndexPath indexPath: IndexPath) {
        let news = favoriteNews[indexPath]

        if let cell = self.tableView.cellForRow(at: indexPath) as? NewsTableViewCell {
            cell.configure(news: news)
        }
    }

    override func viewDidLoad() {
        self.view.layer.cornerRadius = 4
        let nib = UINib.init(nibName: Cell.newsCell, bundle: nil)
        self.tableView.register(nib, forCellReuseIdentifier: Cell.newsCell)
        favoriteNews = NewsDataManager.shared.getFavoriteNews()
        
        favoriteNews.addObserver(self)
        
        setLayoutOptions()
        addHint()
        showHint()
    }
    
    func setLayoutOptions() {
        self.tableView.backgroundColor = UIColor.Default.background
        self.navigationController?.navigationBar.barStyle = !User.shared.isNightMode ? .default : .black
    }
    
    func showHint() {
        if favoriteNews.numberOfObjects() == 0 {
            hint.isHidden = false
        } else {
            hint.isHidden = true
        }
    }
    
    func addHint() {
        hint = UILabel(frame: CGRect(x: 0, y: 0, width: 120, height: 20))
        hint.textAlignment = .center
        hint.center = self.view.center
        hint.text = "Список пуст"
        hint.isHidden = false
        hint.alpha = 0.7
        hint.font = UIFont(name: "name", size: 14)
        hint.textColor = UIColor.Default.text
        self.view.addSubview(hint)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if favoriteNews != nil {
            favoriteNews.addObserver(self)
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let news = favoriteNews[indexPath.row] as NewsData? {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: Cell.newsCell) as? NewsTableViewCell else {
                return UITableViewCell()
            }

            cell.configure(news: news)
            return cell
        } else {
            return UITableViewCell()
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favoriteNews.numberOfObjects()
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let detailedNewsVC = self.storyboard?.instantiateViewController(withIdentifier: Vc.detailedNewsViewController) as? DetailedNewsViewController else {return}
        
        detailedNewsVC.news = favoriteNews[indexPath.row]
        self.navigationController?.pushViewController(detailedNewsVC, animated: true)
    }
}
