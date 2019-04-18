//
//  SPMineCountModel.swift
//  Chunlangjiu
//
//  Created by 黄树鹏 on 2018/8/9.
//  Copyright © 2018年 Chunlang. All rights reserved.
//

import Foundation
/// 会员中心页面统计
class SPMineCountModel : SPBaseModel {
    /// 待支付订单数量
    var wait_pay_num : Int?
    /// 待发货订单数量
    var wait_send_goods_num : Int?
    /// 待确认收货订单数量
    var wait_confirm_goods_num : Int?
    /// 已取消订单数量
    var canceled_num : Int?
    /// 待评价订单数量
    var notrate_num : Int?
    /// 优惠券数量
    var coupon_num : Int?
    /// 售后订单数量
    var after_sale_num : Int?
    /// 仓库中
    var instock_num : Int?
    /// 待审核
    var pending_num : Int?
    /// 在售商品数量
    var onsale_num  : Int?
    /// 竞拍商品数量
    var auction_num  : Int?
    /// 积分
    var point : Int?
    var money : String?
    var money_frozen : String?
    var information : String? 
    var gradeInfo : SPGradeInfoModel?
}
class SPGradeInfoModel : SPBaseModel {
    var grade_id : Int?
    var experience : Int?
    var grade_name : String?
    var grade_logo : String?
}
