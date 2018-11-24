//
//  SPAuctionPrice.swift
//  Chunlangjiu
//
//  Created by 黄树鹏 on 2018/9/9.
//  Copyright © 2018年 Chunlang. All rights reserved.
//

import Foundation
class SPAuctionPrice : SPBaseModel{
    var item_id : Int! = 0
    var title : String?
    var image_default_id : String?
    var price : String?
    var sold_quantity : String?
    var promotion : [Any]?
    var mobile : String?
}
