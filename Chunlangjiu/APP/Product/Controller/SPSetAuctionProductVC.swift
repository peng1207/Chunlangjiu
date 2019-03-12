//
//  SPSetAuctionProductVC.swift
//  Chunlangjiu
//
//  Created by 黄树鹏 on 2019/3/3.
//  Copyright © 2019 Chunlang. All rights reserved.
//

import Foundation
import SnapKit
typealias SPSetAuctionSuccessBlock = (_ model : SPProductModel?)->Void

class SPSetAuctionProductVC: SPBaseVC {

    fileprivate lazy var scrollView : UIScrollView = {
        let view = UIScrollView()
        return view
    }()
    fileprivate lazy var productContentView : UIView = {
        let view = UIView()
        view.backgroundColor = SPColorForHexString(hex: SP_HexColor.color_ffffff.rawValue)
        view.sp_cornerRadius(cornerRadius: 5)
        return view
    }()
    fileprivate lazy var productImgView : UIImageView = {
        let view = UIImageView()
        return view
    }()
    fileprivate lazy var nameLabel : UILabel = {
        let label = UILabel()
        label.font = sp_getFontSize(size: 14)
        label.textColor = SPColorForHexString(hex: SP_HexColor.color_333333.rawValue)
        label.textAlignment = .left
        label.numberOfLines = 2
        return label
    }()
    fileprivate lazy var labelView : SPLabelView = {
        let view = SPLabelView()
        return view
    }()
    fileprivate lazy var priceLabel : UILabel = {
        let label = UILabel()
        label.font = sp_getFontSize(size: 14)
        label.textColor = SPColorForHexString(hex: SP_HexColor.color_333333.rawValue)
        label.textAlignment = .left
        return label
    }()
    fileprivate lazy var stockLabel : UILabel = {
        let label = UILabel()
        label.font = sp_getFontSize(size: 10)
        label.textColor = SPColorForHexString(hex: SP_HexColor.color_333333.rawValue)
        label.textAlignment = .left
        return label
    }()
    
