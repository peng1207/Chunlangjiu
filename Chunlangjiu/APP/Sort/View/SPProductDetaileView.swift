//
//  SPProductDetileView.swift
//  Chunlangjiu
//
//  Created by 黄树鹏 on 2018/7/10.
//  Copyright © 2018年 Chunlang. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

typealias SPDetaileScrollViewDidScrollBlock = (_ scrollView : UIScrollView) -> Void

class SPProductDetaileView:  UIView {
    
    fileprivate let SP_KVO_KEY_FRAME = "center"
    lazy var scrollView : UIScrollView = {
        let view = UIScrollView()
        view.bounces = false
        view.isScrollEnabled = false
        return view
    }()
    lazy var productScrollView : UIScrollView = {
        let view = UIScrollView()
       view.delegate = self
 
        view.addObserver(self, forKeyPath: SP_KVO_KEY_CONTENTSIZE, options: NSKeyValueObservingOptions.new, context: nil)
        view.addObserver(self, forKeyPath: SP_KVO_KEY_FRAME, options: NSKeyValueObservingOptions.new, context: nil)
        return view
    }()
    lazy var productView : SPProductView = {
        let view = SPProductView()
        view.backgroundColor = UIColor.white
       
        return view
    }()
    lazy var bannerView : SPBannerView =  {
        let view  = SPBannerView()
        view.pageControl.currentColor = SPColorForHexString(hex: SP_HexColor.color_b31f3f.rawValue)
        view.pageControl.otherColor = SPColorForHexString(hex: SP_HexColor.color_ffffff.rawValue).withAlphaComponent(0.7)
        view.numBlock = { [weak self](second : Int) -> Int in
            return sp_getArrayCount(array: self?.detaileModel?.item?.images)
        }
        view.cellBlock = { [weak self](imageView : UIImageView,row :Int) in
            self?.sp_dealCellData(imageView: imageView, row: row)
        }
        view.backgroundColor = UIColor.white
        return view
    }()
    lazy var ruleView : SPProductRuleView = {
        let view = SPProductRuleView()
        view.backgroundColor = UIColor.white
        view.isHidden = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(sp_showRule))
        view.addGestureRecognizer(tap)
        return view
    }()
    lazy var tipsView : SPProductTipsView = {
        let view  = SPProductTipsView()
        view.backgroundColor = UIColor.white
        view.isHidden = true
        return view
    }()
    lazy var shopView : SPProductOfShopView = {
        let view = SPProductOfShopView()
        view.isHidden = true
        view.backgroundColor = UIColor.white
        return view
    }()
    lazy var detView : SPDetView = {
        let view = SPDetView()
        view.isHidden = true
        view.backgroundColor = SPColorForHexString(hex: SP_HexColor.color_ffffff.rawValue)
        return view
    }()
    lazy var evaluateView : SPProductEvaluateView = {
        let view = SPProductEvaluateView()
        view.isHidden = true
        view.backgroundColor = UIColor.white
        return view
    }()
    lazy var recommendView : SPRecommendProductView = {
        let view = SPRecommendProductView()
        view.backgroundColor =  SPColorForHexString(hex: SP_HexColor.color_f7f7f7.rawValue)
        view.isHidden = true
        return view
    }()
    lazy var pullUpRefreshView : UIView = {
        let view = UIView()
        view.isHidden = true
        return view
    }()
    
    var didScrollBlock : SPDetaileScrollViewDidScrollBlock?
    var didDetaileBlock : ((_ isDetaile : Bool)->Void)?
    var timeOutBlock : SPBtnClickBlock?
    var detaileModel : SPProductDetailModel?{
        didSet{
            self.sp_setupData()
        }
    }
    fileprivate var tipsTop : Constraint!
    fileprivate var evaluateTop : Constraint!
    fileprivate var recommendTop : Constraint!
    fileprivate var ruleTop : Constraint!
    fileprivate var isLoading :  Bool = false
    fileprivate var isDragging : Bool  = false
    fileprivate var hasMore : Bool = true
    fileprivate let refresher_heright : CGFloat = 50
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.sp_setupUI()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    /// 添加UI
    fileprivate func sp_setupUI(){
        self.addSubview(self.scrollView)
        self.scrollView.addSubview(self.productScrollView)
//        self.scrollView.addSubview(self.webVC.view)
        self.productScrollView.addSubview(self.bannerView)
        self.productScrollView.addSubview(self.productView)
        self.productScrollView.addSubview(self.ruleView)
        self.productScrollView.addSubview(self.tipsView)
        self.productScrollView.addSubview(self.shopView)
        self.productScrollView.addSubview(self.detView)
        self.productScrollView.addSubview(self.evaluateView)
        self.productScrollView.addSubview(self.recommendView)
        self.productScrollView.addSubview(self.pullUpRefreshView)
        
        self.sp_addConstraint()
    }
    /// 添加约束
    fileprivate func sp_addConstraint(){
        self.scrollView.snp.makeConstraints { (maker) in
            maker.left.top.right.bottom.equalTo(self).offset(0)
        }
        self.productScrollView.snp.makeConstraints { (maker) in
            maker.left.top.equalTo(self.scrollView).offset(0)
            maker.width.equalTo(self.scrollView.snp.width).offset(0)
            maker.height.equalTo(self.scrollView.snp.height).offset(0)
            maker.centerX.equalTo(self.scrollView.snp.centerX).offset(0)
        }
        self.bannerView.snp.makeConstraints { (maker) in
            maker.left.right.top.equalTo(self.productScrollView).offset(0)
            maker.height.equalTo(self.bannerView.snp.width).multipliedBy(SP_PRODUCT_SCALE)
            maker.centerX.equalTo(self.productScrollView.snp.centerX).offset(0)
        }
        self.productView.snp.makeConstraints { (maker) in
            maker.left.right.equalTo(self.productScrollView).offset(0)
            maker.top.equalTo(self.bannerView.snp.bottom).offset(0)
            maker.height.greaterThanOrEqualTo(0)
        }
        self.ruleView.snp.makeConstraints { (maker) in
            maker.left.right.equalTo(self.productScrollView).offset(0)
            self.ruleTop = maker.top.equalTo(self.productView.snp.bottom).offset(0).constraint
            maker.height.greaterThanOrEqualTo(0)
        }
        self.tipsView.snp.makeConstraints { (maker) in
            maker.left.right.equalTo(self.productScrollView).offset(0)
            maker.height.greaterThanOrEqualTo(0)
           self.tipsTop = maker.top.equalTo(self.ruleView.snp.bottom).offset(0).constraint
        }
        self.evaluateView.snp.makeConstraints { (maker) in
            maker.left.right.equalTo(self.productScrollView).offset(0)
            maker.height.greaterThanOrEqualTo(0)
            self.evaluateTop = maker.top.equalTo(self.tipsView.snp.bottom).offset(10).constraint
        }
        
        self.shopView.snp.makeConstraints { (maker) in
            maker.left.right.equalTo(self.productScrollView).offset(0)
            maker.top.equalTo(self.evaluateView.snp.bottom).offset(10)
            maker.height.greaterThanOrEqualTo(0)
        }
        self.detView.snp.makeConstraints { (maker) in
            maker.left.right.equalTo(self.productScrollView).offset(0)
            maker.top.equalTo(self.shopView.snp.bottom).offset(10)
            maker.height.greaterThanOrEqualTo(0)
        }
        self.recommendView.snp.makeConstraints { (maker) in
            maker.left.right.equalTo(self.productScrollView).offset(0)
            self.recommendTop = maker.top.equalTo(self.detView.snp.bottom).offset(10).constraint
            maker.height.greaterThanOrEqualTo(0)
        }
        self.pullUpRefreshView.snp.makeConstraints { (maker) in
            maker.left.right.equalTo(self.productScrollView).offset(0)
            maker.top.equalTo(self.recommendView.snp.bottom).offset(0)
            maker.height.equalTo(0)
            maker.bottom.equalTo(self.productScrollView.snp.bottom).offset(-10)
        }
        
    }
    deinit {
        self.productScrollView.removeObserver(self, forKeyPath: SP_KVO_KEY_CONTENTSIZE, context: nil)
        self.productScrollView.removeObserver(self, forKeyPath: SP_KVO_KEY_FRAME)
        self.productScrollView.delegate = nil
        self.scrollView.delegate = nil
       
        sp_removeTime()
    }
}
extension SPProductDetaileView : UIScrollViewDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        if self.isLoading {
            return
        }
        self.isDragging = true
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        
    }
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !self.hasMore || self.isLoading {
            return
        }
        self.isDragging = false
        if scrollView.contentOffset.y > 0 && self.sp_contentOffsetBottom(scrollView: scrollView) <= -refresher_heright {
            self.sp_startLoging()
        }
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if !self.hasMore || self.isLoading {
            return
        }
        if scrollView.contentOffset.y > 0 && self.sp_contentOffsetBottom(scrollView: scrollView) <= -refresher_heright{
            self.sp_startLoging()
        }
    }
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == SP_KVO_KEY_CONTENTSIZE {
            sp_log(message: object)
            if self.productScrollView.contentSize.height < self.productScrollView.frame.size.height {
                self.productScrollView.contentSize = CGSize(width: 0, height: self.productScrollView.frame.size.height + 10)
            }
            
        }
        if keyPath == SP_KVO_KEY_FRAME{
            sp_log(message: " frame 改变\(object)")
           
        }
    }
    func sp_startLoging(){
        
    }
    func sp_stopLoging(){
        
    }
    
    @objc func animationDidStop(anim: CAAnimation!, finished flag: Bool){
       
    }
    func  sp_contentOffsetBottom(scrollView : UIScrollView) -> CGFloat {
        return scrollView.contentSize.height - (scrollView.contentOffset.y + scrollView.bounds.size.height - scrollView.contentInset.bottom)
    }
    func sp_pullDownFinish(){
        
    }
    /// 赋值
    fileprivate func sp_setupData(){
        self.bannerView.isAutoPaly = true
        self.bannerView.sp_reloadData()
        self.productView.productModel = self.detaileModel?.item
        self.shopView.shopModel = self.detaileModel?.shop
        self.tipsView.content = sp_getString(string: self.detaileModel?.item?.explain)
        self.detView.productModel = self.detaileModel?.item
        self.detView.isHidden = false
        self.shopView.isHidden = false
        self.pullUpRefreshView.isHidden = false
        self.ruleView.content = sp_getString(string: self.detaileModel?.item?.rule)
        if sp_getString(string: self.detaileModel?.item?.explain).count > 0 {
             self.tipsTop.update(offset: 0)
            self.tipsView.isHidden = false
        }else{
             self.tipsTop.update(offset: 0)
            self.tipsView.isHidden = true
        }
        if sp_getString(string: self.detaileModel?.item?.rule).count > 0 {
            self.ruleTop.update(offset: 0)
            self.ruleView.isHidden = false
        }else{
            self.ruleView.isHidden = true
            self.ruleTop.update(offset: 0)
        }
        sp_removeTime()
        if let isAuction = self.detaileModel?.item?.isAuction, isAuction == true{
            sp_addTime()
        }
      
//        self.webVC.url = URL(string: sp_getString(string: self.detaileModel?.item?.desc))
//        self.webVC.sp_reloadUrl()
    }
    /// 处理图片轮播的数据
    ///
    /// - Parameters:
    ///   - imageView: 显示图片
    ///   - row: 第几个
    fileprivate func sp_dealCellData(imageView : UIImageView ,row : Int) {
        if row >= 0 ,row < sp_getArrayCount(array: self.detaileModel?.item?.images) {
            let url = self.detaileModel?.item?.images![row]
            imageView.sp_cache(string: url, plImage: sp_getDefaultImg())
        }
    }
    func sp_setEvaluate(list:[Any]?,totalPage:Int){
        var dataList  = [Any]()
        if sp_getArrayCount(array: list) > 2 {
            dataList.append(list![0])
            dataList.append(list![1])
        }else{
            if sp_getArrayCount(array: list) > 0 {
                dataList = list!
            }
        }
        if sp_getArrayCount(array: dataList) > 0 ,let eList :[SPEvaluateModel] = dataList as? [SPEvaluateModel] {
            self.evaluateView.isHidden = false
            self.evaluateView.dataArray = eList
            self.evaluateTop.update(offset: 12)
        }else{
            self.evaluateView.dataArray = nil
            self.evaluateTop.update(offset: 12)
            self.evaluateView.isHidden = false
        }
        self.evaluateView.total = totalPage
    }
    func sp_setRecomd(list:[Any]?){
        
        if sp_getArrayCount(array: list) > 0 {
            self.recommendTop.update(offset: 12)
            self.recommendView.dataArray = list as? Array<SPProductModel>
            self.recommendView.isHidden = false
        }else{
            self.recommendView.dataArray = nil
            self.recommendTop.update(offset: 12)
            self.recommendView.isHidden = false
        }
    }
    fileprivate func sp_deal(isDetaile : Bool){
        guard let block = self.didDetaileBlock else {
            return
        }
        block(isDetaile)
        
    }
    @objc fileprivate func sp_showRule(){
        SPShowRule.sp_show(content: sp_getString(string: self.detaileModel?.item?.rule))
        
    }
}
// MARK: - notification
extension SPProductDetaileView{
    fileprivate func sp_addTime(){
        NotificationCenter.default.addObserver(self, selector: #selector(sp_time(notification:)), name: NSNotification.Name(SP_TIMERUN_NOTIFICATION), object: nil)
    }
    fileprivate func sp_removeTime(){
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(SP_TIMERUN_NOTIFICATION), object: nil)
        NotificationCenter.default.removeObserver(self)
        sp_log(message: "销毁通知")
    }
    @objc fileprivate func sp_time(notification:Notification){
        var second = 1
        if notification.object is [String : Any] {
            let dic : [String : Any] = notification.object as! [String : Any]
            second = dic["timer"] as! Int
        }
//        sp_log(message: "获取到时间")
        if let model = self.detaileModel?.item {
            model.sp_set(second: second)
            sp_mainQueue {
                self.productView.productModel = model
            }
            if model.second <= 0 {
                if let itemID = model.item_id {
                    NotificationCenter.default.post(name: NSNotification.Name(SP_AUCTIONEND_NOTIFICATION), object:["item_id":itemID])
                }
            }
            if let block = self.timeOutBlock,model.second <= 0{
                block()
            }
            
        }
        
    }
}
