//
//  SPSearchRecord.swift
//  Chunlangjiu
//
//  Created by 黄树鹏 on 2018/8/15.
//  Copyright © 2018年 Chunlang. All rights reserved.
//

import Foundation
class SPSearchRecord: SPBaseModel {
    @objc dynamic var searchValue : String = ""
    @objc dynamic var textWidth : Float = 0
    /// 计算文字的宽度
    func sp_calTextWidth(){
        let font = sp_getFontSize(size: 14)
        let attributes = [NSAttributedStringKey.font:font]
        let option = NSStringDrawingOptions.usesLineFragmentOrigin
        let rect:CGRect =  searchValue.boundingRect(with: CGSize(width: sp_getScreenWidth(), height: 20), options: option, attributes: attributes, context: nil)
        textWidth = Float(rect.size.width) + 18 + 10
        if textWidth < 74 {
            textWidth = 74
        }
    }
}
