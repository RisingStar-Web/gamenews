//
//  CacheManager.swift
//  gamenews
//
//  Created by Maxim Skorynin on 13/12/2018.
//  Copyright © 2018 Maxim Skorynin. All rights reserved.
//

import Foundation

import CoreStore
import CoreData

public class CacheManager {
    
    static let shared = CacheManager()
    static var isAddedStorage = false
    
    func initDb(completionHandler: @escaping (Bool) -> ()) {
        CoreStore.defaultStack = DataStack(
            xcodeModelName: "cachemodel",
            migrationChain: []
        )
        
        let _ = CoreStore.defaultStack.addStorage(
            SQLiteStore(fileName: "gamenews_cache.sqlite",
                localStorageOptions: .preventProgressiveMigration),
            
            completion: { (result) -> Void in
                if result.isSuccess {
                    CacheManager.isAddedStorage = true
                    completionHandler(true)
                } else {
                    completionHandler(false)
                }
        })
    }
}
