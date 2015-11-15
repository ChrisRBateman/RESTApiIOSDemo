//
//  Constants.swift
//  BestBuyDemo
//
//  Created by Chris Bateman on 2015-10-28.
//  Copyright © 2015 Chris Bateman. All rights reserved.
//

import Foundation

struct Constants {
    static let Domain = "http://www.bestbuy.ca"
    static let Lang = NSLocale.preferredLanguages()[0]
    static let ShowProductDetailSegue = "showProductDetail"
    
    static let SearchUrl = Domain + "/api/v2/json/search?lang=%@&query=%@"
    static let ProductUrl = Domain + "/api/v2/json/product/%@?lang=%@"
    
    static let TitleBarColor = "#063A67"
    static let LightGrayColor = "#E7E7E7"
}
