//
//  SPCapitalDetDetModel.swift
//  Chunlangjiu
//
//  Created by 黄树鹏 on 2019/1/19.
//  Copyright © 2019 Chunlang. All rights reserved.
//

import Foundation
class SPCapitalDetDetModel : SPBaseModel {
    var title : String?
    var content : String?
    
    class func sp_init(title : String?,content :String?)-> SPCapitalDetDetModel{
        let model = SPCapitalDetDetModel()
        model.title = title
        model.content = content
        return model
    }
    
}
