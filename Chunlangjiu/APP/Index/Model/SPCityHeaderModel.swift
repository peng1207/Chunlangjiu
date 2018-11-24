//
//  SPCityHeaderModel.swift
//  Chunlangjiu
//
//  Created by 黄树鹏 on 2018/8/19.
//  Copyright © 2018年 Chunlang. All rights reserved.
//

import Foundation

let SP_City_Commonlyused_Type = "1"
let SP_City_Recommend_Type = "2"

class SPCityHeaderModel : SPBaseModel {
    var value : String?
    var type : String?
    var dataArray : [SPAreaModel]?
}
