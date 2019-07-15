//
//  SPImageView.swift
//  Chunlangjiu
//
//  Created by 黄树鹏 on 2018/7/7.
//  Copyright © 2018年 Chunlang. All rights reserved.
//

import Foundation
import UIKit
import Kingfisher

typealias SPImgeComplete = (_ image : UIImage?)->Void

extension UIImageView{
    
    func sp_cache(string:String?,plImage:UIImage?,complete : SPImgeComplete? = nil){
        if let url = string, url.count > 0 {
//            self.kf.setImage(with: ImageResource(downloadURL: URL(string: url)!), placeholder: plImage, options: nil, progressBlock: nil, completionHandler: nil)
            self.kf.setImage(with: ImageResource(downloadURL: URL(string: sp_getString(string: url))!), placeholder: plImage, options: nil, progressBlock: nil) { (image, error, cacheTyoe, webUrl) in
                if let block = complete {
                    block(image)
                }
            }
        }else{
            self.image = plImage
            if let block = complete {
                block(plImage)
            }
        }
        
    }
    
}
