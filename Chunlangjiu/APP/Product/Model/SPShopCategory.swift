//
//  SPShopCategory.swift
//  Chunlangjiu
//
//  Created by chengzong liang on 2018/9/4.
//  Copyright © 2018年 Chunlang. All rights reserved.
//

import Foundation
class SPShopCategory : SPBaseModel {
    var cat_id : Int! = 0
    var shop_id : Int! = 0
    var parent_id : Int = 0
    var cat_path : String?
    var level : String?
    var is_leaf : Int! = 0
    var cat_name : String?
    var order_sort : Int! = 0
    var modified_time : Int! = 0
    var disabled : Int! = 0
    var children : [SPShopCategory]? 
}
