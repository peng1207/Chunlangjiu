//
//  SPAddBankCardVC.swift
//  Chunlangjiu
//
//  Created by 黄树鹏 on 2018/12/11.
//  Copyright © 2018 Chunlang. All rights reserved.
//

import Foundation
import SnapKit
class SPAddBankCardVC: SPBaseVC {
    fileprivate lazy var scrollView : UIScrollView = {
        let view = UIScrollView()
        return view
    }()
    
    fileprivate lazy var nameView : SPAddressEditView = {
        let view = SPAddressEditView()
        view.titleLabel.text = "姓名"
        view.textFiled.placeholder = "请输入姓名"
        view.backgroundColor = SPColorForHexString(hex: SP_HexColor.color_ffffff.rawValue)
        return view
    }()
    fileprivate lazy var cardView : SPAddressEditView = {
        let view = SPAddressEditView()
        view.titleLabel.text = "身份证"
        view.textFiled.placeholder = "请输入身份证号码"
        view.backgroundColor = SPColorForHexString(hex: SP_HexColor.color_ffffff.rawValue)
        return view
    }()
    fileprivate lazy var bankCardView : SPAddressEditView = {
        let view = SPAddressEditView()
        view.titleLabel.text = "银行卡号"
        view.textFiled.placeholder = "请输入银行卡号"
        view.textFiled.keyboardType =  UIKeyboardType.numberPad
        view.backgroundColor = SPColorForHexString(hex: SP_HexColor.color_ffffff.rawValue)
        view.textChangeBlock = { [weak self](textFiled,text) in
            sp_log(message: "获取到text \(text)")
            self?.sp_bankCardTextChange(text: text, textFiled: textFiled)
        }
        return view
    }()
    fileprivate lazy var openView : SPAddressSelectView = {
        let view = SPAddressSelectView()
        view.titleLabel.text = "开户行"
        view.placeholder = "请选择开户行"
        view.selectBlock = { [weak self] in
            self?.sp_clickOpen()
        }
        view.backgroundColor = SPColorForHexString(hex: SP_HexColor.color_ffffff.rawValue)
        return view
    }()
    fileprivate lazy var areaView : SPAddressSelectView = {
        let view = SPAddressSelectView()
        view.titleLabel.text = "开户支行"
        view.placeholder = "         省          市"
        view.backgroundColor = SPColorForHexString(hex: SP_HexColor.color_ffffff.rawValue)
        view.selectBlock = { [weak self] in
            self?.sp_clickArea()
        }
        return view
    }()
    fileprivate lazy var subbranchView : SPAddressEditView = {
        let view = SPAddressEditView()
        view.textFiled.placeholder = "请输入支行"
        view.backgroundColor = SPColorForHexString(hex: SP_HexColor.color_ffffff.rawValue)
        return view
    }()
    fileprivate lazy var phoneView : SPAddressEditView = {
        let view = SPAddressEditView()
        view.titleLabel.text = "手机号"
        view.textFiled.placeholder = "请输入银行预留手机号"
        view.textFiled.keyboardType = UIKeyboardType.numberPad
        view.backgroundColor = SPColorForHexString(hex: SP_HexColor.color_ffffff.rawValue)
        return view
    }()
    fileprivate lazy var codeView : SPInputBtnView = {
        let view = SPInputBtnView()
        view.titleLabel.text = "验证码"
        view.textFiled.placeholder = "请输入验证码"
        view.backgroundColor = SPColorForHexString(hex: SP_HexColor.color_ffffff.rawValue)
        view.clickBlock = { [weak self] in
            self?.sp_clickCode()
        }
        return view
    }()
    
