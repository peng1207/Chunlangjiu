//
//  SPAppraisalVC.swift
//  Chunlangjiu
//
//  Created by 黄树鹏 on 2019/4/24.
//  Copyright © 2019 Chunlang. All rights reserved.
//

import Foundation
import SnapKit
class SPAppraisalVC: SPBaseVC {
    fileprivate lazy var scrollView : UIScrollView = {
        let view = UIScrollView()
        return view
    }()
    fileprivate lazy var productView : SPAppraisalResultProductView = {
        let view = SPAppraisalResultProductView()
        view.backgroundColor = SPColorForHexString(hex: SP_HexColor.color_ffffff.rawValue)
        view.clickBlock = { [weak self] (index)in
            self?.sp_clickImg(index: index)
        }
        return view
    }()
    fileprivate lazy var detView : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        return view
    }()
    fileprivate lazy var detTitleLabel : UILabel = {
        let label = UILabel()
        label.font = sp_getFontSize(size: 18)
        label.textColor = SPColorForHexString(hex: SP_HexColor.color_b31f3f.rawValue)
        label.textAlignment = .left
        label.text = "评估详情"
        return label
    }()
    fileprivate lazy var priceView : SPAddressEditView = {
        let view = SPAddressEditView()
        view.titleLabel.text = "名酒估价:"
        view.textFiled.placeholder = "请输入价格"
        view.textFiled.keyboardType = UIKeyboardType.decimalPad
       
        view.textFiled.delegate = self
        return view
    }()
    fileprivate lazy var conditionView : SPAddressEditView = {
        let view = SPAddressEditView()
        view.titleLabel.text = "名酒成色:"
        view.textFiled.placeholder = "请输入酒成色"
        return view
    }()
    fileprivate lazy var flawView : SPAddressEditView = {
        let view = SPAddressEditView()
        view.titleLabel.text = "瑕疵情况:"
        view.textFiled.placeholder = "请输入商品外观"
        return view
    }()
    fileprivate lazy var enclosureView : SPAddressEditView = {
        let view = SPAddressEditView()
        view.titleLabel.text = "附件情况:"
        view.textFiled.placeholder = "请输入附件情况"
        return view
    }()
    fileprivate lazy var explainView : SPAddressFlexView = {
        let view = SPAddressFlexView()
        view.titleLabel.text = "其他内容:"
        view.textView.placeholderLabel.text = "您可填写酒的其他详情"
        view.textView.minHeight = 50
        view.textView.placeholderLabel.font = sp_getFontSize(size: 14)
        view.textView.placeholderLabel.textColor = SPColorForHexString(hex: SP_HexColor.color_999999.rawValue).withAlphaComponent(0.6)
        view.textView.textView.font = sp_getFontSize(size: 14)
         view.textView.textView.isScrollEnabled = false
        return view
    }()
    fileprivate lazy var submitBtn : UIButton = {
        let btn = UIButton(type: UIButtonType.custom)
        btn.setTitle("提交鉴定报告", for: UIControlState.normal)
        btn.setTitleColor(SPColorForHexString(hex: SP_HexColor.color_ffffff.rawValue), for: UIControlState.normal)
        btn.backgroundColor = SPColorForHexString(hex: SP_HexColor.color_b31f3f.rawValue)
        btn.titleLabel?.font = sp_getFontSize(size: 18)
        btn.addTarget(self, action: #selector(sp_clickSubmit), for: UIControlEvents.touchUpInside)
        return btn
    }()
    var model : SPAppraisalProductModel?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.sp_setupUI()
        sp_addNotification()
        sp_setupData()
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
    /// 赋值
    fileprivate func sp_setupData(){
            self.productView.model = self.model
    }
    /// 创建UI
    override func sp_setupUI() {
        self.navigationItem.title = "名酒鉴别"
        self.view.addSubview(self.scrollView)
        self.scrollView.addSubview(self.productView)
        self.scrollView.addSubview(self.detView)
        self.detView.addSubview(self.detTitleLabel)
        self.detView.addSubview(self.priceView)
        self.detView.addSubview(self.conditionView)
        self.detView.addSubview(self.flawView)
        self.detView.addSubview(self.enclosureView)
        self.detView.addSubview(self.explainView)
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
        self.productView.snp.makeConstraints { (maker) in
            maker.width.equalTo(self.scrollView).offset(0)
            maker.centerX.equalTo(self.scrollView.snp.centerX).offset(0)
            maker.top.equalTo(self.scrollView.snp.top).offset(0)
            maker.height.greaterThanOrEqualTo(0)
        }
        self.detView.snp.makeConstraints { (maker) in
            maker.top.equalTo(self.productView.snp.bottom).offset(16)
            maker.left.right.equalTo(self.productView).offset(0)
            maker.height.greaterThanOrEqualTo(0)
        }
        self.detTitleLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.detView).offset(15)
            maker.top.equalTo(self.detView).offset(0)
            maker.height.equalTo(50)
            maker.right.equalTo(self.detView).offset(-15)
        }
        self.priceView.snp.makeConstraints { (maker) in
            maker.left.right.equalTo(self.detView).offset(0)
            maker.top.equalTo(self.detTitleLabel.snp.bottom).offset(0)
            maker.height.equalTo(50)
        }
        self.conditionView.snp.makeConstraints { (maker) in
            maker.left.right.height.equalTo(self.priceView).offset(0)
            maker.top.equalTo(self.priceView.snp.bottom).offset(0)
        }
        self.flawView.snp.makeConstraints { (maker) in
            maker.left.right.height.equalTo(self.conditionView).offset(0)
            maker.top.equalTo(self.conditionView.snp.bottom).offset(0)
        }
        self.enclosureView.snp.makeConstraints { (maker) in
            maker.left.right.height.equalTo(self.flawView).offset(0)
            maker.top.equalTo(self.flawView.snp.bottom).offset(0)
        }
        self.explainView.snp.makeConstraints { (maker) in
            maker.left.right.equalTo(self.enclosureView).offset(0)
            maker.height.greaterThanOrEqualTo(50)
            maker.top.equalTo(self.enclosureView.snp.bottom).offset(0)
            maker.bottom.equalTo(self.detView.snp.bottom).offset(0)
        }
        self.submitBtn.snp.makeConstraints { (maker) in
            maker.left.right.equalTo(self.scrollView).offset(0)
            maker.centerX.equalTo(self.scrollView).offset(0)
            maker.top.equalTo(self.detView.snp.bottom).offset(57)
            maker.height.equalTo(50)
            maker.bottom.equalTo(self.scrollView.snp.bottom).offset(0)
        }
        
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
extension SPAppraisalVC {
    
