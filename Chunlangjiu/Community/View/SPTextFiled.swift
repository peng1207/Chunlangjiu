//
//  SPTextFiled.swift
//  Chunlangjiu
//
//  Created by 黄树鹏 on 2018/7/18.
//  Copyright © 2018年 Chunlang. All rights reserved.
//

import Foundation
import UIKit
class SPTextFiled : UITextField {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.clearButtonMode = .whileEditing
        self.tintColor = SPColorForHexString(hex: SP_HexColor.color_b31f3f.rawValue)
//        self.setValue(SPColorForHexString(hex: SP_HexColor.color_999999.rawValue), forKey: "_placeholderLabel.textColor")
        //  _placeholderLabel.font
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    deinit {
        
    }
}
