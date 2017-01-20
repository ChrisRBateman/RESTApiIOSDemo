//
//  ProductDetail.swift
//  BestBuyDemo
//
//  Created by Chris Bateman on 2017-01-17.
//  Copyright © 2017 Chris Bateman. All rights reserved.
//

import UIKit
import ObjectMapper

/// Class stores product detail info.
class ProductDetail: Mappable {
    
    var sku: String? = ""
    var name: String? = ""
    var regularPrice: Double! = 0.0
    var shortDescription: String? = ""
    var thumbnailImage: String? = ""
    
    required init?(map: Map) {
        
    }
    
    // Mappable
    func mapping(map: Map) {
        sku              <- map["sku"]
        name             <- map["name"]
        regularPrice     <- map["regularPrice"]
        shortDescription <- map["shortDescription"]
        thumbnailImage   <- map["thumbnailImage"]
    }
    
    func toString() -> String {
        return "sku:\(sku!) name:\(name!) regularPrice:\(regularPrice!) shortDescription:\(shortDescription!) thumbnailImage:\(thumbnailImage!)"
    }
}

