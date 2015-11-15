//
//  ViewUtils.swift
//  BestBuyDemo
//
//  Created by Chris Bateman on 2015-10-26.
//  Copyright © 2015 Chris Bateman. All rights reserved.
//

import Foundation
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
    class func showOKMessage(view: UIViewController, title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
        view.presentViewController(alert, animated: true, completion: nil)
    }
}
