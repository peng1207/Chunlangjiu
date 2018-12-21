//
//  SPIndexGoods.swift
//  Chunlangjiu
//
//  Created by 黄树鹏 on 2018/9/22.
//  Copyright © 2018年 Chunlang. All rights reserved.
//

import Foundation
class SPIndexGoods : SPBaseModel {
    var type : String?
    var dataArray : [SPProductModel]?
    var name : String?
    
    class func sp_init(type:String?)-> SPIndexGoods{
        let model = SPIndexGoods()
        model.type = type
        if sp_getString(string: type) == SP_AUCTION{
            model.name = "疯狂竞拍"
        }else if sp_getString(string: type) == SP_HEADER{
            model.name = "头部"
        }else{
            model.name = "好酒推荐"
        }
        return model
    }
    
}
