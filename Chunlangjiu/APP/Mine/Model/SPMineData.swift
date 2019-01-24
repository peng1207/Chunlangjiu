//
//  SPMineData.swift
//  Chunlangjiu
//
//  Created by 黄树鹏 on 2018/7/23.
//  Copyright © 2018年 Chunlang. All rights reserved.
//

import Foundation
import UIKit
enum SPMineType : Int {
    case pend_pay         = 0           // 待付款
    case pend_receipt     = 1           // 待收货
    case evaluated        = 2           // 待评价
    case after_sale       = 3           // 售后订单
    case all_order        = 4           // 全部订单
    case paydown          = 5           // 待付定金
    case auction_ing      = 6           // 竞拍中
    case winning_bid      = 7           // 已中标
    case falling_mark     = 8           // 落标
    case auction_receipt  = 9           // 待收货
    case funds            = 10          // 资金管理
    case collect          = 11          // 我的收藏
    case bank_card        = 12          // 银行卡管理
    case member           = 13          // 会员资料
    case address          = 14          // 地址管理
    case orderManager     = 15          // 订单管理
    case auctionOrder     = 16          // 竞拍订单
    case mineManager      = 17          // 我的管理
    case mineHeader       = 18          // 我的顶部
    case share            = 19          // 分享
    case addProduct       = 20          // 添加商品
    case saleProduct      = 21          // 在售商品
    case auctionProduct   = 22          // 竞拍商品
    case warehouseProduct = 23          // 仓库商品
    case reviewProduct    = 24          // 审核商品
    case productManager   = 25          // 商品管理
    case deliver          = 26          // 待发货
    case avail            = 27          // 可用金额
    case freeze           = 28          // 冻结金额
    case news             = 29          // 消息
    case auction_all      = 30          // 竞拍订单 全部订单
    case cance            = 31          // 取消订单
    case valuation        = 32          // 我的估值
    case customServer     = 33          // 我的客服
    case fans             = 34          // 粉丝推荐
    case set              = 35          // 设置
}

class SPMineData {
    
    class func sp_getMineAllData() -> Array<SPMineSectionModel>{
        var array : Array<SPMineSectionModel> = Array()
//        array.append(sp_getInfo())
        array.append(sp_getOrderManager())
       
        if SPAPPManager.sp_isBusiness() {
            array.append(sp_getProductManager())
        }else{
//            if SP_ISSHOW_AUCTION{
//                 array.append(sp_getAuctionOrder())
//            }
            
        }
        array.append(sp_getMineManager())
        return array
    }
    fileprivate class func sp_getInfo() -> SPMineSectionModel{
        let model = SPMineSectionModel()
        model.type = SPMineType.mineHeader
        return model
    }
    
     class func sp_getMineHead()-> [SPMineHeadModel]{
        var list = [SPMineHeadModel]()
        list.append(SPMineHeadModel.sp_init(type: SPMineType.avail))
        if SPAPPManager.sp_isBusiness() {
             list.append(SPMineHeadModel.sp_init(type: .freeze))
        }
        list.append(SPMineHeadModel.sp_init(type: SPMineType.news))
        return list
    }
    
