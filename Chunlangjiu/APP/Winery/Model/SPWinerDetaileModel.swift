//
//  SPWinerDetaileModel.swift
//  Chunlangjiu
//
//  Created by 黄树鹏 on 2018/8/9.
//  Copyright © 2018年 Chunlang. All rights reserved.
//

import Foundation
class SPWinerDetaileModel : SPBaseModel {
    var chateau_id : String?
    var name : String?
    var img : String?
    var chateaucat_id : String?
    var modified : String?
    var ifpub :String?
    var content : String?
    var intro :String?
    var phone : String?
    var grade : [SPWinderGrade]?
    
}
