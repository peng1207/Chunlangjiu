//
//  SPMineAuthModel.swift
//  Chunlangjiu
//
//  Created by 黄树鹏 on 2019/3/13.
//  Copyright © 2019 Chunlang. All rights reserved.
//

import Foundation
class SPMineAuthModel : SPBaseModel {
    
    /// 0 失败 1 成功的
    @objc dynamic var status : String = "0"
    /// 0 不弹出 1 弹出
    @objc dynamic var isShowAlert : String = "0"
    /// 用户ID
    @objc dynamic var user_id : String = ""
}
