//
//  SPIndexHeader.swift
//  Chunlangjiu
//
//  Created by chengzong liang on 2018/8/27.
//  Copyright © 2018年 Chunlang. All rights reserved.
//

import Foundation


enum SPIndexType : String {
    /// 商品详情
    case item     = "item"
    /// 店铺主页
    case shop     = "shop"
    /// 分类 全部
    case category = "category"
    /// 品牌
    case brand    = "brand"
    /// 活动列表
    case activity = "activity"
    /// 酒庄
    case winery   = "winery"
    /// 名酒估价
    case evaluation = "evaluation"
    /// 会员中心 我的
    case member = "member"
    /// 购物车
    case cart = "cart"
    /// 网页
    case h5 = "h5"
    /// 我要卖酒
    case sellwine = "sellwine"
}