    @objc fileprivate func sp_clickSubmit(){
      
     
        
        
        if sp_getString(string: self.priceView.textFiled.text).count == 0 {
            sp_showTextAlert(tips: "请输入价格")
            return
        }
        if sp_getString(string: self.conditionView.textFiled.text).count == 0 {
            sp_showTextAlert(tips: "请输入酒成色")
            return
        }
        if sp_getString(string: self.flawView.textFiled.text).count == 0 {
            sp_showTextAlert(tips: "请输入商品外观")
            return
        }
        if sp_getString(string: self.enclosureView.textFiled.text).count == 0 {
            sp_showTextAlert(tips: "请输入附件情况")
            return
        }
//        if sp_getString(string: self.explainView.textView.textView.text).count == 0 {
//            sp_showTextAlert(tips: "请输入其他内容")
//            return
//        }
        sp_sendSubmitRequest()
    }
    fileprivate func sp_clickImg(index : Int){
        let lookPictureVC = SPLookPictureVC()
        lookPictureVC.dataArray = self.model?.sp_getImgList()
        lookPictureVC.selectIndex = index
        self.present(lookPictureVC, animated: true, completion: nil)
    }
    
}
extension SPAppraisalVC {
    
    fileprivate func sp_addNotification(){
        NotificationCenter.default.addObserver(self, selector: #selector(sp_keyBoardWillShow(obj:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(sp_keyBoardWillHidden), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    @objc private func sp_keyBoardWillShow(obj : Notification){
        let height = sp_getKeyBoardheight(notification: obj)
        self.scrollView.snp.remakeConstraints { (maker) in
            maker.left.top.right.equalTo(self.view).offset(0)
            maker.bottom.equalTo(self.view).offset(-height)
        }
    }
    @objc private func sp_keyBoardWillHidden(){
        self.scrollView.snp.remakeConstraints { (maker) in
            maker.left.top.right.equalTo(self.view).offset(0)
            if #available(iOS 11.0, *) {
                maker.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(0)
            } else {
                maker.bottom.equalTo(self.view.snp.bottom).offset(0)
            }
        }
    }
    
}
extension SPAppraisalVC {
    
