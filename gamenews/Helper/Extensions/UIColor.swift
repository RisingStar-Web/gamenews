//
//  UIColor.swift
//  gamenews
//
//  Created by Maxim Skorynin on 13/12/2018.
//  Copyright © 2018 Maxim Skorynin. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(hex:Int) {
        self.init(red:(hex >> 16) & 0xff, green:(hex >> 8) & 0xff, blue:hex & 0xff)
    }
    
    
    struct Default {
        static let background = UIColor(hex: User.shared.backgroundColor)
        static let text = UIColor(hex: User.shared.textColor).withAlphaComponent(0.95)
        static let date = UIColor(hex: User.shared.textColor).withAlphaComponent(0.2)
        static let cell = UIColor.white.withAlphaComponent(CGFloat(User.shared.alpha))
        static let switchColor = UIColor(hex: 0x007aff)
    }
}