    fileprivate class func sp_getOrderManager() -> SPMineSectionModel{
        let model = SPMineSectionModel()
        model.title = "订单管理"
        model.type = SPMineType.orderManager
        var array : Array<SPMineModel> = Array()
        array.append(self.sp_get_pend_payModel())
        array.append(self.sp_get_deliverModel())
        array.append(self.sp_get_pend_receiptModel())
//        if sp_getString(string: SPAPPManager.instance().userModel?.identity) != SP_IS_ENTERPRISE {
//              array.append(self.sp_get_evaluatedModel())
//        }
       
        if SPAPPManager.sp_isBusiness() {
            array.append(sp_get_cance())
             array.append(self.sp_get_after_saleModel())
            model.rowCount = 5
        }else{
            array.append(self.sp_get_after_saleModel())
            model.rowCount = 4
//            array.append(self.sp_get_all_order())
        }
        
        model.dataArray = array
        return model
    }
    fileprivate class func sp_getAuctionOrder() -> SPMineSectionModel{
        let model = SPMineSectionModel()
        model.title = "竞拍订单"
        model.type = SPMineType.auctionOrder
        var array : Array<SPMineModel> = Array()
        array.append(self.sp_get_paydown())
        array.append(self.sp_get_auction_ing())
        array.append(self.sp_get_winning_bid())
        array.append(self.sp_get_falling_mark())
        array.append(self.sp_get_auction_all())
        model.dataArray = array
        return model
    }
    fileprivate class func sp_getMineManager() -> SPMineSectionModel{
        let model = SPMineSectionModel()
        model.title = "我的管理"
        model.type = SPMineType.mineManager
        var array : Array<SPMineModel> = Array()
        array.append(self.sp_get_funds())
        
//        if SPAPPManager.sp_isBusiness() {
//             array.append(self.sp_get_share())
//            array.append(self.sp_get_member())
//            array.append(self.sp_get_address())
//            array.append(self.sp_get_bank_card())
//        }else{
//             array.append(self.sp_get_collect())
//             array.append(sp_get_valuation())
//            array.append(sp_get_customServer())
//            array.append(sp_get_fans())
//            array.append(sp_get_set())
//            model.rowCount = 3
//        }
        array.append(self.sp_get_collect())
        array.append(sp_get_valuation())
        array.append(sp_get_customServer())
        array.append(sp_get_fans())
        array.append(sp_get_set())
        model.rowCount = 3
        model.dataArray = array
        return model
    }
    fileprivate class func sp_getProductManager() -> SPMineSectionModel {
        let model = SPMineSectionModel()
        model.title = "商品管理"
        model.type = SPMineType.productManager
        var array : Array<SPMineModel> = Array()
        array.append(self.sp_get_addProduct())
        array.append(self.sp_get_reviewProduct())
        array.append(self.sp_get_warehouseProduct())
        array.append(self.sp_get_saleProductt())
        if SP_ISSHOW_AUCTION {
            array.append(self.sp_get_auctionProduct())
            model.rowCount = 5
        }else{
            model.rowCount = 4
        }
        
        
        model.dataArray = array
        return model
    }
    fileprivate class func sp_get_pend_payModel() -> SPMineModel{
        let model = SPMineModel()
        model.title = "待付款"
        model.image = UIImage(named: "mine_pend_pay")
        model.mintType = SPMineType.pend_pay
        return model
    }
    fileprivate class func sp_get_deliverModel() -> SPMineModel{
        let model = SPMineModel()
        model.title = "待发货"
        model.mintType = SPMineType.deliver
        model.image = UIImage(named: "mine_pend_deliver")
        return model
    }
    fileprivate class func sp_get_pend_receiptModel() -> SPMineModel{
        let model = SPMineModel()
        model.title = "待收货"
        model.mintType = SPMineType.pend_receipt
        model.image = UIImage(named: "mine_pend_receipt")
        return model
    }
    fileprivate class func sp_get_evaluatedModel() -> SPMineModel{
        let model = SPMineModel()
        model.title = "待评价"
        model.image = UIImage(named: "mine_evaluated")
        model.mintType = SPMineType.evaluated
        return model
    }
    fileprivate class func sp_get_after_saleModel() -> SPMineModel{
        let model = SPMineModel()
        model.title = "售后订单"
        model.image = UIImage(named: "mine_after_sale")
        model.mintType = SPMineType.after_sale
        return model
    }
    fileprivate class func sp_get_all_order() -> SPMineModel{
        let model = SPMineModel()
        model.title = "全部订单"
        model.image = UIImage(named: "mine_all_order")
        model.mintType = SPMineType.all_order
        return model
    }
    fileprivate class func sp_get_paydown() -> SPMineModel{
        let model = SPMineModel()
        model.title = "待付定金"
        model.image = UIImage(named: "mine_paydown")
        model.mintType = SPMineType.paydown
        return model
    }
    fileprivate class func sp_get_auction_ing() -> SPMineModel{
        let model = SPMineModel()
        model.title = "竞拍中"
        model.image = UIImage(named: "mine_auction_ing")
        model.mintType = SPMineType.auction_ing
        return model
    }
    fileprivate class func sp_get_winning_bid() -> SPMineModel{
        let model = SPMineModel()
        model.title = "已中标"
        model.image = UIImage(named: "mine_winning_bid")
        model.mintType = SPMineType.winning_bid
        return model
    }
    fileprivate class func sp_get_falling_mark() -> SPMineModel{
        let model = SPMineModel()
        model.title = "落标"
        model.image = UIImage(named: "mine_falling_mark")
        model.mintType = SPMineType.falling_mark
        return model
    }
    fileprivate class func sp_get_auction_receipt() -> SPMineModel{
        let model = SPMineModel()
        model.title = "待收货"
        model.image = UIImage(named: "mine_pend_receipt")
        model.mintType = SPMineType.auction_receipt
        return model
    }
    fileprivate class func sp_get_auction_all()->SPMineModel{
        let model = SPMineModel()
        model.title = "全部订单"
        model.image = UIImage(named: "mine_all_order")
        model.mintType = SPMineType.auction_all
        return model
    }
    fileprivate class func sp_get_funds() -> SPMineModel{
        let model = SPMineModel()
        model.title = "资金管理"
        model.image = UIImage(named: "mine_funds")
        model.mintType = SPMineType.funds
        return model
    }
    fileprivate class func sp_get_collect() -> SPMineModel{
        let model = SPMineModel()
        model.title = "我的收藏"
        model.image = UIImage(named: "mine_collect")
        model.mintType = SPMineType.collect
        return model
    }
    fileprivate class func sp_get_bank_card() -> SPMineModel{
        let model = SPMineModel()
        model.title = "银行卡管理"
        model.image = UIImage(named: "mine_bank_card")
        model.mintType = SPMineType.bank_card
        return model
    }
    fileprivate class func sp_get_member() -> SPMineModel{
        let model = SPMineModel()
        model.title = "会员资料"
        model.image = UIImage(named: "mine_member")
        model.mintType = SPMineType.member
        return model
    }
    fileprivate class func sp_get_address() -> SPMineModel{
        let model = SPMineModel()
        model.title = "地址管理"
        model.image = UIImage(named: "mine_address")
        model.mintType = SPMineType.address
        return model
    }
    fileprivate class func sp_get_share() -> SPMineModel{
        let model  = SPMineModel()
        model.title = "我要分享"
        model.image = UIImage(named: "mine_share")
        model.mintType = SPMineType.share
        return model
    }
    fileprivate class func sp_get_addProduct() -> SPMineModel {
        let model  = SPMineModel()
        model.title = "上传商品"
        model.image = UIImage(named: "mine_addProduct")
        model.mintType = SPMineType.addProduct
        return model
    }
    fileprivate class func sp_get_saleProductt() -> SPMineModel {
        let model  = SPMineModel()
        model.title = "在售商品"
        model.image = UIImage(named: "mine_saleProduct")
        model.mintType = SPMineType.saleProduct
        return model
    }
    fileprivate class func sp_get_auctionProduct() -> SPMineModel {
        let model  = SPMineModel()
        model.title = "竞拍商品"
        model.image = UIImage(named: "mine_auctionProduct")
        model.mintType = SPMineType.auctionProduct
        return model
    }
    fileprivate class func sp_get_warehouseProduct() -> SPMineModel {
        let model  = SPMineModel()
        model.title = "仓库商品"
        model.image = UIImage(named: "mine_warehouseProduct")
        model.mintType = SPMineType.warehouseProduct
        return model
    }
    fileprivate class func sp_get_reviewProduct() -> SPMineModel {
        let model  = SPMineModel()
        model.title = "审核商品"
        model.image = UIImage(named: "mine_revicewProduct")
        model.mintType = SPMineType.reviewProduct
        return model
    }
    fileprivate class func sp_get_cance()-> SPMineModel{
        let model  = SPMineModel()
        model.title = "取消订单"
        model.image = UIImage(named: "mine_cance")
        model.mintType = SPMineType.cance
        return model
    }
    fileprivate class func sp_get_valuation()->SPMineModel{
        let model = SPMineModel()
        model.title = "我的估值"
        model.image = UIImage(named: "public_valuation")
        model.mintType = .valuation
        return model
    }
    fileprivate class func sp_get_customServer()->SPMineModel {
        let model = SPMineModel()
        model.title = "我的客服"
        model.image = UIImage(named: "mine_customserver")
        model.mintType = .customServer
        return model
    }
    fileprivate class func sp_get_fans()->SPMineModel{
        let model = SPMineModel()
        model.title = "粉丝推荐"
        model.image = UIImage(named: "mine_fans")
        model.mintType = .fans
        return model
    }
    fileprivate class func sp_get_set()->SPMineModel{
        let model = SPMineModel()
        model.title = "设置"
        model.image = UIImage(named: "mine_setting")
        model.mintType = .set
        return model
    }
    class func sp_getItemCount(mineModel:SPMineModel?,countModel:SPMineCountModel?) -> String{
        var count = ""
        if let mine = mineModel ,let cModel = countModel {
            switch mine.mintType {
            case .pend_pay? :
                count = sp_getString(string: cModel.wait_pay_num)
            case .pend_receipt? :
                count = sp_getString(string: cModel.wait_confirm_goods_num)
            case .evaluated? :
                count = sp_getString(string: cModel.notrate_num)
            case .deliver? :
                count = sp_getString(string: cModel.wait_send_goods_num)
            case .cance? :
                count = sp_getString(string: cModel.canceled_num)
            case .after_sale? :
                count = sp_getString(string: cModel.after_sale_num)
            case .warehouseProduct? :
                count = sp_getString(string: cModel.instock_num)
            case .reviewProduct? :
                count = sp_getString(string: cModel.pending_num)
            case .none:
                count = ""
            case .some(_):
                  count = ""
            }
        }
        
        return count
    }
    
}
