//
//  SPBundle.swift
//  Chunlangjiu
//
//  Created by 黄树鹏 on 2019/1/2.
//  Copyright © 2019 Chunlang. All rights reserved.
//

import Foundation
class SPBundle {
    
    /// 获取imagebundle里的图片
    ///
    /// - Parameter name: 图片名字
    /// - Returns: 返回资源文件 图片
    class func sp_img(name : String?)->UIImage?{
        let imgBundle = Bundle(path: sp_getString(string: Bundle.main.path(forResource: "Image", ofType: "bundle")))
        if let bundle = imgBundle {
            let imagePath = bundle.path(forResource: name, ofType: "png", inDirectory: "img")
            let img = UIImage(contentsOfFile: sp_getString(string: imagePath))
            if let i = img {
                return i
            }
        }
        if sp_getString(string: name).count != 0 {
            return UIImage(named: sp_getString(string: name))
        }
        return nil
    }
    
    
    
}

