//
//  String+Helper.swift
//  BestBuyDemo
//
//  Created by Chris Bateman on 2015-10-16.
//  Copyright © 2015 Chris Bateman. All rights reserved.
//

import Foundation

extension String {
    func trim() -> String {
        return self.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
    }
}
