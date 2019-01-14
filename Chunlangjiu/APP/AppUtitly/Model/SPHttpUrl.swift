//
//  SPHttpUrl.swift
//  Chunlangjiu
//
//  Created by 黄树鹏 on 2018/8/4.
//  Copyright © 2018年 Chunlang. All rights reserved.
//

import Foundation


/// 域名
//let SP_MAIN_DOMAIN_NAME  =   "http://mall.chunlangjiu.com"
let SP_MAIN_DOMAIN_NAME  =   "http://test.chunlangjiu.com"
/// 保存域名对应的key
let SP_MAIN_DOMAIN_NAME_KEY = "SP_MAIN_DOMAIN_NAME_KEY"

let SP_SHARE_URL = "\(SPNetWorkManager.instance().sp_getDomainName(key: SP_MAIN_DOMAIN_NAME_KEY))/appdownload/index.html"

/*-----------------------买家的接口--------------------------*/
///  登录
let SP_GET_LONGIN_URL = "\(SPNetWorkManager.instance().sp_getDomainName(key: SP_MAIN_DOMAIN_NAME_KEY))/index.php/topapi?method=user.oauthlogin"
/// 密码登录
let SP_GET_PWDLOGIN_URL = "\(SPNetWorkManager.instance().sp_getDomainName(key: SP_MAIN_DOMAIN_NAME_KEY))/index.php/topapi?method=user.login"
///  获取分类
let SP_GET_CATEGORY = "\(SPNetWorkManager.instance().sp_getDomainName(key: SP_MAIN_DOMAIN_NAME_KEY))/index.php/topapi?method=category.itemCategory"
/// 获取商品列表
let SP_GET_PRODUCT_URL = "\(SPNetWorkManager.instance().sp_getDomainName(key: SP_MAIN_DOMAIN_NAME_KEY))/index.php/topapi?method=item.search"
/// 获取商品详情
let SP_GET_PRODUCT_DETAILE_URL = "\(SPNetWorkManager.instance().sp_getDomainName(key: SP_MAIN_DOMAIN_NAME_KEY))/index.php/topapi?method=item.detail"
/// 获取商品推荐
let SP_GET_PRODUCT_RECOMMEND_URL = "\(SPNetWorkManager.instance().sp_getDomainName(key: SP_MAIN_DOMAIN_NAME_KEY))/index.php/topapi?method=item.recommend"
/// 获取评价列表
let SP_GET_EVALUATE_URL     = "\(SPNetWorkManager.instance().sp_getDomainName(key: SP_MAIN_DOMAIN_NAME_KEY))/index.php/topapi?method=item.rate.list"
/// 获取筛选数据
let SP_GET_FILTER_URL     = "\(SPNetWorkManager.instance().sp_getDomainName(key: SP_MAIN_DOMAIN_NAME_KEY))/index.php/topapi?method=item.filterItems"
/// 发送验证码
let SP_GET_SENDSMS_URL  = "\(SPNetWorkManager.instance().sp_getDomainName(key: SP_MAIN_DOMAIN_NAME_KEY))/index.php/topapi?method=user.sendSms"
/// 获取地址列表
let SP_GET_ADDRESSLIST_URL = "\(SPNetWorkManager.instance().sp_getDomainName(key: SP_MAIN_DOMAIN_NAME_KEY))/index.php/topapi?method=member.address.list"
/// 新建地址
let SP_GET_ADD_ADDRESS_URL = "\(SPNetWorkManager.instance().sp_getDomainName(key: SP_MAIN_DOMAIN_NAME_KEY))/index.php/topapi?method=member.address.create"
///  更新地址
let SP_GET_UPDATE_ADDRESS_URL = "\(SPNetWorkManager.instance().sp_getDomainName(key: SP_MAIN_DOMAIN_NAME_KEY))/index.php/topapi?method=member.address.update"
///  删除地址
let SP_GET_DELETE_ADDRESS_URL = "\(SPNetWorkManager.instance().sp_getDomainName(key: SP_MAIN_DOMAIN_NAME_KEY))/index.php/topapi?method=member.address.delete"
/// 设置默认地址
let SP_GET_DEFAULT_ADDRESS_URL  = "\(SPNetWorkManager.instance().sp_getDomainName(key: SP_MAIN_DOMAIN_NAME_KEY))/index.php/topapi?method=member.address.setDefault"
/// 获取省市区
let SP_GET_REGION_URL = "\(SPNetWorkManager.instance().sp_getDomainName(key: SP_MAIN_DOMAIN_NAME_KEY))/index.php/topapi?method=region.json"
/// 获取会员中心页面数据统计
let SP_GET_MEMBER_COUNT_URL = "\(SPNetWorkManager.instance().sp_getDomainName(key: SP_MAIN_DOMAIN_NAME_KEY))/index.php/topapi?method=member.index"
/// 获取会员信息
let SP_GET_MEMBER_INFO_URL = "\(SPNetWorkManager.instance().sp_getDomainName(key: SP_MAIN_DOMAIN_NAME_KEY))/index.php/topapi?method=member.basics.get"
/// 酒庄分类
let SP_GET_WINERSORT_URL = "\(SPNetWorkManager.instance().sp_getDomainName(key: SP_MAIN_DOMAIN_NAME_KEY))/index.php/topapi?method=category.chateauCat"
/// 酒庄列表
let SP_GET_WINERLIST_URL = "\(SPNetWorkManager.instance().sp_getDomainName(key: SP_MAIN_DOMAIN_NAME_KEY))/index.php/topapi?method=category.chateauList"
/// 酒庄详情
let SP_GET_WINERDETAILE_URL = "\(SPNetWorkManager.instance().sp_getDomainName(key: SP_MAIN_DOMAIN_NAME_KEY))/index.php/topapi?method=category.chateauDetail"
/// 添加购物车
let SP_GET_ADDPRODUCT_URL = "\(SPNetWorkManager.instance().sp_getDomainName(key: SP_MAIN_DOMAIN_NAME_KEY))/index.php/topapi?method=cart.add"
/// 获取购物车数据
let SP_GET_GERSHOPCART_URL  =  "\(SPNetWorkManager.instance().sp_getDomainName(key: SP_MAIN_DOMAIN_NAME_KEY))/index.php/topapi?method=cart.get"
/// 购物车结算
let SP_GET_CONFIRMORDER_URL = "\(SPNetWorkManager.instance().sp_getDomainName(key: SP_MAIN_DOMAIN_NAME_KEY))/index.php/topapi?method=cart.checkout"
/// 购物车更新
let SP_GET_UPDATESHOPCART_URL = "\(SPNetWorkManager.instance().sp_getDomainName(key: SP_MAIN_DOMAIN_NAME_KEY))/index.php/topapi?method=cart.update"
/// 购物车删除
let SP_GET_DELETESHOPCART_URL = "\(SPNetWorkManager.instance().sp_getDomainName(key: SP_MAIN_DOMAIN_NAME_KEY))/index.php/topapi?method=cart.del"
/// 添加收藏
let SP_GET_ADDCOLLECT_URL = "\(SPNetWorkManager.instance().sp_getDomainName(key: SP_MAIN_DOMAIN_NAME_KEY))/index.php/topapi?method=member.favorite.item.add"
/// 移除收藏
let SP_GET_REMOVECOLLECT_URL = "\(SPNetWorkManager.instance().sp_getDomainName(key: SP_MAIN_DOMAIN_NAME_KEY))/index.php/topapi?method=member.favorite.item.remove"
///  创建订单
let SP_GET_CREATEOREDER_URL = "\(SPNetWorkManager.instance().sp_getDomainName(key: SP_MAIN_DOMAIN_NAME_KEY))/index.php/topapi?method=trade.create"
/// 获取支付列表
let SP_GET_PAYLIST_URL = "\(SPNetWorkManager.instance().sp_getDomainName(key: SP_MAIN_DOMAIN_NAME_KEY))/index.php/topapi?method=payment.pay.paycenter"
/// 获取确认订单金额
let SP_GET_TOTALPRICE_URL = "\(SPNetWorkManager.instance().sp_getDomainName(key: SP_MAIN_DOMAIN_NAME_KEY))/index.php/topapi?method=cart.total"
/// 去支付
let SP_GET_TOPAY_URL = "\(SPNetWorkManager.instance().sp_getDomainName(key: SP_MAIN_DOMAIN_NAME_KEY))/index.php/topapi?method=payment.pay.do"
/// 获取商品分类
let SP_GET_INDEX_URL = "\(SPNetWorkManager.instance().sp_getDomainName(key: SP_MAIN_DOMAIN_NAME_KEY))/index.php/topapi?method=theme.modules"
/// 获取购物车数量
let SP_GET_SHOPCARTCOUNT_URL = "\(SPNetWorkManager.instance().sp_getDomainName(key: SP_MAIN_DOMAIN_NAME_KEY))/index.php/topapi?method=cart.count"
/// 获取首页商品数据
let SP_GET_INDEXGOODS_URL = "\(SPNetWorkManager.instance().sp_getDomainName(key: SP_MAIN_DOMAIN_NAME_KEY))/index.php/topapi?method=theme.pull.goods"
/// 获取店铺数据
let SP_GET_SHOPDATE_URL = "\(SPNetWorkManager.instance().sp_getDomainName(key: SP_MAIN_DOMAIN_NAME_KEY))/index.php/topapi?method=shop.basic"
/// 获取订单列表
let SP_GET_ORDERLIST_URL = "\(SPNetWorkManager.instance().sp_getDomainName(key: SP_MAIN_DOMAIN_NAME_KEY))/index.php/topapi?method=trade.list"
/// 获取订单详情
let SP_GET_ORDERDETAILE_URL = "\(SPNetWorkManager.instance().sp_getDomainName(key: SP_MAIN_DOMAIN_NAME_KEY))/index.php/topapi?method=trade.get"
/// 取消订单
let SP_GET_CANCEORDER_URL = "\(SPNetWorkManager.instance().sp_getDomainName(key: SP_MAIN_DOMAIN_NAME_KEY))/index.php/topapi?method=trade.cancel.create"
/// 确认收货
let SP_GET_ORDERCONFIRM_URL = "\(SPNetWorkManager.instance().sp_getDomainName(key: SP_MAIN_DOMAIN_NAME_KEY))/index.php/topapi?method=trade.confirm"
/// 获取取消原因列表
let SP_GET_ORDERCANCEREASON_URL = "\(SPNetWorkManager.instance().sp_getDomainName(key: SP_MAIN_DOMAIN_NAME_KEY))/index.php/topapi?method=trade.cancel.reason.get"
/// 创建支付订单
let SP_GET_CREATEPAYORDER_URL = "\(SPNetWorkManager.instance().sp_getDomainName(key: SP_MAIN_DOMAIN_NAME_KEY))/index.php/topapi?method=payment.pay.create"
/// 获取申请退货退款的理由
let SP_GET_REFUNDAPPLYINFO_URL = "\(SPNetWorkManager.instance().sp_getDomainName(key: SP_MAIN_DOMAIN_NAME_KEY))/index.php/topapi?method=member.aftersales.applyInfo.get"
/// 申请退货退款
let SP_GET_APPLYREFUND_URL = "\(SPNetWorkManager.instance().sp_getDomainName(key: SP_MAIN_DOMAIN_NAME_KEY))/index.php/topapi?method=member.aftersales.apply"
/// 买家上传图片
let SP_GET_UPLOADIMG_URL = "\(SPNetWorkManager.instance().sp_getDomainName(key: SP_MAIN_DOMAIN_NAME_KEY))/index.php/topapi?method=image.upload"
/// 评价商品
let SP_GET_PRODUCTRATE_URL = "\(SPNetWorkManager.instance().sp_getDomainName(key: SP_MAIN_DOMAIN_NAME_KEY))/index.php/topapi?method=member.rate.add"
/// 获取申请售后退货列表
let SP_GET_AFTERSALES_URL = "\(SPNetWorkManager.instance().sp_getDomainName(key: SP_MAIN_DOMAIN_NAME_KEY))/index.php/topapi?method=member.aftersales.list"
/// 获取申请售后的订单详情
let SP_GET_AFTERSALESDET_URL = "\(SPNetWorkManager.instance().sp_getDomainName(key: SP_MAIN_DOMAIN_NAME_KEY))/index.php/topapi?method=member.aftersales.get"
/// 获取竞拍专区数据
let SP_GET_AUCTIONLIST_URL = "\(SPNetWorkManager.instance().sp_getDomainName(key: SP_MAIN_DOMAIN_NAME_KEY))/index.php/topapi?method=item.auction.list"
/// 竞拍商品出价
let SP_GET_AUCTIONADDPRICE_URL = "\(SPNetWorkManager.instance().sp_getDomainName(key: SP_MAIN_DOMAIN_NAME_KEY))/index.php/topapi?method=item.auction.userAdd"
/// 获取竞拍出价列表
let SP_GET_AUCTIONGETPRICELIST_URL = "\(SPNetWorkManager.instance().sp_getDomainName(key: SP_MAIN_DOMAIN_NAME_KEY))/index.php/topapi?method=item.auction.get"
/// 提交推送的ID
let SP_GET_PUSH_URL = "\(SPNetWorkManager.instance().sp_getDomainName(key: SP_MAIN_DOMAIN_NAME_KEY))/index.php/topapi?method=message.push.register"
/// 获取物流信息
let SP_GET_LOGISITICSLIST_URL = "\(SPNetWorkManager.instance().sp_getDomainName(key: SP_MAIN_DOMAIN_NAME_KEY))/index.php/topapi?method=logistics.list.get"
///  用户 退货 填写物流信息
let SP_GER_SENDREFUND_URL = "\(SPNetWorkManager.instance().sp_getDomainName(key: SP_MAIN_DOMAIN_NAME_KEY))/index.php/topapi?method=logistics.send"
/// 删除订单
let SP_GET_DELETEORDER_URL = "\(SPNetWorkManager.instance().sp_getDomainName(key: SP_MAIN_DOMAIN_NAME_KEY))/index.php/topapi?method=trade.delete"
/// 用户设置头像
let SP_GET_USERHEADIMG_URL = "\(SPNetWorkManager.instance().sp_getDomainName(key: SP_MAIN_DOMAIN_NAME_KEY))/index.php/topapi?method=member.setImg"
///  实名认证
let SP_GET_AUTONYM_URL = "\(SPNetWorkManager.instance().sp_getDomainName(key: SP_MAIN_DOMAIN_NAME_KEY))/index.php/topapi?method=member.autonym"
/// 商品估价
let SP_GET_VALUATION_URL = "\(SPNetWorkManager.instance().sp_getDomainName(key: SP_MAIN_DOMAIN_NAME_KEY))/index.php/topapi?method=member.evaluate"
/// 竞拍 创建押金支付单
let SP_GET_AUCTIONCREARE_URL = "\(SPNetWorkManager.instance().sp_getDomainName(key: SP_MAIN_DOMAIN_NAME_KEY))/index.php/topapi?method=payment.pay.auctionCreate"
/// 竞拍 确认订单
let SP_GET_AUCTIONCONFIRM_URL = "\(SPNetWorkManager.instance().sp_getDomainName(key: SP_MAIN_DOMAIN_NAME_KEY))/index.php/topapi?method=item.auction.detail"
/// 获取竞拍订单
let SP_GET_SHOP_AUCTIONLIST_URL = "\(SPNetWorkManager.instance().sp_getDomainName(key: SP_MAIN_DOMAIN_NAME_KEY))/index.php/topapi?method=trade.auction.list"
/// 忘记密码
let SP_GET_FORGETPWD_URL = "\(SPNetWorkManager.instance().sp_getDomainName(key: SP_MAIN_DOMAIN_NAME_KEY))/index.php/topapi?method=user.forgot.resetpassword"
/// 企业认证
let SP_GET_COMPANYAUTH_URL = "\(SPNetWorkManager.instance().sp_getDomainName(key: SP_MAIN_DOMAIN_NAME_KEY))/index.php/topapi?method=member.enterprise"
/// 获取企业认证状态
let SP_GET_COMPANYAUTHSTATUS_URL = "\(SPNetWorkManager.instance().sp_getDomainName(key: SP_MAIN_DOMAIN_NAME_KEY))/index.php/topapi?method=member.get.enterprise"
/// 获取个人认证状态
let SP_GET_REALNAMEAUTHSTATUS_URL = "\(SPNetWorkManager.instance().sp_getDomainName(key: SP_MAIN_DOMAIN_NAME_KEY))/index.php/topapi?method=member.get.autonym"
/// 退出登录
let SP_GET_LOGOUT_URL = "\(SPNetWorkManager.instance().sp_getDomainName(key: SP_MAIN_DOMAIN_NAME_KEY))/index.php/topapi?method=user.logout"
/// 获取分类下的产地
let SP_GET_PLACE_URL = "\(SPNetWorkManager.instance().sp_getDomainName(key: SP_MAIN_DOMAIN_NAME_KEY))/index.php/topapi?method=category.area.get"
/// 获取分类下的品牌
let SP_GET_BRAND_URL = "\(SPNetWorkManager.instance().sp_getDomainName(key: SP_MAIN_DOMAIN_NAME_KEY))/index.php/topapi?method=category.brand.get"
/// 获取分类下的香型
let SP_GET_TYPE_URL = "\(SPNetWorkManager.instance().sp_getDomainName(key: SP_MAIN_DOMAIN_NAME_KEY))/index.php/topapi?method=category.odor.get"
/// 获取分类下的酒精度
let SP_GET_ALCOHOL_URL = "\(SPNetWorkManager.instance().sp_getDomainName(key: SP_MAIN_DOMAIN_NAME_KEY))/index.php/topapi?method=category.alcohol.get"
/// 获取分类下的酒精度
let SP_GET_APPVERSION_URL = "\(SPNetWorkManager.instance().sp_getDomainName(key: SP_MAIN_DOMAIN_NAME_KEY))/index.php/topapi?method=app.versions"
/// 修改登陆密码
let SP_GET_MODIFY_LOGINPWD_URL = "\(SPNetWorkManager.instance().sp_getDomainName(key: SP_MAIN_DOMAIN_NAME_KEY))/index.php/topapi?method=member.security.updateLoginPassword"
/// 修改支付密码
let SP_GeT_MODIFY_PAYPWD_URL = "\(SPNetWorkManager.instance().sp_getDomainName(key: SP_MAIN_DOMAIN_NAME_KEY))/index.php/topapi?method=member.security.updatePayPassword"
/// 密码修改 发送验证码
let SP_GET_RESETSENDSMS_URL = "\(SPNetWorkManager.instance().sp_getDomainName(key: SP_MAIN_DOMAIN_NAME_KEY))/index.php/topapi?method=user.resetSendSms"
/// 获取银行卡列表
let SP_GET_BANKCARD_LIST_URL = "\(SPNetWorkManager.instance().sp_getDomainName(key: SP_MAIN_DOMAIN_NAME_KEY))/index.php/topapi?method=member.bank.list"
/// 删除银行卡
let SP_GET_BANKCARD_DELETE_URL = "\(SPNetWorkManager.instance().sp_getDomainName(key: SP_MAIN_DOMAIN_NAME_KEY))/index.php/topapi?method=member.bank.delete"
/// 添加银行卡
let SP_GET_BANKCARD_ADD_URL = "\(SPNetWorkManager.instance().sp_getDomainName(key: SP_MAIN_DOMAIN_NAME_KEY))/index.php/topapi?method=member.bank.add"
/// 根据银行卡号获取相对应银行信息
let SP_GET_BANKCARD_INFO_URL =  "\(SPNetWorkManager.instance().sp_getDomainName(key: SP_MAIN_DOMAIN_NAME_KEY))/index.php/topapi?method=member.bank.get"
/// 获取我的资金
let SP_GET_FUNDS_MONEY_URL = "\(SPNetWorkManager.instance().sp_getDomainName(key: SP_MAIN_DOMAIN_NAME_KEY))/index.php/topapi?method=member.money"
/// 我的资金提现
let SP_GET_FUNDS_CASH_URL = "\(SPNetWorkManager.instance().sp_getDomainName(key: SP_MAIN_DOMAIN_NAME_KEY))/index.php/topapi?method=member.deposit.cash"
/// 资金明细列表
let SP_GET_CAPITALDETLIST_URL = "\(SPNetWorkManager.instance().sp_getDomainName(key: SP_MAIN_DOMAIN_NAME_KEY))/index.php/topapi?method=member.fund"
/// 创建保证金订单
let SP_GET_DEPOSITCREATE_URL = "\(SPNetWorkManager.instance().sp_getDomainName(key: SP_MAIN_DOMAIN_NAME_KEY))/index.php/topapi?method=payment.pay.depositCreate"
/// 获取保证金信息
let SP_GET_DEPOSIT_URL = "\(SPNetWorkManager.instance().sp_getDomainName(key: SP_MAIN_DOMAIN_NAME_KEY))/index.php/topapi?method=member.deposit.get"
/// 粉丝及佣金汇总
let SP_Get_fANS_URL = "\(SPNetWorkManager.instance().sp_getDomainName(key: SP_MAIN_DOMAIN_NAME_KEY))/index.php/topapi?method=member.fans.sum"
/// 粉丝列表
let SP_GET_fANS_LIST_URL = "\(SPNetWorkManager.instance().sp_getDomainName(key: SP_MAIN_DOMAIN_NAME_KEY))/index.php/topapi?method=member.fans.list"
/// 创建充值订单
let SP_GET_RECHARGE_CREATE_URL = "\(SPNetWorkManager.instance().sp_getDomainName(key: SP_MAIN_DOMAIN_NAME_KEY))/index.php/topapi?method=payment.pay.storedCreate"
/// 获取我的邀请码
let SP_GET_INVITATIONCODE_URL = "\(SPNetWorkManager.instance().sp_getDomainName(key: SP_MAIN_DOMAIN_NAME_KEY))/index.php/topapi?method=member.code.get"
/// 输入邀请码
let SP_GET_INPUT_INVITATIONCODE_URL = "\(SPNetWorkManager.instance().sp_getDomainName(key: SP_MAIN_DOMAIN_NAME_KEY))/index.php/topapi?method=member.code.set"

