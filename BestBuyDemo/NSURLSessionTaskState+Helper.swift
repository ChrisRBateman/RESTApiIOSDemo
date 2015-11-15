//
//  NSURLSessionTaskState+Helper.swift
//  BestBuyDemo
//
//  Created by Chris Bateman on 2015-10-29.
//  Copyright © 2015 Chris Bateman. All rights reserved.
//

import Foundation

extension NSURLSessionTaskState: CustomStringConvertible {
    public var description: String {
        switch (self) {
            case .Running:   return "Running"
            case .Suspended: return "Suspended"
            case .Canceling: return "Canceling"
            case .Completed: return "Completed"
        }
    }
}
