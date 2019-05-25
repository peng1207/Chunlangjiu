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
    /// 店铺ID
    var shop_id : Int?
    /// 店铺名称
    var shop_name : String?
    /// 店铺描述
    var shop_descript : String?
    /// 店铺简介
    var bulletin : String?
    /// 店铺logo
    var shop_logo : String?
    /// 店铺类型
    var shop_type : String?
    /// 店铺名称
    var shopname : String?
    ///  店铺类型
    var shoptype : String?
    /// 手机号码
    var mobile : String?
    /// 备注
    var remark : String?
    /// 店铺地址
    var shop_addr : String?
    /// 确认订单 竞拍价格
    var confrim_auction_price : String?
    /// 确认订单 竞拍最高价
    var confrim_max_price : String?
    /// 确认订单 竞拍起拍价
    var confirm_start_price : String?
    /// 确认订单 竞拍类型 明拍或暗拍
    var confirm_auction_status : String?
    var open_time : Int?
    var openTime : String? 
    /// 店铺等级
    var grade : String?
    /// 认证方式
    var authentication : String?
    /// 商品数据
    var productArray : [SPProductModel]?
    /// 鉴定师ID
    var authenticate_id : String?
    /// 鉴定师状态
    var authenticate : String?
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

