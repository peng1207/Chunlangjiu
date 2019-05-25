//
//  SPAddAdressVC.swift
//  Chunlangjiu
//
//  Created by 黄树鹏 on 2018/7/17.
//  Copyright © 2018年 Chunlang. All rights reserved.
//

import Foundation
import SnapKit
class SPAddAdressVC: SPBaseVC {
    
    fileprivate lazy var scrollView : UIScrollView = {
        let view = UIScrollView()
        return view
    }()
    
    fileprivate lazy var nameView : SPAddressEditView = {
        let view = SPAddressEditView()
       view.backgroundColor = UIColor.white
        view.textFiled.placeholder = "请输入"
        view.titleLabel.text = "收货人"
        return view
    }()
    fileprivate lazy var phoneView : SPAddressEditView = {
        let view = SPAddressEditView()
        view.backgroundColor = UIColor.white
        view.textFiled.placeholder = "请输入"
        view.titleLabel.text = "联系方式"
        return view
    }()
    fileprivate lazy var areaView : SPAddressSelectView = {
        let view = SPAddressSelectView()
        view.titleLabel.text = "选择地区"
        view.backgroundColor = UIColor.white
        view.placeholder = "请选择"
        view.selectBlock = { [weak self]() in
            self?.sp_clickAreaAction()
        }
        return view
    }()
    fileprivate lazy var addressView : SPAddressFlexView = {
        let view = SPAddressFlexView()
        view.titleLabel.text = "详细地址"
        view.backgroundColor = UIColor.white
        view.textView.placeholderLabel.text = "请输入街道、楼牌号等"
        view.textView.textView.isScrollEnabled = false 
        return view
    }()
    fileprivate lazy var defaultView : SPAddressDefautView = {
        let view = SPAddressDefautView()
        view.backgroundColor = UIColor.white
        view.deleteBtn.isHidden = true
        return view
    }()
    fileprivate lazy var showAreaView : SPAddressAreaView! = {
        let view = SPAddressAreaView()
        view.selectComplete = { [weak self](_ provinceModel : SPAreaModel?,_ cityModel : SPAreaModel? ,_ areaModel : SPAreaModel?) in
                self?.sp_dealSelectAreaComplete(provinceModel, cityModel, areaModel)
        }
       
        
        return view
    }()
    
