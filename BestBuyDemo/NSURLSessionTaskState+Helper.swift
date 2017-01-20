//
//  NSURLSessionTaskState+Helper.swift
//  BestBuyDemo
//
//  Created by Chris Bateman on 2017-01-17.
//  Copyright © 2017 Chris Bateman. All rights reserved.
//

import Foundation

extension URLSessionTask.State: CustomStringConvertible {
    
    public var description: String {
        switch (self) {
        case .running:   return "Running"
        case .suspended: return "Suspended"
        case .canceling: return "Canceling"
        case .completed: return "Completed"
        }
    }
}
