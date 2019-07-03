//
//  SPAPPRequestComplete.swift
//  Chunlangjiu
//
//  Created by 黄树鹏 on 2018/8/5.
//  Copyright © 2018年 Chunlang. All rights reserved.
//

import Foundation
/// 返回数组的回调
typealias SPRequestCompletList = (_ code : String,_ list:[Any]?,_ errorModel:SPRequestError?,_ totalPage:Int) -> Void
/// 返回json数据回调
typealias SPRequestJsonBlock = (_ jsonData : [String : Any]?) ->Void
/// 获取商品详情回调
typealias SPProductDetaileComplete = (_ code : String,_ detaileModel:SPProductDetailModel?, _ errorModel:SPRequestError?) -> Void
/// 默认的回调 返回code msg 和错误的model
typealias SPRequestDefaultComplete = (_ code: String,_ msg:String,_ errorModel:SPRequestError?)->Void
/// 获取会员中心数量
typealias SPMemberCountComplete = (_ code : String,_ model : SPMineCountModel?, _ errorModel:SPRequestError?)->Void
/// 获取会员信息
typealias SPMemberInfoComplete = (_ code : String,_ model : SPMemberModel?, _ errorModel:SPRequestError?)->Void
/// 获取酒庄详情回调
typealias SPWinerDetaileComplete = (_ code : String,_ model : SPWinerDetaileModel?,_ errorModel : SPRequestError?)-> Void
/// 获取筛选回调
typealias SPFilterComplete = (_ code :String , _ model: SPFilterModel?,_ errorModel:SPRequestError?) -> Void
/// 获取确认订单回调
typealias SPConfirmOrderComplete = (_ code:String, _ msg : String , _ model : SPConfirmOrderModel? , _ errorModel : SPRequestError?)->Void
/// 确认订单获取金额
typealias SPConfirmOrderPriceComplete = (_ code :String,_ msg : String, _ model : SPConfirmOrderPrice?,_ errorModel : SPRequestError?)->Void
/// 创建订单回调
typealias SPCreateOrderComplete = (_ code:String,_ msg : String,_ model : SPOrderPayModel?,_ errorModel:SPRequestError?)-> Void
/// 去支付回调
typealias SPTopayComplete = (_ data:[String:Any]?,_ errorModel : SPRequestError?)-> Void
/// 获取首页的数据
typealias SPIndexComplete = (_ code :String,_ model : SPIndexModel?,_ errorModel : SPRequestError?)->Void
/// 获取首页商品数据
typealias SPIndexGoodComplete = (_ code : String,_ auction : [SPProductModel]?,_ goods : [SPProductModel]?,_ errorModel : SPRequestError?,_ total : Int)->Void
/// 获取购物车数据
typealias SPShopCartCountComplete = (_ code: String,_ model : SPShopCarCount?,_ errorModel : SPRequestError?)->Void
/// 获取店铺信息
typealias SPShopComplete = (_ code: String, _ model : SPShopModel?,_ errorModel : SPRequestError?)-> Void
/// 获取订单详情
typealias SPOrderDetaileComplete = (_ code : String,_ model : SPOrderDetaileModel?,_ errorModel : SPRequestError?)->Void
/// 上传图片的回调
typealias SPUploadImageComplete = (_ code : String,_ msg : String,_ model : SPUploadImage?,_ errorModel : SPRequestError?)->Void
/// 企业认证状态回调
typealias SPCompanyAuthComplete = (_ code : String,_ model  : SPCompanyAuth?,_ errorModel : SPRequestError?)-> Void
/// 实名认证状态回调
typealias SPRealNameAuthComplete = (_ code : String,_ model : SPRealNameAuth?,_ errorModel : SPRequestError?)->Void
/// 获取商品详情
typealias SPPorudctDetComplete = (_ code : String,_ model : SPProductModel?,_ errorModel : SPRequestError?)->Void
/// 获取版本信息
typealias SPAPPVersionComplete = (_ code : String, _ model : SPUpdateModel?,_ errorModel : SPRequestError?)->Void
/// 我的资金
typealias SPFundsMoneyComplete = (_ code : String,_ model :SPMoneyModel?,_ msg : String,_ errorModel : SPRequestError?)->Void
/// 获取银行卡信息
typealias SPFundBankCardComplete = (_ code : String,_ model : SPBankCardInfoModel?,_ msg : String,_ errorModel : SPRequestError?)->Void
/// 获取保证金信息
typealias SPDepoistComplete = (_ code : String,_ msg : String,_ model : SPDepositModel?,_ errorModel:SPRequestError?)->Void
/// 获取粉丝数量
typealias SPFansComplete = (_ code : String,_ msg : String,_ model : SPFansModel?,_ errorModel : SPRequestError?)->Void
/// 获取邀请码
typealias SPInvitationCodeComplete = (_ code : String,_ msg : String,_ shareModel : SPFansShareModel?  ,_ errorModel : SPRequestError?)->Void
/// 获取开屏广告的回调
typealias SPOpenAdvComplete = (_ code : String,_ model : SPOpenAdvModel?,_ errorModel : SPRequestError?)->Void
/// 检查商品是否发布
typealias SPCheckProductComplete = (_ code : String,_ data : [String : Any]?,_ errorModel : SPRequestError?)->Void
/// 获取余额状态
typealias SPBalanceStatusComplete = (_ code : String,_ model : SPBalanceStatus?,_ errorModel : SPRequestError?)->Void
/// 获取活动列表
typealias SPActivityListComplete = (_ code :String, _ model : SPActivityModel?,_ errorModel : SPRequestError?)->Void
/// 获取资金明细详情
typealias SPCapitalDetDetComplete = (_ code : String, _ model : SPCapitalDetContentModel?,_ errorModel : SPRequestError?)->Void
/// 获取鉴定师信息
typealias SPAppraisalInfoComplete = (_ code :String, _  model : SPAppraisalInfoModel?, _ errrorModel : SPRequestError?)->Void
/// 获取鉴定详情
typealias SPAppraisalDetComplete = (_ code : String, _ model : SPAppraisalProductModel? , _ errorModel : SPRequestError?)->Void
/// 第三方登录回调
typealias SPThirdLoginComplete = (_ code : String, _ binded : String,_ msg : String,_ errorModel : SPRequestError?)->Void
/// 获取鉴定 商品数量
typealias SPGetAppraisalCountComplete = (_ true_count : String,_ false_count : String)->Void
/// 获取选择鉴定师 表头数据
typealias SPChoiceAppraisalComplete = (_ count : String, _ content : String)->Void
