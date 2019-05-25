//
//  SPAppraisalInfoModel.swift
//  Chunlangjiu
//
//  Created by 黄树鹏 on 2019/4/13.
//  Copyright © 2019 Chunlang. All rights reserved.
//
// 鉴定师信息model

import Foundation
class SPAppraisalInfoModel : SPBaseModel {
    var shop_id : Int?
    /// 名称
    var authenticate_name : String?
    /// 范围
    var authenticate_scope : String?
    /// 要求
    var authenticate_require : String?
    /// 注意事项
    var authenticate_content : String?
    /// 头像
    var authenticate_img : String?
    /// 鉴定师ID
    var authenticate_id : String?
    /// 累计
    var line : String?
    /// 完成率
    var rate : String?
    /// 今日
    var day : String?
    /// 星级
    var authenticate_grade : String?
}
