//
//  SPAreaModel.swift
//  Chunlangjiu
//
//  Created by 黄树鹏 on 2018/8/7.
//  Copyright © 2018年 Chunlang. All rights reserved.
//

import Foundation
class SPAreaModel : SPBaseModel {
    var id  : String?
    var value : String?
    var parentId : String?
    var firstLetter : String?
    var children : [SPAreaModel]! = [SPAreaModel]()
    var textWidth : CGFloat = 0
    /// 获取首字母
    func sp_getFirstLetter(){
        self.firstLetter = sp_getFirstLetterFromString(aString: sp_getString(string: self.value))
    }
    /// 计算文字的宽度
    func sp_calTextWidth(){
        if let s = value {
            let font = sp_getFontSize(size: 14)
            let attributes = [NSAttributedStringKey.font:font]
            let option = NSStringDrawingOptions.usesLineFragmentOrigin
            let rect:CGRect =  s.boundingRect(with: CGSize(width: sp_getScreenWidth(), height: 20), options: option, attributes: attributes, context: nil)
            textWidth = rect.size.width
        }else{
            textWidth = 0
        }
        
        
    }
}
