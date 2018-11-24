//
//  SPConfirmOrderModel.swift
//  Chunlangjiu
//
//  Created by chengzong liang on 2018/8/23.
//  Copyright © 2018年 Chunlang. All rights reserved.
//

import Foundation
import HandyJSON
class SPConfirmOrderModel : HandyJSON {
    var default_address : SPAddressModel?
    var payType : [SPPayModel]?
    var total : SPConfirmOrderPrice?
    var md5_cart_info : String?
    var dataArray  : [SPShopModel]?
    var selectPayModel : SPPayModel?
    var auctionitem_id : String?
    var pledge : String? 
   required init() {}
    func mapping(mapper: HelpingMapper) {
        mapper.specify(property: &dataArray, name: "cartInfo.resultCartData")
    }
    
    class func sp_deserialize(from:String) -> Self?  {
        return self.deserialize(from: from)
    }
    class func sp_deserialize(from : [String : Any]?) -> Self?  {
        return self.deserialize(from: from)
    }
    
}
