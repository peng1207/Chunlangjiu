//
//  APPUtitly.swift
//  Chunlangjiu
//
//  Created by 黄树鹏 on 2018/7/6.
//  Copyright © 2018年 Chunlang. All rights reserved.
//

import Foundation
import UIKit
/// 获取商品的比例
let SP_PRODUCT_SCALE : CGFloat = 1
/// 获取广告的比例
let SP_BANNER_SCALE : CGFloat  = 1
/// 是企业、商家身份
let SP_IS_ENTERPRISE  = "1"
/// 是否显示竞拍的功能
let SP_ISSHOW_AUCTION = true
let SP_KVO_KEY_CONTENTSIZE = "contentSize"
///城市合伙人
let SP_GRADE_2 = "2"
///星级用户
let SP_GRADE_1 = "1"
/// 普通用户
let SP_GRADE_0 = "0"

/// 账单类型 默认
let SP_FUNDS_BILL_TYPE_DEFAULT = "sell"
/// 账单类型 充值
let SP_FUNDS_BILL_TYPE_RECHARGE = "add"
/// 账单类型 提现
let SP_FUNDS_BILL_TYPE_CASH = "expense"
/// 获取默认的图片
///
/// - Returns: 图片
func sp_getDefaultImg()-> UIImage {
    return UIImage(named: "public_defauleImg")!
}
/// 获取logo的图片
///
/// - Returns: 图片
func sp_getLogoImg()-> UIImage{
    return UIImage(named: "public_logo")!
}

/// 保存省市区数据
///
/// - Parameter array: 省市区数据
func sp_saveArea(array :[Any]){
    let list = NSArray(array: array)
    list.write(toFile: sp_getAreaPath(), atomically: true)
}
/// 获取保存省市区的目录
///
/// - Returns: 目录
func sp_getAreaPath()->String{
    return SP_CACHEPATH + "chunlangArea.plist"
}
func sp_getAreaList()->[Any]?{
    let array = NSArray(contentsOfFile: sp_getAreaPath())
    return array as? [Any]
}
