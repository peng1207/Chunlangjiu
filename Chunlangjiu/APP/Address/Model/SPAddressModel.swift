//
//  SPAddressModel.swift
//  Chunlangjiu
//
//  Created by 黄树鹏 on 2018/7/6.
//  Copyright © 2018年 Chunlang. All rights reserved.
//

import Foundation

class SPAddressModel : SPBaseModel {
    var name : String?                   // 收货人姓名
    var mobile : String?                 // 手机号
    var addrdetail : String?            // 完整的详细收货地址
    var addr : String?                  // 街道地址，详细地址
    var def_addr : Int! = 0             // 是否默认地址 0 不选择 1 选择
    var addr_id : String?               // 地址ID
    var area : String?                  // 所在地区
    var zip : String?                  // 邮政编码
    var region_id : String?            // 地区ID
}
