//
//  News.swift
//  ecology
//
//  Created by Maxim Skorynin on 16/11/2018.
//  Copyright © 2018 Maxim Skorynin. All rights reserved.
//

import Foundation

class News {
    var id : Int64!
    var date : String!
    var title : String!
    var shortDescription : String!
    var fullDescription : String!
    var pictureUrl : String!
    var croppedPictureUrl : String!
    var timestamp : Int64!
    var link : String!
    
    public init(id : Int64, title: String, shortDescription: String, fullDescription : String!, date: String, timestamp : Int64, pictureUrl: String, croppedPictureUrl:String, link : String) {
        self.id = id
        self.title = title
        self.date = date
        self.timestamp = timestamp
        self.shortDescription = shortDescription
        self.fullDescription = fullDescription
        self.pictureUrl = pictureUrl
        self.croppedPictureUrl = croppedPictureUrl
        self.link = link
    }
}
