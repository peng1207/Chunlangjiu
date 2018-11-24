//
//  SPView.swift
//  Chunlangjiu
//
//  Created by 黄树鹏 on 2018/7/6.
//  Copyright © 2018年 Chunlang. All rights reserved.
//

import Foundation
import UIKit
extension UIView{
    
    /// 设置view的圆角
    ///
    /// - Parameter cornerRadius: 圆角半径
    func sp_cornerRadius(cornerRadius : CGFloat){
        self.layer.cornerRadius = cornerRadius
        self.layer.masksToBounds = true
    }
    func sp_border(color:UIColor,width:CGFloat){
        self.layer.borderColor = color.cgColor
        self.layer.borderWidth = width
    }
    
}
