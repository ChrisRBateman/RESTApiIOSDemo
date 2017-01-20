//
//  ViewUtils.swift
//  BestBuyDemo
//
//  Created by Chris Bateman on 2017-01-17.
//  Copyright © 2017 Chris Bateman. All rights reserved.
//

import UIKit

class ViewUtils {
    
    ///
    /// Show an OK message alert. Add title and message to customize.
    ///
    /// - parameters:
    ///   - view: the view showing message
    ///   - title: the title
    ///   - message: the message
    ///
    class func showOKMessage(_ view: UIViewController, title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        view.present(alert, animated: true, completion: nil)
    }
}
