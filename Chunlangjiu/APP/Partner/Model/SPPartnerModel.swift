//
//  SPPartnerModel.swift
//  Chunlangjiu
//
//  Created by 黄树鹏 on 2018/12/16.
//  Copyright © 2018 Chunlang. All rights reserved.
//

import Foundation
class SPPartnerModel : SPBaseModel {
    var shop_id : Int?
    var shop_name : String?
    var shop_descript : String?
    var shop_type : String?
    var status : String?
    var open_time : Int?
    var shop_logo : String?
    var shop_area : String?
    var shop_addr : String?
    var grade : String?
    var shopname : String?
    var shoptype : String?
    var num : String? 
    var label_one : String?
    func sp_getLabel()->[String]{
        if sp_getString(string: self.label_one).count > 0 {
            if sp_getString(string: self.label_one).contains("，") {
                return sp_getString(string: self.label_one).components(separatedBy: "，")
            }else{
                return sp_getString(string: self.label_one).components(separatedBy: ",")
            }
        }
        return [String]()
    }
}
