//
//  SPShopProductHeader.swift
//  Chunlangjiu
//
//  Created by 黄树鹏 on 2019/3/3.
//  Copyright © 2019 Chunlang. All rights reserved.
//


enum SP_Product_Type : String {
    /// 在售
    case sale = "onsale"
    /// 仓库
    case warehouse = "instock"
    ///  竞拍中
    case auction_ing = "active"
    /// 竞拍结束
    case auction_end = "stop"
    ///  审核中
    case review_pending = "pending"
    /// 审核拒绝
    case revice_refuse = "refuse"
}

enum SP_Product_Cell_Btn_Type : String {
    /// 查看原因
    case reason = "reason"
    /// 查看详情
    case lookDet = "lookDet"
    /// 修改
    case edit = "edit"
    /// 上架
    case upper = "upper"
    /// 下架
    case lower = "lower"
    /// 设置竞拍
    case setAuction = "setAuction"
}

