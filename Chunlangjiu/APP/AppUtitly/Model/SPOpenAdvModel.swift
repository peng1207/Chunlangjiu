//
//  SPOpenAdvModel.swift
//  Chunlangjiu
//
//  Created by 黄树鹏 on 2019/1/17.
//  Copyright © 2019 Chunlang. All rights reserved.
//

import Foundation
class SPOpenAdvModel : SPBaseModel {
    var url : String?
    
    
    /// 获取本地的图片的h路径
    ///
    /// - Returns: 路径
    func sp_getLocalPath()->String{
        if sp_getString(string: url).count > 0 {
            let enString = sp_getString(string: url).MD5String
            let cachePath = sp_getCachePath()
            let filePath =  "\(sp_getString(string: cachePath))/\(sp_getString(string: enString)).jpg"
            return sp_getString(string:filePath)
        }
        return ""
    }
    
}
