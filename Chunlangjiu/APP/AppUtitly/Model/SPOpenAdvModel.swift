//
//  SPOpenAdvModel.swift
//  Chunlangjiu
//
//  Created by 黄树鹏 on 2019/1/17.
//  Copyright © 2019 Chunlang. All rights reserved.
//

import Foundation
class SPOpenAdvModel : SPBaseModel {
    var image : String?
    var linktype : String?
    var link : String?
    var imagesrc : String?
    var webview : String?
    var webparam : [String : Any]?
    
    /// 获取本地的图片的h路径
    ///
    /// - Returns: 路径
    func sp_getLocalPath()->String{
        sp_log(message: "活动图片:\(imagesrc)")
        if sp_getString(string: imagesrc).count > 0 {
            let enString = sp_getString(string: imagesrc).MD5String
            let cachePath = sp_getCachePath()
            let filePath =  "\(sp_getString(string: cachePath))/\(sp_getString(string: enString)).jpg"
            return sp_getString(string:filePath)
        }
        return ""
    }
    
}
