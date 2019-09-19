//
//  User.swift
//  gamenews
//
//  Created by Maxim Skorynin on 13/12/2018.
//  Copyright © 2018 Maxim Skorynin. All rights reserved.
//

import Foundation
import UIKit

struct UserDefaultsKeys {
    static let fontSize = "fontSize"
    static let backgroundColor = "backgroundColor"
    static let textColor = "textColor"
    static let alpha = "alpha"
    static let isNightMode = "isNightMode"
}

class User {
    
    static let shared = User()
    
    var fontSize = 0
    var backgroundColor = 0xfcb23a
    var textColor = 0x000000
    var alpha = 0.9
    var isNightMode = false
    
    func loadConfig() {
        
        fontSize = UserDefaults.standard.integer(forKey: UserDefaultsKeys.fontSize)
        backgroundColor = UserDefaults.standard.integer(forKey: UserDefaultsKeys.backgroundColor)
        textColor = UserDefaults.standard.integer(forKey: UserDefaultsKeys.textColor)
        alpha = UserDefaults.standard.double(forKey: UserDefaultsKeys.alpha)
        isNightMode = UserDefaults.standard.bool(forKey: UserDefaultsKeys.isNightMode)
        
        if backgroundColor == 0 {
            setNormalMode()
        }
    }
    
    func setNormalFontSize(completionHandler: @escaping (Bool) -> ()) {
        fontSize = 0
        UserDefaults.standard.set(fontSize, forKey: UserDefaultsKeys.fontSize)
        completionHandler(true)
    }
    
    func setLargeFonteSize(completionHandler: @escaping (Bool) -> ()) {
        fontSize = 4
        UserDefaults.standard.set(fontSize, forKey: UserDefaultsKeys.fontSize)
        completionHandler(true)
    }
    
    func setNightMode() {
        backgroundColor = 0x1c1464
        textColor = 0xffffff
        alpha = 0.15
        isNightMode = true
        saveSettings()
    }
    
    func setNormalMode() {
        backgroundColor = 0xfcb23a
        textColor = 0x000000
        alpha = 0.9
        isNightMode = false
        saveSettings()
    }
    
    func saveSettings() {
        UserDefaults.standard.set(backgroundColor, forKey: UserDefaultsKeys.backgroundColor)
        UserDefaults.standard.set(textColor, forKey: UserDefaultsKeys.textColor)
        UserDefaults.standard.set(alpha, forKey: UserDefaultsKeys.alpha)
        UserDefaults.standard.set(isNightMode, forKey: UserDefaultsKeys.isNightMode)
    }
    
}


