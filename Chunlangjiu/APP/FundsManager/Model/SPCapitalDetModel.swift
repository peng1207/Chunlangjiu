//
//  SPCapitalDetModel.swift
//  Chunlangjiu
//
//  Created by 黄树鹏 on 2018/12/15.
//  Copyright © 2018 Chunlang. All rights reserved.
//

import Foundation
import HandyJSON
class SPCapitalDetModel : HandyJSON {
    var log_id : Int?
    var type : String?
    var user_id : Int?
    var operatorStr : String?
    var fee : String?
    var message : String?
    var logtime : Int?
    var time : String? 
    required init() {}
    func mapping(mapper: HelpingMapper) {
        mapper.specify(property: &operatorStr, name: "operator") { (rawString) -> String in
            return sp_getString(string: rawString)
        }
       
    }
    
    class func sp_deserialize(from:String) -> Self?  {
        return self.deserialize(from: from)
    }
    class func sp_deserialize(from : [String : Any]?) -> Self?  {
        return self.deserialize(from: from)
    }
    
}
