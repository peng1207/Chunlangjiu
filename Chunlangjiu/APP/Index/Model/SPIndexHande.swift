//
//  SPIndexHande.swift
//  Chunlangjiu
//
//  Created by chengzong liang on 2018/9/6.
//  Copyright © 2018年 Chunlang. All rights reserved.
//

import Foundation

class SPIndexHande : NSObject {
    
    class func sp_deal(viewController:UIViewController,lineType : String?,linktarget : String? ,webparam :[String : Any]?,name:String? = nil,webview:String? = nil){
        switch sp_getString(string: lineType) {
        case SPIndexType.item.rawValue:
 
                if let itemID = Int(sp_getString(string: linktarget)){
                    let productDetaile = SPProductDetaileVC()
                    let productModel = SPProductModel()
                     productModel.item_id = itemID
                    productDetaile.productModel = productModel
                    viewController.navigationController?.pushViewController(productDetaile, animated: true)
                }
        case SPIndexType.shop.rawValue:
 
                if let shopId = Int(sp_getString(string:linktarget)) {
                    let shopVC = SPShopHomeVC()
                    let shopModel = SPShopModel()
                     shopModel.shop_id = shopId
                    shopVC.shopModel = shopModel
                    viewController.navigationController?.pushViewController(shopVC, animated: true)
                }
 
        case SPIndexType.category.rawValue:
            NotificationCenter.default.post(name: NSNotification.Name(SP_CHANGETABBAR_NOTIIFICATION), object: ["index":"\(SP_TAB_SORT)"])
        case SPIndexType.brand.rawValue:

                if let brandId = Int(sp_getString(string: linktarget)){
                    let productVC = SPProductListVC()
                    let brandModel = SPBrandModel()
                    brandModel.brand_id = brandId
                    brandModel.brand_name = sp_getString(string: name)
                    productVC.brandModel = brandModel
                     viewController.navigationController?.pushViewController(productVC, animated: true)
                }

        case SPIndexType.winery.rawValue:
            let wineryVC = SPWineryVC()
            viewController.navigationController?.pushViewController(wineryVC, animated: true)
        case SPIndexType.evaluation.rawValue:
//            if SPAPPManager.sp_isLogin(isPush: true){
//                let valuationVC = SPWineValuationVC()
//                viewController.navigationController?.pushViewController(valuationVC, animated: true)
//            }
            let vc = SPAppraisalChoiceVC()
            viewController.navigationController?.pushViewController(vc, animated: true)
        case SPIndexType.cart.rawValue:
            NotificationCenter.default.post(name: NSNotification.Name(SP_CHANGETABBAR_NOTIIFICATION), object: ["index":"\(SP_TAB_SHOPCART)"])
        case SPIndexType.member.rawValue:
            NotificationCenter.default.post(name: NSNotification.Name(SP_CHANGETABBAR_NOTIIFICATION), object: ["index":"\(SP_TAB_MINE)"])
        case SPIndexType.auction.rawValue:
            NotificationCenter.default.post(name: NSNotification.Name(SP_CHANGETABBAR_NOTIIFICATION), object: ["index":"\(SP_ISSHOW_AUCTION ? SP_TAB_AUCTION : SP_TAB_SORT)"])
        case SPIndexType.activity.rawValue:
            let activityVC = SPActivityVC()
            activityVC.activity_id = sp_getString(string: webview)
            viewController.navigationController?.pushViewController(activityVC, animated: true)
        case SPIndexType.h5.rawValue:
            if sp_getString(string: linktarget).count > 0 {
                let webVC = SPWebVC()
                webVC.url = URL(string: sp_getString(string: linktarget))
                viewController.navigationController?.pushViewController(webVC, animated: true)
            }
        case SPIndexType.sellwine.rawValue:
            sp_sellwine(viewController: viewController)
        case SPIndexType.partner.rawValue:
            sp_pushPartnerVC(viewController: viewController)
        default:
            sp_log(message: "没有找到 点击没有反应")
        }
    }
    /// 跳到添加商品页面
    ///
    /// - Parameter viewController: 当前控制器
    class func sp_sellwine(viewController:UIViewController){
        if SPAPPManager.sp_isLogin(isPush: true) == false {
            return
        }
        
        
        sp_showAnimation(view: viewController.view, title: nil)
        let group = DispatchGroup() //创建group
        var companyAuth : SPCompanyAuth?
        var realNameAuth : SPRealNameAuth?
        group.enter()
        let request = SPRequestModel()
        SPAppRequest.sp_getCompanyAuthStatus(requestModel: request) { (code , model, errorModel) in
            if code == SP_Request_Code_Success{
                companyAuth = model
            }
            group.leave()
        }
         group.enter()
        let realRequest = SPRequestModel()
        SPAppRequest.sp_getRealNameAuth(requestModel: realRequest) { (code , model , errorModel) in
            if code == SP_Request_Code_Success{
               realNameAuth = model
            }
            group.leave()
        }
        
        group.notify(queue: .main) {
            sp_hideAnimation(view: viewController.view)
            if sp_getString(string: realNameAuth?.status) == SP_STATUS_FINISH  || sp_getString(string: realNameAuth?.status) == SP_STATUS_MODIFIER || sp_getString(string: companyAuth?.status) == SP_STATUS_FINISH || sp_getString(string: companyAuth?.status) == SP_STATUS_MODIFIER {
                let addProduct = SPProductAddVC()
                addProduct.title = "添加商品"
                viewController.navigationController?.pushViewController(addProduct, animated: true)
            }else{
                 sp_pushRealNameVC(viewController: viewController)
            }

        }
    }
    class func sp_pushRealNameVC(viewController:UIViewController){
        
        //
        let realVC = SPAuthHomeVC()
        viewController.navigationController?.pushViewController(realVC, animated: true)
    }
    /// 跳到城市合伙人界面
    ///
    /// - Parameter viewController: 当前控制器
    class func sp_pushPartnerVC(viewController:UIViewController){
        let partnerVC = SPPartnerVC()
        viewController.navigationController?.pushViewController(partnerVC, animated: true)
    }
    
    class func sp_getLintTypeName(lineType : String?)->String{
        var name = ""
        switch sp_getString(string: lineType) {
        case SPIndexType.item.rawValue:
            name = "商品详情"
        case SPIndexType.shop.rawValue:
            name = "店铺"
        case SPIndexType.category.rawValue:
            name = "分类 "
        case SPIndexType.brand.rawValue:
           name = "品牌"
        case SPIndexType.winery.rawValue:
            name = "名庄查询"
        case SPIndexType.evaluation.rawValue:
           name = "名酒估价"
        case SPIndexType.cart.rawValue:
           name = "购物车"
        case SPIndexType.member.rawValue:
            name = "我的"
        case SPIndexType.activity.rawValue:
            name = SP_ISSHOW_AUCTION ? "竞拍" : "全部"
        case SPIndexType.h5.rawValue:
           name = "网页"
        case SPIndexType.sellwine.rawValue:
            name = "添加商品"
        default:
            name = ""
        }
        
        return name
        
    }
    
}


