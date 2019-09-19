//
//  NewsTableViewController.swift
//  ecology
//
//  Created by Maxim Skorynin on 16/11/2018.
//  Copyright © 2018 Maxim Skorynin. All rights reserved.
//

import UIKit
import CoreStore

class NewsTableViewController: UITableViewController, ListObjectObserver {
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    typealias ListEntityType = NewsData
    var allNews : ListMonitor<NewsData>!
    
    var refresher : UIRefreshControl!
    
    override func viewWillAppear(_ animated: Bool) {
        if allNews != nil {
            allNews.addObserver(self)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    
        self.view.layer.cornerRadius = 4
        
        let nib = UINib.init(nibName: Cell.newsCell, bundle: nil)
        self.tableView.register(nib, forCellReuseIdentifier: Cell.newsCell)
        
        allNews = NewsDataManager.shared.getAllNews()
        allNews.addObserver(self)
        
        setLayoutOptions()
        refresher = UIRefreshControl()
        refresher.tintColor = UIColor.white.withAlphaComponent(0.8)
        refresher.addTarget(self, action: #selector(self.refresh), for: UIControl.Event.valueChanged)
        self.tableView.insertSubview(refresher!, at: 0)
        
    }
    
    func setLayoutOptions() {
        self.tableView.backgroundColor = UIColor.Default.background
        self.navigationController?.navigationBar.barStyle = !User.shared.isNightMode ? .default : .black
    }
    
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
    }
    
    func listMonitor(_ monitor: ListMonitor<NewsData>, didDeleteObject object: NewsData, fromIndexPath indexPath: IndexPath) {
    }
    
    func listMonitor(_ monitor: ListMonitor<NewsData>, didUpdateObject object: NewsData, atIndexPath indexPath: IndexPath) {
        let news = allNews[indexPath]
        
        if let cell = self.tableView.cellForRow(at: indexPath) as? NewsTableViewCell {
            cell.configure(news: news)
        }
    }
    
    @objc func refresh() {
        self.navigationItem.title = "Обновление..."
        if Connectivity.isConnectedToInternet {
            ParseNews.parse() { isUpdate in
                if isUpdate {
                    self.allNews = NewsDataManager.shared.getAllNews()
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                        self.navigationItem.title = "Новости игровой индустрии"
                        if self.refresher.isRefreshing {
                            self.refresher.endRefreshing()
                        }
                    }
                }
            }
        } else {
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.navigationItem.title = "Новости игровой индустрии"
                if self.refresher.isRefreshing {
                    self.refresher.endRefreshing()
                }
                
                self.showAlertOk(title: "Обновление", message: "Подключение к сети отсутствует")
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let news = allNews[indexPath.row] as NewsData? {
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
        return allNews.numberOfObjects()
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let detailedNewsVC = self.storyboard?.instantiateViewController(withIdentifier: Vc.detailedNewsViewController) as? DetailedNewsViewController else {return}
        
        detailedNewsVC.news = allNews[indexPath.row]
        self.navigationController?.pushViewController(detailedNewsVC, animated: true)
    }

}
