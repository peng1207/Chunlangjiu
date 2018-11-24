//
//  SPFilterHeaderModel.swift
//  Chunlangjiu
//
//  Created by 黄树鹏 on 2018/8/12.
//  Copyright © 2018年 Chunlang. All rights reserved.
//

import Foundation

let SP_FILTER_HEADER_TYPE_YEAR = "SP_FILTER_HEADER_TYPE_YEAR"
let SP_FILTER_HEADER_TYPE_PRICE = "SP_FILTER_HEADER_TYPE_PRICE"
let SP_FILTER_HEADER_TYPE_BRAND = "SP_FILTER_HEADER_TYPE_BRAND"
let SP_FILTER_HEADER_TYPE_CAT = "SP_FILTER_HEADER_TYPE_CAT"
let SP_FILTER_HEADER_TYPE_OTHER = "SP_FILTER_HEADER_TYPE_OTHER"

class SPFilterHeaderMode : SPBaseModel {
    var type  : String?
    var name : String?
    var list : [Any]?
    var height : CGFloat = 0
    var minPl : String?
    var maxPl : String?
    var showAll : Bool = false
}
