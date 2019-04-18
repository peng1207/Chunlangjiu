//
//  SPAcctivityHeaderModel.swift
//  Chunlangjiu
//
//  Created by 黄树鹏 on 2019/2/3.
//  Copyright © 2019 Chunlang. All rights reserved.
//

import Foundation


class SPActivityHeaderModel: SPBaseModel {
    var title : String?
    var type : String?
    var dataArray : [SPProductModel]?
    
    class func sp_init(type:String?)-> SPActivityHeaderModel{
        let model = SPActivityHeaderModel()
        model.type = type
        if sp_getString(string: type) == SP_AUCTION{
            model.title = "店铺竞拍"
        }else if sp_getString(string: type) == SP_HEADER{
            model.title = "头部"
        }else{
            model.title = "店铺精选"
        }
        return model
    }
    
}
