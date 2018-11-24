//
//  SPFilterModel.swift
//  Chunlangjiu
//
//  Created by 黄树鹏 on 2018/8/12.
//  Copyright © 2018年 Chunlang. All rights reserved.
//

import Foundation
class SPFilterModel : SPBaseModel{
    var brand : [SPBrand]?
    var cat : [SPSortRootModel]?
    var props : [Any]?
    var brand_count : Int?
    var cat_count : Int?
    var activeFilter : [Any]?
}

class SPBrand : SPBaseModel {
    var brand_id : Int?
    var brand_name : String?
}
