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
extension UIImageView{
    
    func sp_cache(string:String?,plImage:UIImage?){
        if let url = string, url.count > 0 {
            self.kf.setImage(with: ImageResource(downloadURL: URL(string: url)!), placeholder: plImage, options: nil, progressBlock: nil, completionHandler: nil)
        }else{
            self.image = plImage
        }
        
    }
    
}