/*-----------------------商家的接口--------------------------*/
/// 获取店铺 的分类
let SP_GET_SHOPSORT_URL = "\(SPNetWorkManager.instance().sp_getDomainName(key: SP_MAIN_DOMAIN_NAME_KEY))/shop/topapi?method=category.shop.get"
/// 获取平台分类
let SP_GET_PLATFORMCATEGIRY_URL = "\(SPNetWorkManager.instance().sp_getDomainName(key: SP_MAIN_DOMAIN_NAME_KEY))/index.php/shop/topapi?method=category.platform.get"
/// 获取品牌
let SP_GET_PLATFORMBRAND_URL = "\(SPNetWorkManager.instance().sp_getDomainName(key: SP_MAIN_DOMAIN_NAME_KEY))/index.php/shop/topapi?method=category.platform.brand.get"
/// 获取产地
let SP_GET_PLATFORMPLACE_URL = "\(SPNetWorkManager.instance().sp_getDomainName(key: SP_MAIN_DOMAIN_NAME_KEY))/index.php/shop/topapi?method=category.platform.area.get"
/// 获取香型
let SP_GET_PLATFORMTYPE_URL = "\(SPNetWorkManager.instance().sp_getDomainName(key: SP_MAIN_DOMAIN_NAME_KEY))/index.php/shop/topapi?method=category.platform.odor.get"
/// 获取酒精度
let SP_GET_PLATFORMALCOHOL_URL = "\(SPNetWorkManager.instance().sp_getDomainName(key: SP_MAIN_DOMAIN_NAME_KEY))/index.php/shop/topapi?method=category.platform.alcohol.get"
/// 商家 上传图片
let SP_GET_SHOPUPLOAD_URL = "\(SPNetWorkManager.instance().sp_getDomainName(key: SP_MAIN_DOMAIN_NAME_KEY))/shop/topapi?method=image.upload"
///  添加商品
let SP_GET_SHOPADDPRODUCT_URL = "\(SPNetWorkManager.instance().sp_getDomainName(key: SP_MAIN_DOMAIN_NAME_KEY))/shop/topapi?method=item.create"
/// 获取商家订单列表
let SP_GET_SHOPORDELIST_URL = "\(SPNetWorkManager.instance().sp_getDomainName(key: SP_MAIN_DOMAIN_NAME_KEY))/shop/topapi?method=trade.list"
/// 获取商家订单详情
let SP_GET_SHOPORDETINFO_URL = "\(SPNetWorkManager.instance().sp_getDomainName(key: SP_MAIN_DOMAIN_NAME_KEY))/shop/topapi?method=trade.info"
/// 获取商家 售后订单列表
let SP_GET_SHOPAFTERSALES_URL = "\(SPNetWorkManager.instance().sp_getDomainName(key: SP_MAIN_DOMAIN_NAME_KEY))/shop/topapi?method=aftersales.list"
/// 获取商家 售后订单详情
let SP_GET_SHOP_AFTERSALESDET_URL = "\(SPNetWorkManager.instance().sp_getDomainName(key: SP_MAIN_DOMAIN_NAME_KEY))/shop/topapi?method=aftersales.get"
/// 商家发货
let SP_GET_SHOP_DELIVERY_URL = "\(SPNetWorkManager.instance().sp_getDomainName(key: SP_MAIN_DOMAIN_NAME_KEY))/shop/topapi?method=trade.delivery.shop"
/// 商家取消订单
let SP_GET_SHOP_CACNEORDER_URL = "\(SPNetWorkManager.instance().sp_getDomainName(key: SP_MAIN_DOMAIN_NAME_KEY))/shop/topapi?method=trade.close.shop"
/// 商家售后处理
let SP_GET_SHOP_AFTERSALES_URL =  "\(SPNetWorkManager.instance().sp_getDomainName(key: SP_MAIN_DOMAIN_NAME_KEY))/shop/topapi?method=trade.cancel.shop.check"
/// 商家取消订单原因
let SP_GET_SHOP_CANCEREASON_URL =  "\(SPNetWorkManager.instance().sp_getDomainName(key: SP_MAIN_DOMAIN_NAME_KEY))/shop/topapi?method=trade.cancel.shop.reason"
/// 获取商品详情
let SP_GET_SHOP_PRODUCTDET_URL = "\(SPNetWorkManager.instance().sp_getDomainName(key: SP_MAIN_DOMAIN_NAME_KEY))/shop/topapi?method=item.detail"
/// 取消订单列表
let SP_GER_CANCELIST_URL = "\(SPNetWorkManager.instance().sp_getDomainName(key: SP_MAIN_DOMAIN_NAME_KEY))/shop/topapi?method=aftersales.cencel.list"
/// 取消订单详情
let SP_GET_CANCEDET_URL = "\(SPNetWorkManager.instance().sp_getDomainName(key: SP_MAIN_DOMAIN_NAME_KEY))/shop/topapi?method=aftersales.cencel.get"
/// 处理是否同意 待发货状态下申请退款
let SP_GET_CANCECHECK_URL = "\(SPNetWorkManager.instance().sp_getDomainName(key: SP_MAIN_DOMAIN_NAME_KEY))/shop/topapi?method=trade.cencel.shop.check"
/// 更新店铺信息
let SP_GET_UPDATESHOP_URL = "\(SPNetWorkManager.instance().sp_getDomainName(key: SP_MAIN_DOMAIN_NAME_KEY))/shop/topapi?method=user.update.shop"
/*-----------------------web-------------------------*/
/// 获取商家销售中的商品数据
let SP_GET_ONSALE_URL = "\(SPNetWorkManager.instance().sp_getDomainName(key: SP_MAIN_DOMAIN_NAME_KEY))/index.php/wap/onsale.html"
/// 会员资料url
let SP_GET_USER_URL = "\(SPNetWorkManager.instance().sp_getDomainName(key: SP_MAIN_DOMAIN_NAME_KEY))/index.php/wap/app-storeinfo.html"
let SP_GET_INSTOCK_URL = "\(SPNetWorkManager.instance().sp_getDomainName(key: SP_MAIN_DOMAIN_NAME_KEY))/index.php/wap/instock.html"
/// 竞拍webvUrl
let SP_GET_AUCTION_WEB_URL = "\(SPNetWorkManager.instance().sp_getDomainName(key: SP_MAIN_DOMAIN_NAME_KEY))/index.php/wap/auctionList.html"
/// 商品审核
let SP_GET_PEND_WEB_UEL = "\(SPNetWorkManager.instance().sp_getDomainName(key: SP_MAIN_DOMAIN_NAME_KEY))/index.php/wap/app-pending.html"
/// 商家会员资料
let SP_GER_SELLERINFO_WEB_URL = "\(SPNetWorkManager.instance().sp_getDomainName(key: SP_MAIN_DOMAIN_NAME_KEY))/index.php/wap/app-shopinfo.html"
/// 资金管理
let SP_GET_CAPITAL_WEB_URL = "\(SPNetWorkManager.instance().sp_getDomainName(key: SP_MAIN_DOMAIN_NAME_KEY))/index.php/wap/app-capital.html"
/// 银行卡管理
let SP_GET_BANK_WEB_URL = "\(SPNetWorkManager.instance().sp_getDomainName(key: SP_MAIN_DOMAIN_NAME_KEY))/index.php/wap/app-bank.html"
/// 跳到设置页面
let SP_GET_SETTING_WEB_URL = "\(SPNetWorkManager.instance().sp_getDomainName(key: SP_MAIN_DOMAIN_NAME_KEY))/index.php/wap/app-setting.html"
/// 我的收藏
let SP_GET_COLLECT_WEB_URL = "\(SPNetWorkManager.instance().sp_getDomainName(key: SP_MAIN_DOMAIN_NAME_KEY))/index.php/wap/app-collect.html"
/// 用户协议
let SP_GET_USER_WEB_URL = "\(SPNetWorkManager.instance().sp_getDomainName(key: SP_MAIN_DOMAIN_NAME_KEY))/index.php/wap/app-license.html"
/// 消息
let SP_GET_MSG_WEB_URL = "\(SPNetWorkManager.instance().sp_getDomainName(key: SP_MAIN_DOMAIN_NAME_KEY))/index.php/wap/app-information.html"
/// 商品管理
let SP_GET_ITECEMTER_URL = "\(SPNetWorkManager.instance().sp_getDomainName(key: SP_MAIN_DOMAIN_NAME_KEY))/index.php/wap/app-itemCenter.html"
/// 商品管理
let SP_GET_EVALUATE_WEB_URL = "\(SPNetWorkManager.instance().sp_getDomainName(key: SP_MAIN_DOMAIN_NAME_KEY))/index.php/wap/app-evaluate.html"
