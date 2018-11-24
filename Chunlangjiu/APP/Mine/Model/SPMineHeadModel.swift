//
//  SPMineHeadModel.swift
//  Chunlangjiu
//
//  Created by 黄树鹏 on 2018/9/16.
//  Copyright © 2018年 Chunlang. All rights reserved.
//

import Foundation
class SPMineHeadModel : SPBaseModel {
    
    var des : String?
    var type : SPMineType = .avail

    class func sp_init(type : SPMineType)->SPMineHeadModel{
        let model = SPMineHeadModel()
        model.type = type
        if type == .avail {
            model.des = "可用金额"
        }else if type == .freeze {
            model.des = "冻结金额"
        }else if type == .news {
            model.des = "消息"
        }
        return model
    }
}