    fileprivate lazy var doneBtn : UIButton = {
        let btn = UIButton(type: UIButtonType.custom)
        btn.setTitle("确定绑定", for: UIControlState.normal)
        btn.setTitleColor(SPColorForHexString(hex: SP_HexColor.color_ffffff.rawValue), for: UIControlState.normal)
        btn.backgroundColor = SPColorForHexString(hex: SP_HexColor.color_b31f3f.rawValue)
        btn.sp_cornerRadius(cornerRadius: 5)
        btn.titleLabel?.font = sp_getFontSize(size: 15)
        btn.addTarget(self, action: #selector(sp_clickDone), for: UIControlEvents.touchUpInside)
        return btn
    }()
    fileprivate lazy var areaPickerView : SPBankCardPicker = {
        let view = SPBankCardPicker()
        view.isHidden = true
        view.selectBlock = { [weak self](pModel , cModel) in
            self?.sp_dealSelectArea(pModel: pModel, cModel: cModel)
        }
        return view
    }()
    fileprivate var selectPModel : SPAreaModel?
    fileprivate var selectCModel : SPAreaModel?
    fileprivate var bankCardInfoModel : SPBankCardInfoModel?
    
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
        self.codeView.sp_stopTime()
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    /// 创建UI
    override func sp_setupUI() {
        self.navigationItem.title = "添加银行卡"
        self.view.addSubview(self.scrollView)
        self.view.addSubview(self.doneBtn)
        self.scrollView.addSubview(self.nameView)
        self.scrollView.addSubview(self.cardView)
        self.scrollView.addSubview(self.bankCardView)
        self.scrollView.addSubview(self.openView)
        self.scrollView.addSubview(self.areaView)
        self.scrollView.addSubview(self.subbranchView)
        self.scrollView.addSubview(self.codeView)
        self.scrollView.addSubview(self.phoneView)
        self.view.addSubview(self.areaPickerView)
//        self.codeView.addSubview(self.codeBtn)
        self.sp_addConstraint()
    }
    /// 赋值
    fileprivate func sp_setupData(){
         SPAPPManager.sp_getAreaData(isCity: false, complete: { [weak self](data) in
            self?.areaPickerView.dataArray = data as? [SPAreaModel]
        })
        sp_hideKeyboard()
    }
    /// 处理有没数据
    override func sp_dealNoData(){
        
    }
    /// 添加约束
    fileprivate func sp_addConstraint(){
        self.scrollView.snp.makeConstraints { (maker) in
            maker.left.right.top.equalTo(self.view).offset(0)
            maker.bottom.equalTo(self.doneBtn.snp.top).offset(-10)
        }
        self.doneBtn.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.view).offset(10)
            maker.right.equalTo(self.view.snp.right).offset(-10)
            maker.height.equalTo(40)
            if #available(iOS 11.0, *) {
                maker.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(-10)
            } else {
                maker.bottom.equalTo(self.view.snp.bottom).offset(-10)
            }
        }
        self.nameView.snp.makeConstraints { (maker) in
            maker.left.right.equalTo(self.scrollView).offset(0)
            maker.centerX.equalTo(self.scrollView).offset(0)
            maker.top.equalTo(self.scrollView.snp.top).offset(10)
            maker.height.equalTo(50)
        }
        self.cardView.snp.makeConstraints { (maker) in
            maker.left.right.height.equalTo(self.nameView).offset(0)
            maker.top.equalTo(self.nameView.snp.bottom).offset(0)
        }
        self.bankCardView.snp.makeConstraints { (maker) in
            maker.left.right.height.equalTo(self.cardView).offset(0)
            maker.top.equalTo(self.cardView.snp.bottom).offset(10)
        }
        self.openView.snp.makeConstraints { (maker) in
            maker.left.right.height.equalTo(self.bankCardView).offset(0)
            maker.top.equalTo(self.bankCardView.snp.bottom).offset(0)
        }
        self.areaView.snp.makeConstraints { (maker) in
            maker.left.right.height.equalTo(self.openView).offset(0)
            maker.top.equalTo(self.openView.snp.bottom).offset(0)
        }
        self.subbranchView.snp.makeConstraints { (maker) in
            maker.left.right.height.equalTo(self.areaView).offset(0)
            maker.top.equalTo(self.areaView.snp.bottom).offset(0)
        }
        self.phoneView.snp.makeConstraints { (maker) in
            maker.left.right.height.equalTo(self.subbranchView).offset(0)
            maker.top.equalTo(self.subbranchView.snp.bottom).offset(10)
        }
        self.codeView.snp.makeConstraints { (maker) in
            maker.left.right.height.equalTo(self.phoneView).offset(0)
            maker.top.equalTo(self.phoneView.snp.bottom).offset(0)
            maker.bottom.equalTo(self.scrollView.snp.bottom).offset(0)
        }
        
        self.areaPickerView.snp.makeConstraints { (maker) in
            maker.left.right.top.equalTo(self.view).offset(0)
            if #available(iOS 11.0, *) {
                maker.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(0)
            } else {
                maker.bottom.equalTo(self.view.snp.bottom).offset(0)
            }
        }
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
extension SPAddBankCardVC {
    @objc fileprivate func sp_clickDone(){
        if sp_getString(string: self.nameView.textFiled.text).count == 0  {
            sp_showTextAlert(tips: "请输入您姓名")
            return
        }
        if sp_getString(string: self.cardView.textFiled.text).count == 0 {
            sp_showTextAlert(tips: "请输入身份证号码")
            return
        }
        if sp_getString(string: self.bankCardView.textFiled.text).count == 0 {
            sp_showTextAlert(tips: "请输入画银行卡号")
            return
        }
        if sp_getString(string: self.subbranchView.textFiled.text).count == 0  {
            sp_showTextAlert(tips: "请输入支行")
            return
        }
        if sp_getString(string: self.phoneView.textFiled.text).count == 0 {
            sp_showTextAlert(tips: "请输入手机号码")
            return
        }
        if sp_getString(string: self.codeView.textFiled.text).count == 0 {
            sp_showTextAlert(tips: "请输入验证码")
            return
        }
        sp_sendAddRequest()
    }
    @objc fileprivate func sp_clickArea(){
        sp_hideKeyboard()
        self.areaPickerView.isHidden = false
    }
    @objc fileprivate func sp_clickOpen(){
        
    }
    @objc fileprivate func sp_clickCode(){
        if sp_getString(string: self.phoneView.textFiled.text).count == 0 {
            sp_showTextAlert(tips: "请输入手机号码")
            return
        }
        let request = SPRequestModel()
        var parm = [String : Any]()
        parm.updateValue(sp_getString(string: self.phoneView.textFiled.text), forKey: "mobile")
        request.parm = parm
        sp_showAnimation(view: self.view, title: nil)
        SPAppRequest.sp_getSendSms(requestModel: request) {  [weak self](code , msg, errorModel) in
            sp_hideAnimation(view: self?.view)
            sp_showTextAlert(tips: msg)
            if code == SP_Request_Code_Success {
                self?.codeView.sp_startTime()
            }else{
                self?.codeView.codeBtn.isEnabled = true
            }
        }
    
    }
   
