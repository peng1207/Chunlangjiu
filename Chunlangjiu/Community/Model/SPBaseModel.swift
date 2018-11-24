//
//  SPBaseModel.swift
//  Chunlangjiu
//
//  Created by 黄树鹏 on 2018/6/29.
//  Copyright © 2018年 Chunlang. All rights reserved.
//

import Foundation
import HandyJSON
import RealmSwift

class SPBaseModel : Object , HandyJSON {
 
    class func sp_deserialize(from:String) -> Self?  {
        return self.deserialize(from: from)
    }
    class func sp_deserialize(from : [String : Any]?) -> Self?  {
        return self.deserialize(from: from)
    }
    
}
