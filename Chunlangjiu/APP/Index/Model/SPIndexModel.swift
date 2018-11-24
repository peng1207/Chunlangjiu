//
//  SPIndexModel.swift
//  Chunlangjiu
//
//  Created by chengzong liang on 2018/8/27.
//  Copyright © 2018年 Chunlang. All rights reserved.
//

import Foundation
class SPIndexModel : SPBaseModel{
    var bannerList : [SPBannerModel]?
    var iconList : [SPIndexIconModel]?
    var brandList : [SPBrandModel]?
}

class SPBannerModel : SPBaseModel {
    var link : String?
    var linktarget : String?
    var linkinfo : String?
    var linktype : String?
    var imagesrc : String?
    var webview : String?
    var webparam : [String:Any]?
}

class SPIndexIconModel : SPBaseModel{
    var tag : String?
    var linktype : String?
    var linktarget: String?
    var image : String?
    var imagesrc : String?
    var webview : String?
    var webparam : [String:Any]?
}

class SPIndexCategoryModel : SPBaseModel{
    var categoryname : String?
    var linkinfo : String?
    var cat_id : String?
    var image : String?
    var imagesrc : String?
    var webview : String?
    var webparam : [String:Any]?
}
