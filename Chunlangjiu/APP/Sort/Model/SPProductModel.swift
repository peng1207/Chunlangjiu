//
//  SPProductModel.swift
//  Chunlangjiu
//
//  Created by 黄树鹏 on 2018/8/5.
//  Copyright © 2018年 Chunlang. All rights reserved.
//

import Foundation
import HandyJSON
 
class SPProductModel :  HandyJSON {
    /// 商品ID
    var item_id : Int! = 0
    /// 分类ID
    var cart_id : String?
    /// skuID
    var sku_id : String?
    /// 名称
    var title : String?
    /// 默认图片
    var image_default_id : String?
    /// 图片地址
    var imgsrc : String?
    /// 价格
    var price : String?
    /// 购物车展示价格
    var showCartPrice : String?
    /// 数量
    var sold_quantity : Int! = 0
    /// 数量
    var quantity : Int! = 0
    var gift : String?
    var promotion : [String]?
    var shop_id : Int?
    var cat_id : String?
    var brand_id : String?
    var shop_cat_id : String?
    var sub_title : String?
    var bn : String?
    var cost_price : String?
    var mkt_price : String?
    var show_mkt_price : String?
    var weight : String?
    var unit : String?
    var order_sort : String?
    var created_time : String?
    var modified_time : String?
    var has_discount : String?
    var is_virtual : String?
    var is_timing : String?
    var violation : String?
    var is_selfshop : String?
    var nospec : String?
    var props_name : String?
    var params : String?
    var sub_stock : String?
    var outer_id : String?
    var is_offline : Int?
    var barcode : String?
    var disabled : Int! = 0
    var use_platform : String?
    var dlytmpl_id : String?
    var approve_status : String?
    var reason : String?
    var list_time : String?
    var delist_time : String?
    var rate_count : Int! = 0
    var rate_good_count : Int! = 0
    var rate_neutral_count : Int! = 0
    var rate_bad_count : Int! = 0
    var view_count : Int! = 0
    var buy_count : Int! = 0
    var aftersales_month_count : Int! = 0
    var is_checked : Int = 0
    var default_weight : String?
    var images : [String]?
    var brand_name : String?
    var brand_alias : String?
    var brand_logo : String?
    var total_price : String?
    var discount_price : String?
    var realStore : String?
    var freez : String?
    var store : Int! = 0
    var natureProps : [[String:Any]]?
    var valid : String?
    /// 规格
    var spec : [String:Any]?
    /// 是否竞拍商品
    var isAuction : Bool = false
    /// 竞拍 起拍价
    var auction_starting_price : String?
    /// 最高价格
    var max_price : String?
    var check : String?
    /// 是否支付
    var is_pay : String?
    var pledge : String? 
    /// 竞拍状态
    var auction_status : String?  // 明拍还是暗拍 true 明 false 暗
    ///
    var auction_store : Int!
    /// 竞拍开始时间
    var auction_begin_time : String?
    /// 竞拍结束时间
    var auction_end_time : String?
    /// 竞拍出价数
    var auction_number : Int! = 0
    /// 竞拍ID
    var auctionitem_id : String?
    var original_bid : String? 
    var desc : String?
    /// 秒数
    var second : Int! = 0
    /// 标签
    var label : String?
    /// 说明
    var explain : String?
    /// 是否收藏
    var is_collect : String?
    /// 地区ID
    var area_id : String?
    ///
    var odor_id : String?
    /// 酒精度ID
    var alcohol_id : String?
    /// 商品参数
    var parameter : String?
    /// 支付ID
    var payment_id  : String?
    /// 规则
    var rule : String?
    /// 店铺名称
    var shop_name : String?
    /// 店铺等级
    var grade : String?
    /// 好评数
    var rate  : String?
    /// 服务保障图片地址
    var service_url : String?
    required init() {}
    func mapping(mapper: HelpingMapper) {
        mapper.specify(property: &showCartPrice, name: "price.price") { (rawString) -> String in
            return sp_getString(string: rawString)
        }
        mapper.specify(property: &total_price, name: "price.total_price")
        mapper.specify(property: &discount_price, name: "price.discount_price")
    }
    
