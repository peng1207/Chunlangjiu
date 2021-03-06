//
//  SPOrderBtnManager.swift
//  Chunlangjiu
//
//  Created by 黄树鹏 on 2018/9/2.
//  Copyright © 2018年 Chunlang. All rights reserved.
//

import Foundation
class SPOrderBtnManager {
    
    class func sp_dealCanceState(orderModel : SPOrderModel?,showDelete : Bool = true) ->(Bool,String,UIColor){
        var isHidden = false
        var canceText = ""
        var color : UIColor = SPColorForHexString(hex: SP_HexColor.color_b31f3f.rawValue)
        switch sp_getString(string: orderModel?.status) {
        case SP_WAIT_BUYER_PAY:
            if SPAPPManager.sp_isBusiness() {
                isHidden = true
            }else{
                 canceText = "取消订单"
                color = SPColorForHexString(hex: SP_HexColor.color_666666.rawValue)
            }
           
        case SP_WAIT_SELLER_SEND_GOODS :
            if SPAPPManager.sp_isBusiness() {
                if sp_getString(string: orderModel?.cancel_status) == SP_REFUND_PROCESS {
                    isHidden = true
                }else{
                    if sp_getString(string: orderModel?.cancel_status) == SP_NO_APPLY_CANCEL || sp_getString(string: orderModel?.cancel_status) == SP_FAILS{
                        canceText = "无货"
                        color = SPColorForHexString(hex: SP_HexColor.color_666666.rawValue)
                    }else{
                        isHidden = true
                    }
                }
            }else{
                isHidden = true
            }
        case SP_TRADE_CLOSED_BY_SYSTEM :
            isHidden = true
        case SP_WAIT_BUYER_CONFIRM_GOODS :
          isHidden = true
        case SP_TRADE_FINISHED :
            if SPAPPManager.sp_isBusiness() {
                isHidden = true
            }else{
                if let isRate = Bool(sp_getString(string: orderModel?.is_buyer_rate)),isRate == true {
                    isHidden = true
                }else{
                    if showDelete {
                        canceText = "删除订单"
                        color = SPColorForHexString(hex: SP_HexColor.color_666666.rawValue)
                    }else {
                        isHidden = true
                    }
                }
            }
        case SP_TRADE_CLOSED_BY_SYSTEM :
            isHidden = true
        case SP_WAIT_SELLER_AGREE:
            if SPAPPManager.sp_isBusiness(){
                  canceText = "不同意"
            }else{
                isHidden = true
            }
        case SP_STATUS_0:
            if SPAPPManager.sp_isBusiness() {
                canceText = "拒绝申请"
            }else{
                isHidden = true
            }
           
        case SP_STATUS_1:
            if SPAPPManager.sp_isBusiness(){
                isHidden = true
            }else{
                if sp_getString(string: orderModel?.type) == SP_AUCTION{
                    isHidden = true
                }else{
                    if sp_getString(string: orderModel?.progress) == SP_PROGRESS_2 {
                        isHidden = true
                    }else{
                        isHidden = true
                        canceText = "撤销申请"
                    }
                }
               
            }
           
        case SP_STATUS_2,SP_STATUS_3:
            isHidden = true
        case SP_WAIT_CHECK:
            if SPAPPManager.sp_isBusiness(){
                canceText = "拒绝"
            }else{
                isHidden = true
            }
        default:
           isHidden = true
        }
        return (isHidden,canceText,color)
    }
    class func sp_dealDoneState(orderModel : SPOrderModel?,showDelete : Bool = true) ->(Bool,String,UIColor){
        var isHidden = false
        var donetext = ""
         var color : UIColor = SPColorForHexString(hex: SP_HexColor.color_b31f3f.rawValue)
        switch sp_getString(string: orderModel?.status) {
        case SP_WAIT_BUYER_PAY:
            if SPAPPManager.sp_isBusiness() {
                isHidden = true
            }else{
                 donetext = "去付款"
            }
           
        case SP_WAIT_SELLER_SEND_GOODS :
            if SPAPPManager.sp_isBusiness() {
                if sp_getString(string: orderModel?.cancel_status) == SP_REFUND_PROCESS{
                    isHidden = true
                }else{
                    if sp_getString(string: orderModel?.cancel_status) == SP_NO_APPLY_CANCEL  || sp_getString(string: orderModel?.cancel_status) == SP_FAILS{
                         donetext = "发货"
                    }else{
                        isHidden = true
                    }
                }
                
            }else{
                if sp_getString(string: orderModel?.cancel_status) == SP_NO_APPLY_CANCEL {
                    donetext = "取消订单"
                    color = SPColorForHexString(hex: SP_HexColor.color_666666.rawValue)
                }else{
                    donetext = ""
                    isHidden = true
                }
            }
        case SP_TRADE_CLOSED_BY_SYSTEM :
            if SPAPPManager.sp_isBusiness(){
                isHidden = true
            }else{
                if showDelete {
                    donetext = "删除订单"
                    color = SPColorForHexString(hex: SP_HexColor.color_666666.rawValue)
                }else{
                    isHidden = true
                }
                
            }
        case SP_WAIT_BUYER_CONFIRM_GOODS :
            if SPAPPManager.sp_isBusiness() {
                isHidden = true
            }else{
                donetext = "商品签单"
            }
        case SP_TRADE_FINISHED :
            if SPAPPManager.sp_isBusiness(){
                isHidden = true
            }else{
                if let isRate = Bool(sp_getString(string: orderModel?.is_buyer_rate)),isRate == true {
                    if showDelete {
                         donetext = "删除订单"
                         color = SPColorForHexString(hex: SP_HexColor.color_666666.rawValue)
                    }else{
                        isHidden = true
                    }
                   
                }else{
                     donetext = "评价"
                }
               
            }
        case SP_WAIT_SELLER_AGREE:
            if SPAPPManager.sp_isBusiness(){
                  donetext = "同意申请"
            }else{
                isHidden = true
            }
        case SP_STATUS_0:
            if SPAPPManager.sp_isBusiness() {
                 donetext = "同意申请"
            }else{
                if sp_getString(string: orderModel?.type) == SP_AUCTION{
                    donetext = "去付定金"
                }else{
                    isHidden = true
                    donetext = "撤销申请"
                }
            }
        case SP_STATUS_1:
            if SPAPPManager.sp_isBusiness() {
                if sp_getString(string: orderModel?.progress) == SP_PROGRESS_2{
                    donetext = "同意退款"
                }else{
                    isHidden = true
                }
            }else{
                if sp_getString(string: orderModel?.type) == SP_AUCTION{
                    donetext = "修改出价"
                }else{
                    if sp_getString(string: orderModel?.progress) == SP_PROGRESS_1 {
                        donetext = "退货"
                    }else{
                        isHidden = true
                    }
                }
            }
        case SP_STATUS_2:
            if SPAPPManager.sp_isBusiness(){
                isHidden = true
            }else{
                if sp_getString(string: orderModel?.type) == SP_AUCTION {
                    if sp_getString(string: orderModel?.trade_ststus) == SP_WAIT_BUYER_PAY{
                        donetext = "付款"
                        isHidden = false
                    }else if sp_getString(string: orderModel?.trade_ststus) == SP_WAIT_BUYER_CONFIRM_GOODS{
                        donetext = "商品签单"
                        isHidden = false
                    }else{
                        isHidden = true
                    }
                   
                }else{
                      isHidden = true
                }
            }
           
        case SP_STATUS_3:
            if SPAPPManager.sp_isBusiness(){
                isHidden = true
            }else{
                if sp_getString(string: orderModel?.type) == SP_AUCTION {
                    isHidden = true
                }else{
                    isHidden = true
                    let itemModel = orderModel?.order?.first
                    if let item = itemModel {
                        if sp_getString(string: item.complaints_status) == SP_NOT_COMPLAINTS {
                            isHidden = false
                            donetext = "投诉"
                        }
                    }
                }

            }
        case SP_WAIT_CHECK:
            if SPAPPManager.sp_isBusiness(){
                donetext = "同意退款"
            }else{
                isHidden = true
            }
        default:
            isHidden = true
        }
        return (isHidden,donetext,color)
    }
    /// 处理订单详情的 底部view的显示或隐藏
    ///
    /// - Parameter orderModel: 订单数据
    /// - Returns: 是否隐藏
    class func sp_dealDetBtn(orderModel : SPOrderModel?,showDelete : Bool = true)-> Bool {
        var isHidden = false
        
