//
//  SPString.swift
//  Chunlangjiu
//
//  Created by 黄树鹏 on 2019/1/8.
//  Copyright © 2019 Chunlang. All rights reserved.
//

import Foundation
import CryptoSwift
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
 
    /// 隐藏银行卡前面 只显示后面四位
    ///
    /// - Returns: 隐藏后的字符串
    func replaceBankCard()-> String {
        if self.count < 4 {
            return self
        }
        let start = self.index(self.startIndex, offsetBy: 0)
        let end = self.index(self.startIndex, offsetBy: self.count - 4)
        let range = Range(uncheckedBounds: (lower: start, upper: end))
        return self.replacingCharacters(in: range, with: "****  ****  ****  ")
    }
    var MD5String: String {
        
        let cStrl = cString(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue));
        
        let buffer = UnsafeMutablePointer<UInt8>.allocate(capacity: 16);
        
        CC_MD5(cStrl, CC_LONG(strlen(cStrl!)), buffer);
        
        var md5String = "";
        
        for idx in 0...15 {
            
       let obcStrl = String.init(format: "%02x", buffer[idx]);
            
      md5String.append(obcStrl);
            
           }
        
    free(buffer);
        
  return md5String;
        
    }
    
}
