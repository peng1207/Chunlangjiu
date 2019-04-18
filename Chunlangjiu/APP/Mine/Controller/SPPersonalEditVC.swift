//
//  SPPersonalEditVC.swift
//  Chunlangjiu
//
//  Created by 黄树鹏 on 2019/3/8.
//  Copyright © 2019 Chunlang. All rights reserved.
//

import Foundation
import SnapKit

enum SPPersonalEditType  : String{
    /// 店铺名称
    case shopName          = "shopName"
    /// 店铺地址
    case shopAddress       = "shopAddress"
    /// 店铺介绍
    case shopIntroduction  = "shopIntroduction"
    /// 手机号
    case phone             = "phone"
    /// 用户名
    case userName          = "userName"
}
typealias SPPersonalEditSuccessComplete = (_ text : String)->Void

class SPPersonalEditVC: SPBaseVC {
    
    fileprivate lazy var scrollView : UIScrollView = {
        let view = UIScrollView()
        return view
    }()
    fileprivate lazy var contentView : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        return view
    }()
    fileprivate lazy var textFiled : SPTextFiled = {
        let view = SPTextFiled()
        view.inputAccessoryView = SPKeyboardTopView.sp_showView(canceBlock: {
            
        }, doneBlock: {
            
        });
        return view
    }()
    fileprivate lazy var textView : SPTextView = {
        let view = SPTextView()
        return view
    }()
    
    fileprivate lazy var doneBtn : UIButton = {
        let btn = UIButton(type: UIButtonType.custom)
        btn.setTitle("确定", for: UIControlState.normal)
        btn.setTitleColor(SPColorForHexString(hex: SP_HexColor.color_ffffff.rawValue), for: UIControlState.normal)
        btn.backgroundColor = SPColorForHexString(hex: SP_HexColor.color_b31f3f.rawValue)
        btn.titleLabel?.font = sp_getFontSize(size: 15)
        btn.sp_cornerRadius(cornerRadius: 5)
        btn.addTarget(self, action: #selector(sp_clickDone), for: UIControlEvents.touchUpInside)
        return btn
    }()
   
    var type : SPPersonalEditType = .shopName
    var text : String?
    var successBlock : SPPersonalEditSuccessComplete?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.sp_setupUI()
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
    /// 创建UI
    override func sp_setupUI() {
        self.view.addSubview(self.scrollView)
        self.scrollView.addSubview(self.contentView)
        if self.type == .shopAddress || self.type == .shopIntroduction {
            self.contentView.addSubview(self.textView)
        }else{
            self.contentView.addSubview(self.textFiled)
        }
        self.scrollView.addSubview(self.doneBtn)
        self.sp_addConstraint()
    }
    /// 赋值
    fileprivate func sp_setupData(){
        switch type {
        case .shopName:
            self.navigationItem.title = "修改店铺名称"
            self.textFiled.text = sp_getString(string: text)
            self.textFiled.placeholder = "请输入店铺名称"
        case .shopAddress:
            self.navigationItem.title = "修改店铺地址"
            self.textView.content = sp_getString(string: text)
            self.textView.placeholderLabel.text = "请输入店铺地址"
        case .shopIntroduction:
            self.navigationItem.title = "修改店铺简介"
            self.textView.content = sp_getString(string: text)
            self.textView.placeholderLabel.text = "请输入店铺简介"
        case .userName:
            self.navigationItem.title = "修改昵称"
            self.textFiled.text = sp_getString(string: text)
            self.textFiled.placeholder = "请输入您的昵称"
        case .phone:
            self.navigationItem.title = "修改联系方式"
            self.textFiled.text = sp_getString(string: text)
            self.textFiled.placeholder = "请输入您联系方式"
        }
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
        self.contentView.snp.makeConstraints { (maker) in
            maker.left.right.equalTo(self.scrollView).offset(0)
            maker.height.greaterThanOrEqualTo(0)
            maker.centerX.equalTo(self.scrollView.snp.centerX).offset(0)
            maker.top.equalTo(self.scrollView).offset(10)
        }
        self.doneBtn.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.scrollView).offset(10)
            maker.right.equalTo(self.scrollView).offset(-10)
            maker.height.equalTo(40)
            maker.top.equalTo(self.contentView.snp.bottom).offset(100)
            maker.bottom.equalTo(self.scrollView.snp.bottom).offset(-20)
        }
        if self.type == .shopAddress || self.type == .shopIntroduction {
            self.textView.snp.makeConstraints { (maker) in
                maker.left.equalTo(self.contentView).offset(20)
                maker.right.equalTo(self.contentView.snp.right).offset(-20)
                maker.height.equalTo(100)
                maker.top.equalTo(self.contentView).offset(2)
                maker.bottom.equalTo(self.contentView).offset(-2)
            }
        }else{
            self.textFiled.snp.makeConstraints { (maker) in
                maker.left.equalTo(self.contentView).offset(20)
                maker.right.equalTo(self.contentView.snp.right).offset(-20)
                maker.height.equalTo(40)
                maker.top.equalTo(self.contentView).offset(0)
                maker.bottom.equalTo(self.contentView).offset(0)
            }
        }
        
    }
    deinit {
        
    }
}
extension SPPersonalEditVC {
    @objc fileprivate func sp_clickDone(){
        if self.type == .shopAddress || self.type == .shopIntroduction {
            if sp_getString(string: self.textView.textView.text).count == 0 {
                sp_showTextAlert(tips: self.type == .shopAddress ? "请输入店铺地址" : "请输入店铺简介")
            return
            }
        }else{
            if sp_getString(string: self.textFiled.text).count == 0 {
                if self.type == .phone {
                    sp_showTextAlert(tips: "请输入您的联系方式")
                     return
                }else if self.type == .shopName {
                    sp_showTextAlert(tips: "请输入您的店铺名称")
                     return
                }else if self.type == .userName {
                    sp_showTextAlert(tips: "请输入您的昵称")
                     return
                }
               
            }
        }
        sp_sendRequest()
    }
    
}
extension SPPersonalEditVC {
    /// 发送请求
    fileprivate func sp_sendRequest(){
        sp_showAnimation(view: self.view, title: nil)
        var parm = [String : Any]()
        parm.updateValue(sp_getString(string: SPAPPManager.instance().memberModel?.shop_name), forKey: "shopname")
        parm.updateValue(sp_getString(string: SPAPPManager.instance().memberModel?.bulletin), forKey: "bulletin")
        parm.updateValue(sp_getString(string: SPAPPManager.instance().memberModel?.sex), forKey: "sex")
        parm.updateValue(sp_getString(string: SPAPPManager.instance().memberModel?.area), forKey: "area")
        parm.updateValue(sp_getString(string: SPAPPManager.instance().memberModel?.phone), forKey: "phone")
        switch type {
        case .shopName:
            parm.updateValue(sp_getString(string: self.textFiled.text), forKey: "shopname")
        case .shopAddress:
           parm.updateValue(sp_getString(string: self.textView.textView.text), forKey: "area")
        case .shopIntroduction:
             parm.updateValue(sp_getString(string: self.textView.textView.text), forKey: "bulletin")
        case .userName:
           sp_log(message: "暂时没有")
        case .phone:
            parm.updateValue(sp_getString(string: self.textFiled.text), forKey: "phone")
        }
        self.requestModel.parm = parm
        SPAppRequest.sp_getUpdateInfo(requestModel: self.requestModel) { [weak self](code, msg, errorModel) in
            self?.sp_dealRequestSuccess(code: code, msg: msg, errorModel: errorModel)
        }
    }
    /// 处理请求回调
    ///
    /// - Parameters:
    ///   - code: 错误码
    ///   - msg: 提示信息
    ///   - errorModel: 错误码
    private func sp_dealRequestSuccess(code : String,msg : String,errorModel : SPRequestError?){
        sp_hideAnimation(view: self.view)
        if code == SP_Request_Code_Success {
            sp_showTextAlert(tips: sp_getString(string: msg).count > 0 ? sp_getString(string: msg) : "修改成功")
            sp_saveData()
            sp_dealSuccessComplete()
            self.navigationController?.popViewController(animated: true)
        }else{
            sp_showTextAlert(tips: sp_getString(string: msg).count > 0 ? sp_getString(string: msg) : "修改失败")
        }
        
    }
    /// 处理成功的回调
    private func sp_dealSuccessComplete(){
        guard let block = self.successBlock else {
            return
        }
        var text = ""
        if self.type == .shopIntroduction || self.type == .shopAddress {
            text = sp_getString(string: self.textView.textView.text)
        }else{
            text = sp_getString(string: self.textFiled.text)
        }
        block(sp_getString(string: text))
    }
    private func sp_saveData(){
        if let model = SPAPPManager.instance().memberModel {
            switch type {
            case .shopName:
               model.shop_name = sp_getString(string: self.textFiled.text)
            case .shopAddress:
                model.area = sp_getString(string: self.textView.textView.text)
            case .shopIntroduction:
                model.bulletin = sp_getString(string: self.textView.textView.text)
            case .userName:
                model.username = sp_getString(string: self.textFiled.text)
            case .phone:
              model.phone = sp_getString(string: self.textFiled.text)
            }
            SPAPPManager.instance().memberModel = model
            
        }
    }
    
}

