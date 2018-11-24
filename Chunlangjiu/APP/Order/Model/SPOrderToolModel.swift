//
//  SPOrderToolModel.swift
//  Chunlangjiu
//
//  Created by 黄树鹏 on 2018/8/29.
//  Copyright © 2018年 Chunlang. All rights reserved.
//

import Foundation
class SPOrderToolModel : SPBaseModel {
    var status : SPOrderStatus = .all
    var statusString : String?
    var orderType : SPOrderType = .defaultType
}
