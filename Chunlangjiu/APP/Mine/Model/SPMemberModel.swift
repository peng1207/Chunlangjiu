//
//  SPMemberModel.swift
//  Chunlangjiu
//
//  Created by 黄树鹏 on 2018/8/9.
//  Copyright © 2018年 Chunlang. All rights reserved.
//

import Foundation
class SPMemberModel : SPBaseModel {
    var login_account : String?
    var username : String?
    var name : String?
    var birthday : String?
    var sex : String?
    var grade_id : Int?
    var grade_name : String?
    var head_portrait : String?
    var shop_name : String?
    /// 公司名称
    var company_name : String?
    var shop_id : Int?
    /// 店铺简介
    var bulletin : String?
    /// 经营地址
    var company_area : String?
    /// 法人
    var representative : String?
    /// 成立时间
    var establish_date : String?
    /// 身份证
    var idcard : String?
    /// 店铺d地址
    var area  : String?
    /// 联系方式
    var phone  : String?
    /// 是否鉴定师 true 是鉴定师 false 不是鉴定师
    var authenticate : String?
    /// 鉴定师ID
    var authenticate_id : String?
}
