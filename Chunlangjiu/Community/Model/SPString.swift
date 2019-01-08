//
//  SPString.swift
//  Chunlangjiu
//
//  Created by 黄树鹏 on 2019/1/8.
//  Copyright © 2019 Chunlang. All rights reserved.
//

import Foundation
extension String {
    
    /// 隐藏手机号码中间四位
    ///
    /// - Returns: 隐藏后的字符串
    func replacePhone() -> String {
        if self.count != 11 {
            return self
        }
        let start = self.index(self.startIndex, offsetBy: 3)
        let end = self.index(self.startIndex, offsetBy: 7)
        let range = Range(uncheckedBounds: (lower: start, upper: end))
        return self.replacingCharacters(in: range, with: "****")
    }
   
    
}