    fileprivate lazy var typeView : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        view.sp_cornerRadius(cornerRadius: 5)
        return view
    }()
    fileprivate lazy var typeTitleLabel : UILabel = {
        let label = UILabel()
        label.font = sp_getFontSize(size: 15)
        label.textColor = SPColorForHexString(hex: SP_HexColor.color_333333.rawValue)
        label.textAlignment = .left
        label.text = "竞拍类型"
        return label
    }()
    fileprivate lazy var brightBtn : UIButton = {
        let btn = UIButton(type: UIButtonType.custom)
        btn.setImage(UIImage(named: "public_unselect"), for: UIControlState.normal)
        btn.setImage(UIImage(named: "public_select_red_solid"), for: UIControlState.selected)
        btn.setTitle(" 明拍", for: UIControlState.normal)
        btn.setTitleColor(SPColorForHexString(hex: SP_HexColor.color_333333.rawValue), for: UIControlState.normal)
        btn.isSelected = true
        btn.titleLabel?.font = sp_getFontSize(size: 15)
        btn.addTarget(self, action: #selector(sp_clickBright), for: UIControlEvents.touchUpInside)
        return btn
    }()
    fileprivate lazy var darkBtn : UIButton = {
        let btn = UIButton(type: UIButtonType.custom)
        btn.setImage(UIImage(named: "public_unselect"), for: UIControlState.normal)
        btn.setImage(UIImage(named: "public_select_red_solid"), for: UIControlState.selected)
        btn.setTitle(" 暗拍", for: UIControlState.normal)
        btn.setTitleColor(SPColorForHexString(hex: SP_HexColor.color_333333.rawValue), for: UIControlState.normal)
       
        btn.titleLabel?.font = sp_getFontSize(size: 15)
        btn.addTarget(self, action: #selector(sp_clickDark), for: UIControlEvents.touchUpInside)
        return btn
    }()
    fileprivate lazy var contentView : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        view.sp_cornerRadius(cornerRadius: 5)
        return view
    }()
    
    fileprivate lazy var startTimeView : SPAddressSelectView = {
        let view = SPAddressSelectView()
        view.titleLabel.text = "开始时间"
        view.placeholder = "选择竞拍开始时间"
        view.selectBlock = { [weak self] in
            self?.sp_clickStartTime()
        }
        return view
    }()
    fileprivate lazy var endTimeView : SPAddressSelectView = {
        let view = SPAddressSelectView()
        view.titleLabel.text = "结束时间"
        view.placeholder = "选择竞拍结束时间"
        view.selectBlock = { [weak self] in
            self?.sp_clickEndTime()
        }
        return view
    }()
    fileprivate lazy var startPriceView : SPAddressEditView = {
        let view = SPAddressEditView()
        view.titleLabel.text = "起拍价"
        view.textFiled.placeholder = "请输入起拍价"
        view.textFiled.keyboardType = UIKeyboardType.decimalPad
        return view
    }()
    fileprivate lazy var numView : SPAddressEditView = {
        let view = SPAddressEditView()
        view.titleLabel.text = "竞拍数量"
        view.textFiled.placeholder = "数量需要小于现库存数"
        view.textFiled.keyboardType = UIKeyboardType.numberPad
        return view
    }()
    fileprivate lazy var submitBtn : UIButton = {
        let btn = UIButton(type: UIButtonType.custom)
        btn.setTitle("发布", for: UIControlState.normal)
        btn.setTitleColor(SPColorForHexString(hex: SP_HexColor.color_ffffff.rawValue), for: UIControlState.normal)
        btn.backgroundColor = SPColorForHexString(hex: SP_HexColor.color_b31f3f.rawValue)
        btn.sp_cornerRadius(cornerRadius: 5)
        btn.titleLabel?.font = sp_getFontSize(size: 15)
        btn.addTarget(self, action: #selector(sp_clickSubmit), for: UIControlEvents.touchUpInside)
        return btn
    }()
    fileprivate var startDate : Date?
    fileprivate var endDate : Date?
    var model : SPProductModel?
    var successBlock : SPSetAuctionSuccessBlock?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.sp_setupUI()
        sp_setupData()
        sp_addNotification()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    /// 创建UI
    override func sp_setupUI() {
        self.navigationItem.title = "设置竞拍商品"
        self.view.addSubview(self.scrollView)
        self.scrollView.addSubview(self.productContentView)
        self.productContentView.addSubview(self.productImgView)
        self.productContentView.addSubview(self.nameLabel)
        self.productContentView.addSubview(self.labelView)
        self.productContentView.addSubview(self.priceLabel)
        self.productContentView.addSubview(self.stockLabel)
        self.scrollView.addSubview(self.typeView)
        self.typeView.addSubview(self.typeTitleLabel)
        self.typeView.addSubview(self.brightBtn)
        self.typeView.addSubview(self.darkBtn)
        self.scrollView.addSubview(self.contentView)
        self.contentView.addSubview(self.startTimeView)
        self.contentView.addSubview(self.endTimeView)
        self.contentView.addSubview(self.startPriceView)
        self.contentView.addSubview(self.numView)
        self.scrollView.addSubview(self.submitBtn)
        self.sp_addConstraint()
    }
    /// 处理有没数据
    override func sp_dealNoData(){
        
    }
    /// 添加约束
    fileprivate func sp_addConstraint(){
        self.scrollView.snp.makeConstraints { (maker) in
            maker.left.right.top.equalTo(self.view).offset(0)
            if #available(iOS 11.0, *) {
                maker.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(0)
            } else {
                maker.bottom.equalTo(self.view.snp.bottom).offset(0)
            }
        }
        self.productContentView.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.scrollView).offset(10)
            maker.top.equalTo(self.scrollView).offset(10)
            maker.right.equalTo(self.scrollView.snp.right).offset(-10)
            maker.height.equalTo(125)
            maker.centerX.equalTo(self.scrollView.snp.centerX).offset(0)
        }
        self.productImgView.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.productContentView).offset(12)
            maker.top.equalTo(self.productContentView).offset(13)
            maker.width.height.equalTo(100)
        }
        self.nameLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.productImgView.snp.right).offset(11)
            maker.right.equalTo(self.productContentView.snp.right).offset(-12)
            maker.top.equalTo(self.productImgView.snp.top).offset(0)
            maker.height.greaterThanOrEqualTo(0)
        }
        self.labelView.snp.makeConstraints { (maker) in
            maker.left.right.equalTo(self.nameLabel).offset(0)
            maker.top.equalTo(self.nameLabel.snp.bottom).offset(10)
            maker.height.equalTo(15)
        }
        self.priceLabel.snp.makeConstraints { (maker) in
            maker.left.right.equalTo(self.nameLabel).offset(0)
            maker.height.greaterThanOrEqualTo(0)
            maker.bottom.equalTo(self.stockLabel.snp.top).offset(-10)
        }
        self.stockLabel.snp.makeConstraints { (maker) in
            maker.left.right.equalTo(self.nameLabel).offset(0)
            maker.bottom.equalTo(self.productImgView.snp.bottom).offset(0)
            maker.height.greaterThanOrEqualTo(0)
        }
        self.typeView.snp.makeConstraints { (maker) in
            maker.left.right.equalTo(self.productContentView).offset(0)
            maker.top.equalTo(self.productContentView.snp.bottom).offset(10)
            maker.height.equalTo(50)
        }
        self.typeTitleLabel.setContentHuggingPriority(UILayoutPriority.defaultHigh, for: UILayoutConstraintAxis.horizontal)
        self.typeTitleLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.typeView).offset(9)
            maker.top.bottom.equalTo(self.typeView).offset(0)
            maker.width.greaterThanOrEqualTo(0)
        }
        self.brightBtn.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.typeTitleLabel.snp.right).offset(30)
            maker.top.bottom.equalTo(self.typeView).offset(0)
            maker.width.equalTo(60)
        }
        self.darkBtn.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.brightBtn.snp.right).offset(20)
            maker.top.bottom.equalTo(self.typeView).offset(0)
            maker.width.equalTo(self.brightBtn).offset(0)
        }
        self.contentView.snp.makeConstraints { (maker) in
            maker.left.right.equalTo(self.typeView).offset(0)
            maker.top.equalTo(self.typeView.snp.bottom).offset(10)
            maker.height.greaterThanOrEqualTo(0)
        }
        self.startTimeView.snp.makeConstraints { (maker) in
            maker.left.right.top.equalTo(self.contentView).offset(0)
            maker.height.equalTo(50)
        }
        self.endTimeView.snp.makeConstraints { (maker) in
            maker.left.right.height.equalTo(self.startTimeView).offset(0)
            maker.top.equalTo(self.startTimeView.snp.bottom).offset(0)
        }
        self.startPriceView.snp.makeConstraints { (maker) in
            maker.left.right.height.equalTo(self.endTimeView).offset(0)
            maker.top.equalTo(self.endTimeView.snp.bottom).offset(0)
        }
        self.numView.snp.makeConstraints { (maker) in
            maker.left.right.height.equalTo(self.startPriceView).offset(0)
            maker.top.equalTo(self.startPriceView.snp.bottom).offset(0)
            maker.bottom.equalTo(self.contentView.snp.bottom).offset(0)
        }
        self.submitBtn.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.scrollView).offset(21)
            maker.right.equalTo(self.scrollView).offset(-21)
            maker.height.equalTo(44)
            maker.top.equalTo(self.contentView.snp.bottom).offset(45)
            maker.bottom.equalTo(self.scrollView.snp.bottom).offset(-45)
        }
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
extension SPSetAuctionProductVC {
    
