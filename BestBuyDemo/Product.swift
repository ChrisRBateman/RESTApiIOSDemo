//
//  Product.swift
//  BestBuyDemo
//
//  Created by Chris Bateman on 2017-01-17.
//  Copyright © 2017 Chris Bateman. All rights reserved.
//

import UIKit
import ObjectMapper

/// Class stores product info of search.
class Product: Mappable {
    
    var sku: String? = ""
    var name: String? = ""
    var thumbnailImage: String? = ""
    var regularPrice: Double! = 0.0
    
    required init?(map: Map) {
        
    }
    
    // Mappable
    func mapping(map: Map) {
        sku            <- map["sku"]
        name           <- map["name"]
        thumbnailImage <- map["thumbnailImage"]
        regularPrice   <- map["regularPrice"]
    }
    
    func toString() -> String {
        return "sku:\(sku!) name:\(name!) thumbnailImage:\(thumbnailImage!) regularPrice:\(regularPrice!)"
    }
}
