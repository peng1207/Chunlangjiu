//
//  SPSetModel.swift
//  Chunlangjiu
//
//  Created by chengzong liang on 2018/12/13.
//  Copyright © 2018年 Chunlang. All rights reserved.
//

import Foundation
class SPSetModel: SPBaseModel {
    var title : String!
    var type : SPSetType!
    
    class func sp_init(title:String!,type:SPSetType)->SPSetModel{
        let model = SPSetModel()
        model.title = title
        model.type = type
        return model
    }
    
}