    fileprivate lazy var saveBtn : UIButton = {
        let btn = UIButton(type: UIButtonType.custom)
        btn.setTitle("保存", for: UIControlState.normal)
        btn.titleLabel?.font = sp_getFontSize(size: 16)
        btn.setTitleColor(UIColor.white, for: UIControlState.normal)
        btn.backgroundColor = SPColorForHexString(hex: SP_HexColor.color_b31f3f.rawValue)
        btn.addTarget(self, action: #selector(sp_clickSaveAction), for: UIControlEvents.touchUpInside)
        return btn
    }()
    var addressModel : SPAddressModel?
    fileprivate var provinceModel : SPAreaModel?
    fileprivate var cityModel : SPAreaModel?
    fileprivate var areaModel : SPAreaModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.sp_setupUI()
        self.sp_setupData()
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
        self.view.addSubview(self.scrollView)
        self.view.addSubview(self.saveBtn)
        self.scrollView.addSubview(self.nameView)
        self.scrollView.addSubview(self.phoneView)
        self.scrollView.addSubview(self.areaView)
        self.scrollView.addSubview(self.addressView)
        self.scrollView.addSubview(self.defaultView)
        self.sp_addConstraint()
    }
    /// 添加约束
    fileprivate func sp_addConstraint(){
        self.scrollView.snp.makeConstraints { (maker) in
            maker.left.top.right.equalTo(self.view).offset(0)
            maker.bottom.equalTo(self.saveBtn.snp.top).offset(0)
        }
        self.saveBtn.snp.makeConstraints { (maker) in
            maker.left.right.equalTo(self.view).offset(0)
            maker.height.equalTo(49)
            if #available(iOS 11.0, *) {
                maker.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(0)
            } else {
                maker.bottom.equalTo(self.view.snp.bottom).offset(0)
            }
           
        }
        self.nameView.snp.makeConstraints { (maker) in
            maker.left.right.top.equalTo(self.scrollView).offset(0)
            maker.height.equalTo(44)
            maker.centerX.equalTo(self.scrollView.snp.centerX).offset(0)
        }
        self.phoneView.snp.makeConstraints { (maker) in
            maker.left.right.equalTo(self.nameView).offset(0)
            maker.top.equalTo(self.nameView.snp.bottom).offset(0)
            maker.height.equalTo(44)
        }
        self.areaView.snp.makeConstraints { (maker) in
            maker.left.right.equalTo(self.phoneView).offset(0)
            maker.top.equalTo(self.phoneView.snp.bottom).offset(0)
            maker.height.greaterThanOrEqualTo(44)
        }
        self.addressView.snp.makeConstraints { (maker) in
            maker.left.right.equalTo(self.areaView).offset(0)
            maker.top.equalTo(self.areaView.snp.bottom).offset(0)
            maker.height.greaterThanOrEqualTo(0)
        }
        self.defaultView.snp.makeConstraints { (maker) in
            maker.left.right.equalTo(self.addressView).offset(0)
            maker.top.equalTo(self.addressView.snp.bottom).offset(0)
            maker.height.equalTo(44)
            maker.bottom.equalTo(self.scrollView.snp.bottom).offset(-10)
        }
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
// MARK: - 请求事件 事件
extension SPAddAdressVC {
    @objc fileprivate func sp_clickSaveAction(){
        guard sp_getString(string: self.nameView.textFiled.text).count > 0 else {
            sp_showTextAlert(tips: "请输入收货人")
            return
        }
        guard sp_getString(string: self.phoneView.textFiled.text).count > 0 else {
            sp_showTextAlert(tips: "请输入联系方式")
            return
        }
        guard self.provinceModel != nil || self.cityModel != nil || self.areaModel != nil else {
            sp_showTextAlert(tips: "请选择地区")
            return
        }
        guard sp_getString(string: self.addressView.textView.content).count > 0 else {
            sp_showTextAlert(tips: "请输入详细地址")
            return
        }
        sp_sendRequest()
    }
    fileprivate func sp_clickAreaAction(){
        sp_hideKeyboard()
        self.showAreaView.sp_showView()
    }
    /// 赋值
    fileprivate func sp_setupData(){
        guard let model = self.addressModel else {
            return
        }
        self.nameView.textFiled.text = sp_getString(string: model.name)
        self.phoneView.textFiled.text = sp_getString(string: model.mobile)
        self.areaView.content = sp_getString(string: model.area)
        self.addressView.textView.content = sp_getString(string: model.addr)
    
        self.defaultView.selectBtn.isSelected = model.def_addr == 0 ? false : true
        
        let array = sp_getString(string: model.region_id).components(separatedBy: CharacterSet(charactersIn: ","))
        var index = 0
        for s in array {
            if index == 0 {
                self.showAreaView.provinceID = s
            }else if index == 1 {
                self.showAreaView.cityID = s
            }else if index == 2 {
                self.showAreaView.areaID = s
            }
            index = index + 1
        }
        
        self.showAreaView.sp_dealData()
        self.provinceModel = self.showAreaView.provinceModel
        self.cityModel = self.showAreaView.cityModel
        self.areaModel = self.showAreaView.areaModel
        
    }
    /// 处理选择省市区回调
    ///
    /// - Parameters:
    ///   - provinceModel: 省model
    ///   - cityModel: 城市model
    ///   - areaModel: 地区model
    fileprivate func sp_dealSelectAreaComplete(_ provinceModel : SPAreaModel?,_ cityModel : SPAreaModel? ,_ areaModel : SPAreaModel?){
        self.provinceModel = provinceModel
        self.cityModel = cityModel
        self.areaModel = areaModel
        self.sp_dealAreaData()
    }
    fileprivate func sp_dealAreaData(){
        self.areaView.content = "\(sp_getString(string: self.provinceModel?.value))\(sp_getString(string: self.cityModel?.value))\(sp_getString(string: self.areaModel?.value))"
    }
    /// 发送请求
    fileprivate func sp_sendRequest(){
        sp_showAnimation(view: self.view, title: nil)
        var parm = [String:Any]()
        if let a = self.addressModel {
            parm.updateValue(sp_getString(string: a.addr_id), forKey: "addr_id")
        }
        var area : String = ""
        if let m = self.provinceModel {
            if area.count > 0 {
                area.append(",")
            }
            area.append(sp_getString(string: m.id))
        }
        if let m = self.cityModel{
            if area.count > 0 {
                area.append(",")
            }
            area.append(sp_getString(string: m.id))
        }
        if let m = self.areaModel {
            if area.count > 0 {
                area.append(",")
            }
            area.append(sp_getString(string: m.id))
        }
        parm.updateValue(sp_getString(string: area), forKey: "area")
 
        parm.updateValue(sp_getString(string: self.addressView.textView.content), forKey: "addr")
        parm.updateValue(sp_getString(string: self.nameView.textFiled.text), forKey: "name")
        parm.updateValue(sp_getString(string: self.phoneView.textFiled.text), forKey: "mobile")
        parm.updateValue(self.defaultView.selectBtn.isSelected ? 1 : 0 , forKey: "def_addr")
        parm.updateValue("", forKey: "zip")
        self.requestModel.parm = parm
        if sp_getString(string: self.addressModel?.addr_id).count != 0  {
            sp_sendEditRequest()
        }else{
            sp_sendAddRequest()
        }
    }
    /// 发送添加请求
    private func sp_sendAddRequest(){
        SPAppRequest.sp_getAddAddress(requestModel: self.requestModel) { [weak self](code, msg, errorModel) in
            sp_hideAnimation(view: self?.view)
            if code == SP_Request_Code_Success {
                self?.navigationController?.popViewController(animated: true)
            }else{
                sp_showTextAlert(tips: msg)
            }
        }
    }
    /// 发送编辑请求
    private func sp_sendEditRequest(){
        SPAppRequest.sp_getUpdateAddress(requestModel: self.requestModel) { [weak self](code, msg, errorModel) in
            sp_hideAnimation(view: self?.view)
            if code == SP_Request_Code_Success {
                self?.navigationController?.popViewController(animated: true)
            }else{
                sp_showTextAlert(tips: msg)
            }
        }
    }
    
    
    
}
extension SPAddAdressVC {
    fileprivate func sp_addNotification(){
        NotificationCenter.default.addObserver(self, selector: #selector(sp_keyBoardWillShow(obj:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(sp_keyBoardWillHidden), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    @objc private func sp_keyBoardWillShow(obj : Notification){
         let height = sp_getKeyBoardheight(notification: obj)
        sp_dealScrollViewlayout(height: height)
    }
    
    @objc private func sp_keyBoardWillHidden(){
        sp_dealScrollViewlayout(height: 0)
    }
    fileprivate func sp_dealScrollViewlayout(height:CGFloat){
        self.scrollView.snp.remakeConstraints { (maker) in
            maker.left.top.right.equalTo(self.view).offset(0)
            if height > 0 {
                maker.bottom.equalTo(self.view.snp.bottom).offset(-height)
            }else{
                  maker.bottom.equalTo(self.saveBtn.snp.top).offset(0)
            }
          
        }
    }
    
}
