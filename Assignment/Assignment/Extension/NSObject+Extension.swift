//
//  NSObject+Extension.swift
//  Assignment
//
//  Created by Rajmani Kushwaha on 21/02/20.
//  Copyright © 2020 Rajmani Kushwaha. All rights reserved.
//

import Foundation

internal extension NSObject {
    static var reuseID: String {
        return String(describing: self)
    }
}