    fileprivate func sp_setupData(){
         self.productImgView.sp_cache(string: sp_getString(string: self.model?.image_default_id), plImage: sp_getDefaultImg())
        self.nameLabel.text = sp_getString(string: self.model?.title)
        self.priceLabel.text = "参考价格：\(SP_CHINE_MONEY)\(sp_getString(string: self.model?.price))"
        self.stockLabel.text = "在线库存：\(sp_getString(string: self.model?.store))"
    }
    
    @objc fileprivate func sp_clickBright(){
        self.brightBtn.isSelected = true
        self.darkBtn.isSelected = false
    }
    @objc fileprivate func sp_clickDark(){
        self.brightBtn.isSelected = false
        self.darkBtn.isSelected = true
    }
    fileprivate func sp_clickStartTime(){
        SPDatePicker.sp_show(datePickerMode: UIDatePicker.Mode.dateAndTime, minDate: Date(), maxDate: nil, currentDate: self.startDate != nil ? self.startDate! : Date()) { [weak self](date) in
            self?.startDate = date
            self?.sp_dealTime()
        }
     
    }
    fileprivate func sp_clickEndTime(){
        SPDatePicker.sp_show(datePickerMode: UIDatePicker.Mode.dateAndTime, minDate: self.startDate != nil ? self.startDate :  Date(), maxDate: nil, currentDate: self.endDate != nil ? self.endDate! :  Date()) { [weak self](date)  in
            self?.endDate = date
            self?.sp_dealTime()
        }
       
    }
    fileprivate func sp_dealTime(){
        self.startTimeView.content = sp_getString(string: SPDateManager.sp_string(to: self.startDate))
        self.endTimeView.content = sp_getString(string: SPDateManager.sp_string(to: self.endDate))
        
    }
    @objc fileprivate func sp_clickSubmit(){
        if sp_getString(string: self.startPriceView.textFiled.text).count == 0 {
            sp_showTextAlert(tips: "请输入起拍价")
            return
        }
        if self.startDate == nil {
            sp_showTextAlert(tips: "请选择竞拍开始时间")
            return
        }
        if self.endDate == nil {
            sp_showTextAlert(tips: "请选择竞拍结束时间")
            return
        }
        if sp_getString(string: self.numView.textFiled.text).count == 0 {
            sp_showTextAlert(tips: "请输入竞拍数量")
            return
        }
        sp_sendSubmitRequest()
    }
    fileprivate func sp_dealComplete(){
        guard let block = self.successBlock else {
            return
        }
        block(self.model)
    }
}
extension SPSetAuctionProductVC {
    
