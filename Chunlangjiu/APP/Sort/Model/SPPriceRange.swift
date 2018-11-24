//
//  SPPriceRange.swift
//  Chunlangjiu
//
//  Created by chengzong liang on 2018/9/26.
//  Copyright © 2018年 Chunlang. All rights reserved.
//

import Foundation

enum SPPirceRangeType : String {
    case all  = "all"
    case range900 = "priceRange900"
    case range2999 = "priceRange2999"
    case range4999 = "priceRange4999"
    case range9999 = "priceRange9999"
    case range10000 = "priceRange10000"
}

class SPPriceRange :  SPBaseModel {
    var maxPrice : String?
    var minPrice : String?
    var showPrice: String?
    var type : SPPirceRangeType?
    class func sp_init(maxPrice: String? ,minPrice:String?,type : SPPirceRangeType)-> SPPriceRange{
        let model = SPPriceRange()
        model.maxPrice = maxPrice
        model.minPrice = minPrice
        model.type = type
        if type == SPPirceRangeType.all {
              model.showPrice = "全部"
        }else{
            if sp_getString(string: maxPrice).count > 0 , sp_getString(string: minPrice).count > 0 {
                model.showPrice = "\(sp_getString(string: minPrice))~\(sp_getString(string: maxPrice))元"
            }else if sp_getString(string: maxPrice).count > 0 {
                model.showPrice = "\(sp_getString(string: maxPrice))元以下"
            }else if sp_getString(string: minPrice).count > 0 {
                model.showPrice = "\(sp_getString(string: minPrice))元以上"
            }
        }
        return model
    }
    
}
