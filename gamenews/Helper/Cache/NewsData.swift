//
//  NewsData+CoreDataClass.swift
//  gamenews
//
//  Created by Maxim Skorynin on 13/12/2018.
//  Copyright © 2018 Maxim Skorynin. All rights reserved.
//
//

import Foundation
import CoreData

@objc(NewsData)
public class NewsData: NSManagedObject {
    @NSManaged public var id: Int64
    @NSManaged public var date: String
    @NSManaged public var title: String
    @NSManaged public var shortDesc: String
    @NSManaged public var fullDesc: String
    @NSManaged public var pictureUrl: String
    @NSManaged public var croppedPictUrl: String
    @NSManaged public var timeStamp: Int64
    @NSManaged public var link: String
    @NSManaged public var isFavorite: Bool

}
