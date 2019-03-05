//
//  SPOrderData.swift
//  Chunlangjiu
//
//  Created by 黄树鹏 on 2018/8/29.
//  Copyright © 2018年 Chunlang. All rights reserved.
//

import Foundation


/// 根据不同的订单类型获取不同的tool
///
/// - Parameter orderType: 订单类型
/// - Returns: 数据
func sp_getOrderStat(to orderType : SPOrderType) -> [SPOrderToolModel] {
    var list = [SPOrderToolModel]()
    if  orderType == .defaultType || orderType == .shopType {
        list = sp_getDefaultOrderType(orderType: orderType)
    }else if orderType == .auctionType {
        list = sp_getAuctionOrderType(orderType: orderType)
    }else if orderType == .afterSaleType || orderType == .shopSaleType {
        list = sp_getAfterSaleOrderType(orderType: orderType)
    }
    return list
}
///  获取后台对应的订单状态
///
/// - Parameter toolModel: 数据
/// - Returns: 订单状态
func sp_getRequestStatues(toolModel : SPOrderToolModel?)-> String{
    guard let model = toolModel else {
        return ""
    }
    var state = ""
    switch model.status {
    case SPOrderStatus.pendPay:
        state = SP_WAIT_BUYER_PAY
    case .deliver:
        state = SP_WAIT_SELLER_SEND_GOODS
    case .receipt:
        state = SP_WAIT_BUYER_CONFIRM_GOODS
    case .evaluated:
        state = SP_WAIT_RATE
    case .finish:
        state = SP_TRADE_FINISHED
    case .cance:
        state = SP_TRADE_CLOSED_BY_SYSTEM
    case .afterSale_pendDeal :
        state = SP_STATUS_0
    case .afterSale_return_goods,.afterSale_pend_refund:
        state = SP_STATUS_1
    case .afterSale_refend :
        state = SP_STATUS_2
    case .paydown :
        state = SP_AUCTION_0
    case .auction_ing:
        state = SP_AUCTION_1
    case .winning_bid:
        state = SP_AUCTION_2
    case .falling_mark:
        state = SP_AUCTION_3
    case .auction_receipt:
        state = SP_AUCTION_4
    default:
        state = ""
    }
    return state
}
func sp_progress(toolModel : SPOrderToolModel?)-> String{
    guard let model = toolModel else {
        return ""
    }
     var state = ""
    switch model.status  {
    case .afterSale_pendDeal :
        state = SP_PROGRESS_0
    case .afterSale_return_goods:
        state = SP_PROGRESS_1
    case .afterSale_pend_refund:
        state = SP_PROGRESS_2
    case .afterSale_refend :
        state = ""
    default:
        state = ""
    }
    return state
}
/// 获取买家默认订单
///
/// - Returns: 订单状态数据
private func sp_getDefaultOrderType(orderType : SPOrderType)->[SPOrderToolModel]{
     var list = [SPOrderToolModel]()
    let all = SPOrderToolModel()
    all.status = .all
    all.statusString = "全部"
    all.orderType = orderType
    list.append(all)
    let pendPay = SPOrderToolModel()
    pendPay.statusString = "待付款"
    pendPay.status = .pendPay
    pendPay.orderType = orderType
    list.append(pendPay)
    let deliver = SPOrderToolModel()
    deliver.status = .deliver
    deliver.statusString = "待发货"
    deliver.orderType = orderType
    list.append(deliver)
    let receipt = SPOrderToolModel()
    receipt.status = .receipt
    receipt.statusString = "待收货"
    receipt.orderType = orderType
    list.append(receipt)
    let finish = SPOrderToolModel()
    finish.status = .finish
    finish.statusString = "已完成"
    finish.orderType = orderType
    list.append(finish)
//    if SPAPPManager.sp_isBusiness() {
//            let cance = SPOrderToolModel()
//            cance.status = .cance
//            cance.statusString = "已取消"
//            cance.orderType = orderType
//            list.append(cance)
//    }

    return list
}
/// 获取买家竞拍订单
///
/// - Returns: 竞拍订单状态数据
private func sp_getAuctionOrderType(orderType : SPOrderType)->[SPOrderToolModel]{
    var list = [SPOrderToolModel]()
//    let all = SPOrderToolModel()
//    all.status = .all
//    all.statusString = "全部"
//    all.orderType = orderType
//    list.append(all)
    let pendPay = SPOrderToolModel()
    pendPay.statusString = "待付定金"
    pendPay.status = .paydown
    pendPay.orderType = orderType
    list.append(pendPay)
    let auction_ing = SPOrderToolModel()
    auction_ing.status = .auction_ing
    auction_ing.statusString = "竞拍中"
    auction_ing.orderType = orderType
    list.append(auction_ing)
    let finish = SPOrderToolModel()
    finish.status = .winning_bid
    finish.statusString = "已中标"
    finish.orderType = orderType
    list.append(finish)
    let cance = SPOrderToolModel()
    cance.status = .falling_mark
    cance.statusString = "落标"
    cance.orderType = orderType
    list.append(cance)
    // auction_receipt
    let receipt = SPOrderToolModel()
    receipt.status = .auction_receipt
    receipt.statusString = "待收货"
    receipt.orderType = orderType
    list.append(receipt)
    return list
}
/// 获取售后订单
///
/// - Returns: 订单状态数据
private func sp_getAfterSaleOrderType(orderType : SPOrderType)->[SPOrderToolModel]{
    var list = [SPOrderToolModel]()
    let all = SPOrderToolModel()
    all.status = .all
    all.statusString = "全部"
    all.orderType = orderType
    list.append(all)
    let pendPay = SPOrderToolModel()
    pendPay.statusString = "待处理"
    pendPay.status = .afterSale_pendDeal
    pendPay.orderType = orderType
    list.append(pendPay)
    let receipt = SPOrderToolModel()
    receipt.status = .afterSale_return_goods
    receipt.statusString = "待退货"
    receipt.orderType = orderType
    list.append(receipt)
    let finish = SPOrderToolModel()
    finish.status = .afterSale_pend_refund
    finish.statusString = "待退款"
    finish.orderType = orderType
    list.append(finish)
    let cance = SPOrderToolModel()
    cance.status = .afterSale_refend
    cance.statusString = "退款成功"
    cance.orderType = orderType
    list.append(cance)
    return list
}


