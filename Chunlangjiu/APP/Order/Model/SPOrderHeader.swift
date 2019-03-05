//
//  SPOrderHeader.swift
//  Chunlangjiu
//
//  Created by 黄树鹏 on 2018/8/29.
//  Copyright © 2018年 Chunlang. All rights reserved.
//

import Foundation

/// 订单类型
enum SPOrderType : String {
    case defaultType = "defaultType"    // 普通订单
    case auctionType = "auctionType"    // 竞拍订单
    case afterSaleType = "afterSaleType" // 售后订单
    case shopType = "shopType"           // 商家订单
    case shopSaleType = "shopSaleType"  // 商家售后订单
}
/// 订单状态
enum SPOrderStatus : String {
    case all  = "all"                          // 全部订单
    case pendPay = "WAIT_BUYER_PAY"         // 等待付款
    case receipt = "WAIT_BUYER_CONFIRM_GOODS" // 待收货
    case deliver  = "WAIT_SELLER_SEND_GOODS"               //  待发货
    case finish = "finish"                   // 已完成
    case afterSale = "afterSale"              // 售后订单
    case evaluated = "evaluated"                // 评价
    case cance = "cance"                        // 已取消
    case paydown = "paydown"            // 待付定金
    case auction_ing = "auction_ing"     // 竞拍中
    case winning_bid = "winning_bid"        // 已中标
    case falling_mark = "falling_mark"     // 落标
    case auction_receipt = "auction_receipt" // 待收货
    case afterSale_pendDeal = "pend_deal"       // 售后订单 待处理
    case afterSale_return_goods = "return_goods"    // 售后订单 退货
    case afterSale_pend_refund = "pend_refund"      // 售后订单 待退款
    case afterSale_refend = "refend"                // 退款完成
    case userApplyRefund = "userApplyRefund"        // 用户申请退款 待发货情况下
}
enum SPPayType : String {
    /// 微信支付
    case wxPay          = "wxpayApp"
    /// 支付宝
    case aliPay         = "alipayApp"
    /// 余额支付
    case balance        = "deposit"
    /// 大额支付
    case largePayment   = "largePay"
}
/// 等待付款
let SP_WAIT_BUYER_PAY = "WAIT_BUYER_PAY"
/// 等待发货
let SP_WAIT_SELLER_SEND_GOODS = "WAIT_SELLER_SEND_GOODS"
/// 等待收货
let SP_WAIT_BUYER_CONFIRM_GOODS = "WAIT_BUYER_CONFIRM_GOODS"
/// 订单完成
let SP_TRADE_FINISHED = "TRADE_FINISHED"
/// 系统关闭订单 取消订单
let SP_TRADE_CLOSED_BY_SYSTEM = "TRADE_CLOSED_BY_SYSTEM"
/// 取消状态 等待商家审核
let SP_CANCE_WAIT_PROCESS = "WAIT_PROCESS"
/// 没有取消
let SP_NO_APPLY_CANCEL = "NO_APPLY_CANCEL"
/// 等待评价
let SP_WAIT_RATE = "WAIT_RATE"
/// 失败
let SP_FAILS = "FAILS"
/// 等待商家处理
let SP_WAIT_SELLER_AGREE = "WAIT_SELLER_AGREE"
/// 等待商家确认收货
let SP_WAIT_SELLER_CONFIRM_GOODS = "WAIT_SELLER_CONFIRM_GOODS"
/// 等待用户发货
let SP_WAIT_BUYER_RETURN_GOODS = "WAIT_BUYER_RETURN_GOODS"
/// 商家取消订单 等待审核
let SP_REFUND_PROCESS = "REFUND_PROCESS"
/// 退货商品
let SP_REFUND_GOODS = "REFUND_GOODS"
/// 商家拒绝申请
let SP_SELLER_REFUSE_BUYER = "SELLER_REFUSE_BUYER"
/// 商家同意退款 进入平台审核中
let SP_REFUNDING = "REFUNDING"
/// 退款成功
let SP_ReFUND_SUCCESS = "SUCCESS"
/// 待发货申请退款 等待商家审核
let SP_WAIT_CHECK = "WAIT_CHECK"
/// 待处理
let SP_STATUS_0 = "0"
/// 处理中
let SP_STATUS_1 = "1"
/// 已处理
let SP_STATUS_2 = "2"
/// 已驳回
let SP_STATUS_3 = "3"
/// 等待商家处理
let SP_PROGRESS_0 = "0"
/// 商家接受申请，等待消费者回寄
let SP_PROGRESS_1 = "1"
/// 消费者回寄，等待商家收货确认
let SP_PROGRESS_2 = "2"
/// 
let SP_PROGRESS_8 = "8"
/// 待付定金
let SP_AUCTION_0  = "0"
/// 竞拍中
let SP_AUCTION_1  = "1"
/// 已中标
let SP_AUCTION_2  = "2"
/// 落标
let SP_AUCTION_3  = "3"
/// 竞拍订单 待收货
let SP_AUCTION_4  = "4"
/// 订单类型 竞拍
let SP_AUCTION = "auction"
/// 顶部
let SP_HEADER   = "header"
/// 是否展示取消原因或申请售后的原因
///
/// - Parameter statue: 订单状态
/// - Returns: 是否展示
func sp_isShow(reason statue:String?)-> Bool{
    var isShow  = false
    switch sp_getString(string: statue) {
    case SP_TRADE_CLOSED_BY_SYSTEM,SP_STATUS_0,SP_STATUS_1,SP_STATUS_2,SP_STATUS_3:
        isShow = true
    default:
        isShow = false
    }
    
    return isShow
}