        switch sp_getString(string: orderModel?.status) {
        case SP_WAIT_BUYER_PAY:
            if SPAPPManager.sp_isBusiness() {
                isHidden = true
            }
            
        case SP_WAIT_SELLER_SEND_GOODS :
            if SPAPPManager.sp_isBusiness() {
                if sp_getString(string: orderModel?.cancel_status) == SP_NO_APPLY_CANCEL  || sp_getString(string: orderModel?.cancel_status) == SP_FAILS{
                    
                }else{
                      isHidden = true
                }
            }else{
                if sp_getString(string: orderModel?.cancel_status) == SP_NO_APPLY_CANCEL {
                    
                }else{
                    isHidden = true
                }
            }
        case SP_TRADE_CLOSED_BY_SYSTEM :
            if SPAPPManager.sp_isBusiness(){
                isHidden = true
            }else{
                if showDelete == false {
                    isHidden = true
                }
            }
        case SP_WAIT_BUYER_CONFIRM_GOODS :
            if SPAPPManager.sp_isBusiness() {
                isHidden = true
            }else{
                
            }
        case SP_TRADE_FINISHED :
            if SPAPPManager.sp_isBusiness(){
                isHidden = true
            }else{
               if let isRate = Bool(sp_getString(string: orderModel?.is_buyer_rate)),isRate == true {
                    if showDelete == false {
                        isHidden = true
                    }
                }
            }
        case SP_WAIT_SELLER_AGREE:
            if SPAPPManager.sp_isBusiness(){
                
            }else{
                isHidden = true
            }
        case SP_STATUS_0:
            if SPAPPManager.sp_isBusiness() {
                 isHidden = false
            }else{
                if sp_getString(string: orderModel?.type) == SP_AUCTION{
                     isHidden = false
                }else{
                    isHidden = true
                }
            }
           
        case SP_STATUS_1 :
            if SPAPPManager.sp_isBusiness(){
                if sp_getString(string: orderModel?.progress) == SP_PROGRESS_2 {
                    isHidden = false
                }else{
                    isHidden = true
                }
            }else{
                if sp_getString(string: orderModel?.type) == SP_AUCTION {
                    isHidden = false
                }else{
                    if sp_getString(string: orderModel?.progress ) == SP_PROGRESS_2 {
                        isHidden = true
                    }else if  sp_getString(string: orderModel?.progress) == SP_PROGRESS_1{
                        isHidden = false
                    }else{
                        isHidden = true
                    }
                }
            }
        case SP_STATUS_2:
            if SPAPPManager.sp_isBusiness(){
                isHidden = true
            }else{
                if sp_getString(string: orderModel?.type) == SP_AUCTION {
                    if sp_getString(string: orderModel?.trade_ststus) == SP_WAIT_BUYER_PAY {
                         isHidden = false
                    }else if sp_getString(string: orderModel?.trade_ststus) == SP_WAIT_BUYER_CONFIRM_GOODS{
                        isHidden = false
                    }else{
                        isHidden = true
                    }
                   
                }else{
                    isHidden = true
                }
            }
        case SP_STATUS_3:
            if SPAPPManager.sp_isBusiness() {
                isHidden = true
            }else{
                if sp_getString(string: orderModel?.type) == SP_AUCTION{
                    isHidden = true
                }else{
                      isHidden = true
                    let itemModel = orderModel?.order?.first
                    if let item = itemModel {
                        if sp_getString(string: item.complaints_status) == SP_NOT_COMPLAINTS {
                            isHidden = false
                        }
                    }
                }
            }
        case SP_WAIT_CHECK:
            isHidden = false
        default:
            isHidden = true
        }
        return isHidden
    }
    /// 是否显示删除按钮
    ///
    /// - Parameter orderModel: 订单数据
    /// - Returns: 是否显示
    class func sp_showDelete(orderModel : SPOrderModel?) -> Bool {
//        var show : Bool = false
//        switch sp_getString(string: orderModel?.status) {
//        case SP_TRADE_FINISHED:
//            if SPAPPManager.sp_isBusiness(){
//
//            }else{
//                  show = true
//            }
//        case  SP_TRADE_CLOSED_BY_SYSTEM :
//            if SPAPPManager.sp_isBusiness(){
//
//            }else{
//                show = true
//            }
//        default:
//            show = false
//        }
//
//        return show
        return false
    }
}