    /// 选择开户行省市的回调
    ///
    /// - Parameters:
    ///   - pModel: 省
    ///   - cModel: 市
    fileprivate func sp_dealSelectArea(pModel : SPAreaModel?,cModel : SPAreaModel?){
        self.selectPModel = pModel
        self.selectCModel = cModel
        sp_dealAreaData()
    }
    fileprivate func sp_dealAreaData(){
        self.areaView.content = "\(sp_getString(string: self.selectPModel?.value)) \(sp_getString(string: self.selectCModel?.value)) "
    }
    /// 输入银行卡变化
    ///
    /// - Parameters:
    ///   - text: 输入内容
    ///   - textFiled: 输入框
    fileprivate func sp_bankCardTextChange(text:String,textFiled:SPTextFiled){
        if sp_getString(string: text).count == 8 {
            // 调用获取对应银行卡信息
            sp_sendBankCardRequest()
        }else{
            if sp_getString(string: text).count == 0 {
                self.bankCardInfoModel = nil
                self.sp_dealBankCard()
            }
        }
    }
}
extension SPAddBankCardVC {
    fileprivate func sp_sendBankCardRequest(){
        var parm = [String : Any]()
        parm.updateValue(sp_getString(string: self.bankCardView.textFiled.text), forKey: "card")
        self.requestModel.parm = parm
        SPFundsRequest.sp_getBankCardInfo(requestModel: self.requestModel) { [weak self](code , model, msg, errorModel) in
            if code == SP_Request_Code_Success {
                self?.bankCardInfoModel = model
                self?.sp_dealBankCard()
            }else{
                sp_showTextAlert(tips: msg)
            }
        }
        
    }
    fileprivate func sp_dealBankCard(){
        self.openView.content = sp_getString(string: self.bankCardInfoModel?.bankname)
    }
    fileprivate func sp_sendAddRequest(){
        var parm = [String : Any]()
        parm.updateValue(sp_getString(string: self.nameView.textFiled.text), forKey: "name")
        parm.updateValue(sp_getString(string: self.bankCardInfoModel?.bankname), forKey: "bank")
        parm.updateValue(sp_getString(string: self.bankCardView.textFiled.text), forKey: "card")
        parm.updateValue(sp_getString(string: self.phoneView.textFiled.text), forKey: "mobile")
        parm.updateValue(sp_getString(string: self.codeView.textFiled.text), forKey: "verifycode")
        parm.updateValue(sp_getString(string: self.cardView.textFiled.text), forKey: "idcard")
        parm.updateValue(sp_getString(string: self.subbranchView.textFiled.text), forKey: "bank_branch")
        let request = SPRequestModel()
        request.parm = parm
        sp_showAnimation(view: self.view, title: nil)
        SPFundsRequest.sp_getBankCardAdd(requestModel: request) { [weak self](code , msg, errorModel) in
            sp_hideAnimation(view: self?.view)
            if code == SP_Request_Code_Success{
                sp_showTextAlert(tips: msg.count > 0 ? msg : "添加银行卡成功")
                self?.navigationController?.popViewController(animated: true)
            }else{
                sp_showTextAlert(tips: msg)
            }
        }
        
    }
}
extension SPAddBankCardVC {
    
    fileprivate func sp_addNotification(){
        NotificationCenter.default.addObserver(self, selector: #selector(sp_keyboardWillShow(obj:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(sp_keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    @objc private func sp_keyboardWillShow(obj:Notification){
        let height = sp_getKeyBoardheight(notification: obj)
        sp_updateTableLayout(height: height)
    }
    @objc private func sp_keyboardWillHide(){
        sp_updateTableLayout(height: 0)
    }
    private func sp_updateTableLayout(height:CGFloat){
        self.scrollView.snp.remakeConstraints { (maker) in
            maker.left.top.right.equalTo(self.view).offset(0)
            if height > 0 {
                maker.bottom.equalTo(self.view.snp.bottom).offset(-height)
            }else{
                maker.bottom.equalTo(self.doneBtn.snp.top).offset(-10)
            }
        }
    }
}
