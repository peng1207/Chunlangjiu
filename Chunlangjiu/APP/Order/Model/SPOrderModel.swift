//
//  SPOrderModel.swift
//  Chunlangjiu
//
//  Created by 黄树鹏 on 2018/8/28.
//  Copyright © 2018年 Chunlang. All rights reserved.
//

import Foundation
import HandyJSON
class SPOrderModel : HandyJSON {
    
    var tid : Int! = 0          // 订单ID
    var shop_id : Int! = 0      // 店铺ID
    var shop_logo : String?     // 店铺logo
    var user_id : Int! = 0      // 用户ID
    var status : String?        // 订单状态
    var cancel_status : String?     // 取消状态
    var payment : String?           // 付款
    var pay_type : String?          // 支付类型
    var created_time : String?      // 创建时间
    var modified_time : String?     // 修改时间
    var buyer_rate : String?        // 评价
    var is_buyer_rate : String?     // 用户是否评价
    var totalItem : String?         // 总数量
    var status_desc : String?       // 订单状态描述
    var shopname : String?          // 店铺名称
    var aftersales_bn : String?     // 售后码
    var aftersales_type : String?       // 售后状态
    var end_time : String?              // 结束时间
    var consign_time : String?
    var oid : Int! = 0
    var num : Int! = 0
    var order : [SPOrderItemModel]?    // 商品项
    var second : Int! = 0
    var reason : String?
    var close_time : String?
    var pay_name : String?
    var aftersales_type_desc : String?
    var progress : String?
    var payment_id : String?
    var type : String?
    var auctionitem_id : String?
    var is_pay : String?
    var pledge : String?
    var max_price : String?
    var starting_price : String?
    var original_bid : String?
    var auction_begin_time : String?
    var auction_end_time : String?
    var auction_status : String?
    var cancel_id : String?
    var logi : SPLogiModel?
    var refunds : SPOrderRefundsModel? 
    var info : String?
    var commission : String?   // 佣金
    var shop_payment : String?  // 店铺实收
    var shop_explanation : String?  // 商家拒绝原因
    var trade_ststus : String?      // 竞拍订单尾款状态
    var evidence_pic : String?      // 申请售后图片
    var description_str : String?   // 申请售后备注
    required init() {}
    func mapping(mapper: HelpingMapper) {
        mapper.specify(property: &description_str, name: "description") { (rawString) -> String in
            return sp_getString(string: rawString)
        }
    }
    
    class func sp_deserialize(from:String) -> Self?  {
        return self.deserialize(from: from)
    }
    class func sp_deserialize(from : [String : Any]?) -> Self?  {
        return self.deserialize(from: from)
    }
    
    func sp_set(s:Int){
        if let second = self.second {
            self.second = second - s
            sp_dealSecond()
        }else{
            self.second = 0
        }
    }
    func sp_dealSecond(){
        if self.second < 0  {
            self.second = 0
        }
    }
    ///  是否售后订单
    ///
    /// - Returns: 是否 
    func sp_isAfterSales()->Bool{
        var isAS = false
        switch sp_getString(string: self.status) {
        case SP_STATUS_0,SP_STATUS_1,SP_STATUS_2,SP_STATUS_3:
            if sp_getString(string: self.type) == SP_AUCTION {
                 isAS = false
            }else{
                 isAS = true
            }
           
        default:
            isAS = false
        }
        return isAS
    }
    
}

class SPOrderDetaileModel : SPOrderModel{
    var shipping_type : String?
    var points_fee : String?
    var hongbao_fee : String?
    var post_fee : String?
    var payed_fee : String?
    var pay_time : String?
    var receiver_state : String?
    var receiver_city : String?
    var receiver_district : String?
    var receiver_address : String?
    var trade_memo : String?
    var receiver_name : String?
    var receiver_mobile : String?
    var ziti_addr : String?
    var ziti_memo : String?
    var total_fee : String?
    var discount_fee : String?
    var adjust_fee : String?
    var need_invoice : String?
    var invoice_name : String?
    var invoice_type : String?
    var invoice_main : String?
    var invoice_vat_main : String?
    var cancel_reason : String?
    var cancelInfo : String?
    var refund_fee : String?
    var orders : [SPOrderItemModel]?
    var shipping_type_name : String?
    
    func sp_dealData(){
        self.order = self.orders
        self.second = Int(sp_getString(string: self.close_time))
        self.created_time = SPDateManager.sp_string(to:   TimeInterval(sp_getString(string: self.created_time)))
        self.pay_time = SPDateManager.sp_string(to: TimeInterval(sp_getString(string: self.pay_time)))
        self.end_time = SPDateManager.sp_string(to: TimeInterval(sp_getString(string: self.end_time)))
        self.consign_time = SPDateManager.sp_string(to: TimeInterval(sp_getString(string: self.consign_time)))
        self.modified_time = SPDateManager.sp_string(to: TimeInterval(sp_getString(string: self.modified_time)))
        if sp_getString(string: self.type) == SP_AUCTION , sp_getString(string: self.status) == SP_AUCTION_1 {
            let nowTimeIntervale  = SPDateManager.sp_timeInterval(to: Date())
            if sp_getString(string: self.auction_end_time).count > 0  {
                if let endTimeIntervale = Int(sp_getString(string: self.auction_end_time)){
                    self.second = endTimeIntervale - Int(nowTimeIntervale)
                    sp_dealSecond()
                }
            }
        }
        
    }
    func sp_getReason()->String{
        if sp_getString(string: self.status) == SP_TRADE_CLOSED_BY_SYSTEM {
            return "(\(sp_getString(string:self.cancel_reason)))"
        }else{
            return "(\(sp_getString(string:self.reason)))"
        }
    }
}

class SPOrderItemModel : SPBaseModel{
    
    var title : String?
    var num : Int! = 0
    var pic_path : String?
    var oid : String?
    var aftersales_status : String?
    var complaints_status : String?
    var item_id : Int! = 0
    var status : String?
    var gift_data : String?
    var tid : Int! = 0
    var gift_count : Int = 0
    var price : String?
    var cat_id : Int! = 0
    var end_time : String?
    var total_fee : String?
    var adjust_fee : String?
    var spec_nature_info : String?
    var buyer_rate : String?
    var refund_enabled : Bool = false
    var changing_enabled : Bool = false
    var payment : String?
    var auctionitem_id : String?
    var is_pay : String?
    var pledge : String?
    var max_price : String?
    var starting_price : String?
    var original_bid : String?
    var auction_status : String?
}
