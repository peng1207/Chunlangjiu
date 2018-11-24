//
//  SPArray.swift
//  Chunlangjiu
//
//  Created by 黄树鹏 on 2018/8/19.
//  Copyright © 2018年 Chunlang. All rights reserved.
//

import Foundation
extension Array where Element: Equatable {
    
    // Remove first collection element that is equal to the given `object`:
    mutating func remove(_ object: Element) {
        if let index = index(of: object) {
            remove(at: index)
        }
    }
}