    fileprivate func sp_sendSubmitRequest(){
        sp_showAnimation(view: self.view, title: nil)
        var price = sp_getString(string: self.priceView.textFiled.text)
        price = price.trimmingCharacters(in: .whitespaces)
        
        if price.first == "0" {
            // 判断 第一个字符为0
            sp_log(message: "第一个字符为0 ")
            var priceArray = price.components(separatedBy: ".")
            if priceArray.count > 0{
                let priceValue = priceArray[0]
                var tempPrice = ""
                var canAdd = false
                for s in priceValue {
                    sp_log(message: s)
                    if s == "0"{
                        if canAdd {
                            tempPrice.append(s)
                        }
                    }else {
                        canAdd = true
                        tempPrice.append(s)
                    }
                }
                if tempPrice.count == 0 {
                    tempPrice = "0"
                }
                priceArray[0] = tempPrice
            }
            price =  priceArray.joined(separator: ".")
            sp_log(message: "结果:" +  priceArray.joined(separator: "."))
        }
        var parm = [String : Any]()
        
        parm.updateValue("", forKey: "chateau_id")
        parm.updateValue(sp_getString(string: price), forKey: "price")
        parm.updateValue(sp_getString(string: self.conditionView.textFiled.text), forKey: "colour")
        parm.updateValue(sp_getString(string: self.flawView.textFiled.text), forKey: "flaw")
        parm.updateValue(sp_getString(string: self.enclosureView.textFiled.text), forKey: "accessory")
        parm.updateValue(sp_getString(string: self.explainView.textView.textView.text), forKey: "details")
        parm.updateValue(sp_getString(string: self.model?.chateau_id), forKey: "chateau_id")
        self.requestModel.parm = parm
        SPAppraisalRequest.sp_getAuthenticate(requestModel: self.requestModel) { [weak self](code, msg, errorModel) in
            self?.sp_dealSubmitComplete(code: code, msg: msg, errorModel: errorModel)
        }
    }
    fileprivate func sp_dealSubmitComplete(code : String,msg:String,errorModel : SPRequestError?){
        sp_hideAnimation(view: self.view)
        if code == SP_Request_Code_Success {
            sp_showTextAlert(tips: msg.count > 0 ? msg : "提交成功")
            sp_asyncAfter(time: 1) {
                self.navigationController?.popViewController(animated: true)
            }
        }else{
            sp_showTextAlert(tips: msg.count > 0 ? msg : "提交失败，请重新提交")
        }
    }
    
}
extension SPAppraisalVC : UITextFieldDelegate {
    
 
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string == "." {
            if let isContaint = self.priceView.textFiled.text?.contains("."), isContaint == true ,textField.markedTextRange == nil {
                return false
            }else{
                return true
            }
            
        }
        return true
    }
}
