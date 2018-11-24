//
//  SPEventHeader.swift
//  Chunlangjiu
//
//  Created by 黄树鹏 on 2018/10/20.
//  Copyright © 2018年 Chunlang. All rights reserved.
//

import Foundation
enum SP_EventID : String {
    /// 价格区间搜索
    case searchPrice = "searchPrice"
    /// 酒精度搜索
    case searchAlcoholDegree = "searchAlcoholDegree"
    /// 类型搜索
    case searchType = "searchType"
    /// 产地搜索
    case searchPlace = "searchPlace"
    /// 品牌搜索
    case searchBrand = "searchBrand"
    /// 分类搜索
    case searchSort = "searchCategory"
    /// 首页好酒推荐
    case recommend = "recommend"
    /// 竞拍
    case auction = "auction"
    /// 我的
    case mine = "mine"
    /// 全部
    case all = "all"
    /// 首页
    case index = "index"
    /// 品牌推荐
    case brand = "brand"
    /// 首页icon
    case icon = "icon"
    /// 广告
    case banner = "banner"
    /// 购物车
    case shopCart = "shopCart"
}