    fileprivate func sp_addNotification(){
        NotificationCenter.default.addObserver(self, selector: #selector(sp_keyboardShow(obj:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(sp_keyboardHidden), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
   @objc fileprivate func sp_keyboardShow(obj : Notification){
        let height = sp_getKeyBoardheight(notification: obj)
        sp_updateTableLayout(height: height)
    }
   @objc fileprivate func sp_keyboardHidden(){
        sp_updateTableLayout(height: 0)
    }
    private func sp_updateTableLayout(height:CGFloat){
        self.scrollView.snp.remakeConstraints { (maker) in
            maker.left.top.right.equalTo(self.view).offset(0)
            if height > 0 {
                maker.bottom.equalTo(self.view.snp.bottom).offset(-height)
            }else{
                if #available(iOS 11.0, *) {
                    maker.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(0)
                } else {
                    maker.bottom.equalTo(self.view.snp.bottom).offset(0)
                }
            }
        }
    }
}
extension SPSetAuctionProductVC {
    fileprivate func sp_sendSubmitRequest(){
        var parm = [String : Any]()
        if let item_id = self.model?.item_id {
            parm.updateValue(item_id, forKey: "item_id")
        }
        parm.updateValue(sp_getString(string: self.startPriceView.textFiled.text), forKey: "starting_price")
        if self.brightBtn.isSelected {
            parm.updateValue("true", forKey: "status")
        }else{
            parm.updateValue("false", forKey: "status")
        }
        parm.updateValue(sp_getString(string: self.numView.textFiled.text), forKey: "store")
        let start = Int(SPDateManager.sp_timeInterval(to: self.startDate))
         parm.updateValue(start, forKey: "begin_time")
        let end = Int(SPDateManager.sp_timeInterval(to: self.endDate))
        parm.updateValue(end, forKey: "end_time")
        self.requestModel.parm = parm
        sp_showAnimation(view: self.view, title: nil)
        SPProductRequest.sp_getShopSetAuction(requestModel: self.requestModel) { [weak self](code, msg, errorModel) in
            sp_hideAnimation(view: self?.view)
            sp_showTextAlert(tips: sp_getString(string: msg).count > 0 ? msg : code == SP_Request_Code_Success ? "设置竞拍商品成功" : "设置竞拍商品失败")
            if code == SP_Request_Code_Success {
                self?.sp_dealComplete()
                self?.navigationController?.popViewController(animated: true)
            }
        }
        
    }
    
}
