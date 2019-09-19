//
//  NewsDataManager.swift
//  gamenews
//
//  Created by Maxim Skorynin on 13/12/2018.
//  Copyright © 2018 Maxim Skorynin. All rights reserved.
//

import Foundation
import CoreStore

class NewsDataManager {
    
    static let shared = NewsDataManager()
    
    func createNewsData(newsData : NewsData, newsObject : News) {
        newsData.id = newsObject.id
        newsData.date = newsObject.date
        newsData.title = newsObject.title
        newsData.shortDesc = newsObject.shortDescription
        newsData.fullDesc = newsObject.fullDescription
        newsData.pictureUrl = newsObject.pictureUrl
        newsData.croppedPictUrl = newsObject.croppedPictureUrl
        newsData.timeStamp = newsObject.timestamp!
        newsData.link = newsObject.link
        newsData.isFavorite = false
    }
    
    
    
    func updateOrCreateUser(newsObject : News) {
        do {
            try CoreStore.defaultStack.perform(synchronous: {(transaction) -> Void in
                
                if let _ = transaction.fetchOne(From<NewsData>().where(\.id == newsObject.id)) {
                    return
                } else {
                    let newsData = transaction.create(Into<NewsData>())
                    self.createNewsData(newsData: newsData, newsObject: newsObject)
                    print("created news")
                }
            })
        } catch let error {
            print("Couldn't update or create user", error)
        }
    }
    
    func getAllNews() -> ListMonitor<NewsData>? {
        if let result = CoreStore.defaultStack.monitorList(From<NewsData>()
            .orderBy(.descending(\.date))) as ListMonitor<NewsData>? {
            
            return result
        } else {
            print("Could not get all chats")
            return nil
        }
    }
    
    func updateFavorite(isFavorite : Bool, id : Int64) {
        CoreStore.defaultStack.perform(asynchronous: {(transaction) -> Void in
            if let newsData = transaction.fetchOne(From<NewsData>().where(\.id == id)) {
                newsData.isFavorite = isFavorite
            }
        }, completion: {_ in})
    }
    
    func getFavoriteNews() -> ListMonitor<NewsData>? {
        
        if let result = CoreStore.defaultStack.monitorList(From<NewsData>()
            .where(\.isFavorite == true)
            .orderBy(.descending(\.date))) as ListMonitor<NewsData>? {
            CoreStore.defaultStack.refreshAndMergeAllObjects()
            
            return result
        } else {
            print("Could not get all chats")
            return nil
        }
    }

}