    class func sp_deserialize(from:String) -> Self?  {
        return self.deserialize(from: from)
    }
    class func sp_deserialize(from : [String : Any]?) -> Self?  {
        return self.deserialize(from: from)
    }
    /// 获取原价还是竟拍起价
    ///
    /// - Returns: 对应的价格
    func sp_getdefaultPrice()->NSAttributedString{
          let startAtt = NSMutableAttributedString()
        if self.isAuction {
            let startTitleAtt = NSAttributedString(string: "起拍价:", attributes: [NSAttributedStringKey.font : sp_getFontSize(size: 12),NSAttributedStringKey.foregroundColor : SPColorForHexString(hex: SP_HexColor.color_999999.rawValue)])
            
            startAtt.append(startTitleAtt)
            let startPriceAtt = NSAttributedString(string: "\(SP_CHINE_MONEY)\(sp_getString(string:self.auction_starting_price))", attributes: [NSAttributedStringKey.font : sp_getFontSize(size: 12),NSAttributedStringKey.foregroundColor : SPColorForHexString(hex: SP_HexColor.color_999999.rawValue) /*,NSAttributedStringKey.strikethroughColor : SPColorForHexString(hex: SP_HexColor.color_999999.rawValue),NSAttributedStringKey.strikethroughStyle :  NSUnderlineStyle.styleSingle.rawValue*/])
            startAtt.append(startPriceAtt)
        }else{
//            if sp_getString(string: self.mkt_price).count > 0 {
//                if sp_compare(price: self.price, secondPrice: self.mkt_price) == true{
//                    let priceTitleAtt = NSAttributedString(string: "原价:", attributes: [NSAttributedStringKey.font : sp_getFontSize(size: 12),NSAttributedStringKey.foregroundColor : SPColorForHexString(hex: SP_HexColor.color_999999.rawValue)])
//
//                    startAtt.append(priceTitleAtt)
//                    let priceAtt = NSAttributedString(string: "\(SP_CHINE_MONEY)\(sp_getString(string:self.mkt_price))", attributes: [NSAttributedStringKey.font : sp_getFontSize(size: 12),NSAttributedStringKey.foregroundColor : SPColorForHexString(hex: SP_HexColor.color_999999.rawValue),NSAttributedStringKey.strikethroughColor : SPColorForHexString(hex: SP_HexColor.color_999999.rawValue),NSAttributedStringKey.strikethroughStyle :  NSUnderlineStyle.styleSingle.rawValue])
//                    startAtt.append(priceAtt)
//                }
//            }
        }
        
        
       
        

        
        return startAtt
    }
    
    /// 获取最高出价
    ///
    /// - Returns: 价格
    func sp_getMaxPrice()->NSAttributedString{
        let maxAtt = NSMutableAttributedString()
        let auction_status : Bool? = Bool(sp_getString(string: self.auction_status))
        
        if let status = auction_status , status == true {
            let maxTitleAtt = NSAttributedString(string: "最高出价:", attributes: [NSAttributedStringKey.font : sp_getFontSize(size: 12),NSAttributedStringKey.foregroundColor : SPColorForHexString(hex: SP_HexColor.color_999999.rawValue)])
            maxAtt.append(maxTitleAtt)

            let maxPriceAtt = NSAttributedString(string:  sp_getString(string: self.max_price).count  > 0 ? "\(SP_CHINE_MONEY)\(sp_getString(string: self.max_price))" : sp_getString(string: "暂无出价"), attributes: [NSAttributedStringKey.font : sp_getFontSize(size: 16),NSAttributedStringKey.foregroundColor : SPColorForHexString(hex: SP_HexColor.color_c11f2f.rawValue)])
            maxAtt.append(maxPriceAtt)
            
        }else {
            maxAtt.append( NSAttributedString(string:"暗拍商品，保密出价", attributes: [NSAttributedStringKey.font : sp_getFontSize(size: 14),NSAttributedStringKey.foregroundColor : SPColorForHexString(hex: SP_HexColor.color_ff9600.rawValue)]))
        }
        return maxAtt
    }
    func sp_set(second : Int = 1){
        self.second = self.second - second
        sp_dealSecond()
    }
    func sp_getSecond(){
        let nowTimeIntervale  = SPDateManager.sp_timeInterval(to: Date())
        if sp_getString(string: self.auction_end_time).count > 0  {
            if let endTimeIntervale = Int(sp_getString(string: self.auction_end_time)){
                self.second = endTimeIntervale - Int(nowTimeIntervale)
                sp_dealSecond()
            }
        }
    }
    fileprivate func sp_dealSecond(){
        if self.second < 0 {
            self.second = 0
        }
    }
     func sp_getLabel()->[String]{
        if sp_getString(string: self.label).count > 0 {
            if sp_getString(string: self.label).contains("，") {
                return sp_getString(string: self.label).components(separatedBy: "，")
            }else if sp_getString(string: self.label).contains(","){
                return sp_getString(string: self.label).components(separatedBy: ",")
            }else {
                return sp_getString(string: self.label).components(separatedBy: " ")
            }
        }
       return [String]()
    }
    func sp_getTitleAtt()->NSAttributedString{
         let attributedString:NSMutableAttributedString = NSMutableAttributedString(string: sp_getString(string: self.title))
        let paragraphStyle:NSMutableParagraphStyle = NSMutableParagraphStyle()
        
        paragraphStyle.lineSpacing = 5 //大小调整
        
        attributedString.addAttribute(NSAttributedStringKey.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, sp_getString(string: self.title).count))
        return attributedString
    }
}

