//
//  SPShopModel.swift
//  Chunlangjiu
//
//  Created by 黄树鹏 on 2018/8/5.
//  Copyright © 2018年 Chunlang. All rights reserved.
//

import Foundation
import HandyJSON
class SPShopModel : HandyJSON {
    var shop_id : Int?
    var shop_name : String?
    var shop_descript : String?
    var shop_logo : String?
    var shop_type : String?
    var shopname : String?
    var shoptype : String?
    var mobile : String?
    var remark : String?
    var confrim_auction_price : String?
    var confrim_max_price : String?
    var confirm_start_price : String? 
    var productArray : [SPProductModel]?
    required init() {}
    func mapping(mapper: HelpingMapper) {
        mapper.specify(property: &productArray, name: "items")
    }
    
    class func sp_deserialize(from:String) -> Self?  {
        return self.deserialize(from: from)
    }
    class func sp_deserialize(from : [String : Any]?) -> Self?  {
        return self.deserialize(from: from)
    }
}

