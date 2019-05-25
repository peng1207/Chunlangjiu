//
//  SPAppraisalProductModel.swift
//  Chunlangjiu
//
//  Created by 黄树鹏 on 2019/4/13.
//  Copyright © 2019 Chunlang. All rights reserved.
//
// 鉴定商品信息

let SPAPPraisalProductStatus_True = "true"
let SPAPPraisalProductStatus_False = "false"

import Foundation
class SPAppraisalProductModel: SPBaseModel {
    var chateau_id : Int?
    var title : String?
    var name : String?
    var img : String?
    var series : String?
    var user_id :String?
    var price : String?
    var status : String?
    var year : String?
    var authenticate_id : Int?
    var colour : String?
    var flaw : String?
    var accessory : String?
    var content : String?
    var authenticate_name : String?
    var authenticate_img : String?
    var details : String?
    var sell : String? 
    func sp_getImgList()->[String]{
        if sp_getString(string: self.img).count > 0 {
            return sp_getString(string: self.img).components(separatedBy: ",")
        }else {
            let list = [String]()
            return list
        }
        
    }
    
}
