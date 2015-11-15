//
//  SearchResults.swift
//  BestBuyDemo
//
//  Created by Chris Bateman on 2015-10-23.
//  Copyright © 2015 Chris Bateman. All rights reserved.
//

import UIKit
import ObjectMapper

/// Class stores results of search.
class SearchResults: Mappable {
    var Brand: String? = ""
    var pageSize: Int? = 0
    var products: [Product]?
    
    required init?(_ map: Map) {
        
    }
    
    // Mappable
    func mapping(map: Map) {
        Brand    <- map["Brand"]
        pageSize <- map["pageSize"]
        products <- map["products"]
    }
    
    func toString() -> String {
        return "Brand:\(Brand!) pageSize:\(pageSize!) products:(\(getProductsString()))"
    }
    
    func getProductsString() -> String {
        var s = ""
        if let products = self.products {
            for product in products {
                s += "\(product.toString())|"
            }
        }
        return s
    }
}
