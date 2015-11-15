//
//  UIColor+Helper.swift
//  BestBuyDemo
//
//  Created by Chris Bateman on 2015-10-16.
//  Copyright © 2015 Chris Bateman. All rights reserved.
//

// Got this code from https://gist.github.com/anonymous/fd07ecf47591c9f9ed1a

import UIKit

extension UIColor {
    convenience init(hex: String, alpha: CGFloat = 1) {
        assert(hex[hex.startIndex] == "#", "Expected hex string of format #RRGGBB")
        
        let scanner = NSScanner(string: hex)
        scanner.scanLocation = 1  // skip #
        
        var rgb: UInt32 = 0
        scanner.scanHexInt(&rgb)
        
        self.init(
            red:   CGFloat((rgb & 0xFF0000) >> 16)/255.0,
            green: CGFloat((rgb &   0xFF00) >>  8)/255.0,
            blue:  CGFloat((rgb &     0xFF)      )/255.0,
            alpha: alpha)
    }
}
