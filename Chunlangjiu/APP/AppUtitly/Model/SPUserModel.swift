//
//  SPUserModel.swift
//  Chunlangjiu
//
//  Created by 黄树鹏 on 2018/8/6.
//  Copyright © 2018年 Chunlang. All rights reserved.
//

import Foundation
class SPUserModel : SPBaseModel {
    ///  登录获取到的token
    var accessToken : String?
    var user_id : String?
    /// 用户的身份
    var identity : String?
    /// 是否设置邀请人
    var referrer : String?
}
