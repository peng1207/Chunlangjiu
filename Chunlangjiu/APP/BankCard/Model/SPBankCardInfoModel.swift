//
//  SPBankCardInfoModel.swift
//  Chunlangjiu
//
//  Created by 黄树鹏 on 2019/1/10.
//  Copyright © 2019 Chunlang. All rights reserved.
//

import Foundation
class SPBankCardInfoModel : SPBaseModel {
    var bankname : String?          // 银行
    var cardprefixnum : String?     // 前缀
    var cardname : String?
    var cardtype : String?          // 卡类型
    var cardprefixlength : String?  // 前缀的长度
    var banknum : String?
    var isLuhn : Bool = false
    var iscreditcard : Int?
    var cardlength : String?        // 卡的长度
    var bankurl : String?           // 银行网站
    var enbankname : String?
    var abbreviation : String?      // 简称
    var bankimage : String?         // 图片
    var servicephone : String?      // 电话号码
}
