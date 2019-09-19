//
//  Connectivity.swift
//  gamenews
//
//  Created by Maxim Skorynin on 08/01/2019.
//  Copyright © 2019 Maxim Skorynin. All rights reserved.
//

import Foundation
import Alamofire

class Connectivity {
    class var isConnectedToInternet:Bool {
        return NetworkReachabilityManager()!.isReachable
    }
}
