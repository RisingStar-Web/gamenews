//
//  Structs.swift
//  ecology
//
//  Created by Maxim Skorynin on 19/11/2018.
//  Copyright © 2018 Maxim Skorynin. All rights reserved.
//

import UIKit

struct Storyboard {
    static let main = UIStoryboard(name: "Main", bundle: Bundle.main)
}

struct Vc {
    static let mainNavigationController = "MainNavigationController"
    static let detailedNewsViewController = "DetailedNewsViewController"
}

struct Xml {
    static let id = "id"
    static let news = "news"
    static let item = "item"
    static let title = "title"
    static let description = "description"
    static let shortdescription = "shortdescription"
    static let date = "date"
    static let time = "time"
    static let croppedPicture = "croppedpicture"
    static let picture = "picture"
    static let source = "source"
}

struct Cell {
    static let text = "TextNewsTableViewCell"
    static let link = "LinkNewsTableViewCell"
    static let newsCell = "NewsCell"
}
