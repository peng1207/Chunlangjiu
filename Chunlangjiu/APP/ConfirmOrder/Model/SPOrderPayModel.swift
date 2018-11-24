//
//  SPOrderPayModel.swift
//  Chunlangjiu
//
//  Created by 黄树鹏 on 2018/8/26.
//  Copyright © 2018年 Chunlang. All rights reserved.
//

import Foundation
class SPOrderPayModel : SPBaseModel{
    var payment_type : String?
    var payment_id : String?
    var wxDic : [String:Any]? 
}
