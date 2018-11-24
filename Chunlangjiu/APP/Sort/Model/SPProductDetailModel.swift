//
//  SPProductDetailModel.swift
//  Chunlangjiu
//
//  Created by 黄树鹏 on 2018/8/5.
//  Copyright © 2018年 Chunlang. All rights reserved.
//

import Foundation
class SPProductDetailModel : SPBaseModel {
    var share : [String:Any]?
    var freeConf : String?
    var promotionTag : String?
    var packages : String?
    var item : SPProductModel?
    var shop : SPShopModel?
}
