//
//  SPSortLv2Model.swift
//  Chunlangjiu
//
//  Created by 黄树鹏 on 2018/8/5.
//  Copyright © 2018年 Chunlang. All rights reserved.
//

import Foundation
class SPSortLv2Model : SPBaseModel{
    
    var cat_id : Int?
    var cat_logo : String?
    var cat_name : String?
    var cat_path : String?
    var child_count : Int?
    var is_leaf : Int?
    var level : String?
    var lv3 : [SPSortLv3Model]?
    var order_sort : Int?
    var parent_id : Int?
    
    
}
