//
//  SPOrderLogisticsView.swift
//  Chunlangjiu
//
//  Created by 黄树鹏 on 2018/9/8.
//  Copyright © 2018年 Chunlang. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
class SPOrderLogisticsView:  UIView{
    
    fileprivate lazy var contentView : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        return view
    }()
    fileprivate lazy var titleLabel : UILabel = {
        let label = UILabel()
        label.font = sp_getFontSize(size: 16)
        label.textAlignment = .center
        label.text = "请填写物流信息"
        label.textColor = SPColorForHexString(hex: SP_HexColor.color_333333.rawValue)
        return label
    }()
    fileprivate lazy var nameTextField : SPAddressSelectView = {
        let view = SPAddressSelectView()
        view.titleLabel.text = "快递公司"
        view.selectBlock = {
            self.sp_showPicker()
        }
        view.placeholder = "请选择快递公司"
        return view
    }()
    fileprivate lazy var numTextField : SPAddressEditView = {
        let textField = SPAddressEditView()
        textField.titleLabel.text = "快递号"
        textField.textFiled.placeholder = "请输入快递号"
        textField.textFiled.keyboardType = UIKeyboardType.asciiCapable
        return textField
    }()
    fileprivate lazy var canceBtn : UIButton = {
        let btn = UIButton()
        btn.setTitle("取消", for: UIControlState.normal)
        btn.setTitleColor(SPColorForHexString(hex: SP_HexColor.color_666666.rawValue), for: UIControlState.normal)
        btn.titleLabel?.font = sp_getFontSize(size: 16)
        btn.addTarget(self, action: #selector(sp_clickCance), for: UIControlEvents.touchUpInside)
        btn.sp_cornerRadius(cornerRadius: 20)
        btn.sp_border(color: SPColorForHexString(hex: SP_HexColor.color_666666.rawValue), width: sp_lineHeight)
        return btn
    }()
    fileprivate lazy var doneBtn : UIButton = {
        let btn = UIButton()
        btn.setTitle("确定", for: UIControlState.normal)
        btn.setTitleColor(SPColorForHexString(hex: SP_HexColor.color_b31f3f.rawValue), for: UIControlState.normal)
        
        btn.titleLabel?.font = sp_getFontSize(size: 16)
        btn.addTarget(self, action: #selector(sp_clickDone), for: UIControlEvents.touchUpInside)
        btn.sp_cornerRadius(cornerRadius: 20)
        btn.sp_border(color: SPColorForHexString(hex: SP_HexColor.color_b31f3f.rawValue), width: sp_lineHeight)
        return btn
    }()
    fileprivate var orderModel : SPOrderModel?
    fileprivate var complete : SPOrderHandleComplete?
    fileprivate var dataArray : [SPLogisticsModel]?
    fileprivate var selectLogModel : SPLogisticsModel?
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.sp_setupUI()
        sp_sendLogistic()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    class func sp_show(orderModel : SPOrderModel?,complete : SPOrderHandleComplete?){
        let view = SPOrderLogisticsView()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        view.orderModel = orderModel
        view.complete = complete
        let appdelegate : AppDelegate = UIApplication.shared.delegate as! AppDelegate
        appdelegate.window?.addSubview(view)
        view.snp.makeConstraints { (maker) in
            maker.left.right.top.bottom.equalTo(appdelegate.window!).offset(0)
        }
    }
    
    /// 添加UI
    fileprivate func sp_setupUI(){
        self.addSubview(self.contentView)
        self.contentView.addSubview(self.titleLabel)
        self.contentView.addSubview(self.nameTextField)
        self.contentView.addSubview(self.numTextField)
        self.contentView.addSubview(self.canceBtn)
        self.contentView.addSubview(self.doneBtn)
        self.sp_addConstraint()
    }
    /// 添加约束
    fileprivate func sp_addConstraint(){
        self.contentView.snp.makeConstraints { (maker) in
            maker.left.equalTo(self).offset(30)
            maker.right.equalTo(self).offset(-30)
            maker.height.greaterThanOrEqualTo(0)
            maker.centerY.equalTo(self.snp.centerY).offset(0)
        }
        self.titleLabel.snp.makeConstraints { (maker) in
            maker.left.right.top.equalTo(self.contentView).offset(0)
            maker.height.equalTo(40)
        }
        self.nameTextField.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.contentView.snp.left).offset(0)
            maker.right.equalTo(self.contentView.snp.right).offset(0)
            maker.top.equalTo(self.titleLabel.snp.bottom).offset(10)
            maker.height.equalTo(40)
        }
        self.numTextField.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.contentView.snp.left).offset(0)
            maker.right.equalTo(self.contentView.snp.right).offset(0)
            maker.height.equalTo(40)
            maker.top.equalTo(self.nameTextField.snp.bottom).offset(10)
        }
        self.canceBtn.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.contentView).offset(10)
            maker.top.equalTo(self.numTextField.snp.bottom).offset(10)
            maker.height.equalTo(40)
            maker.width.equalTo(self.doneBtn.snp.width).offset(0)
        }
        self.doneBtn.snp.makeConstraints { (maker) in
            maker.top.height.equalTo(self.canceBtn).offset(0)
            maker.left.equalTo(self.canceBtn.snp.right).offset(10)
            maker.right.equalTo(self.contentView).offset(-10)
            maker.width.equalTo(self.canceBtn.snp.width).offset(0)
            maker.bottom.equalTo(self.contentView).offset(-10)
        }
    }
    deinit {
        
    }
}
extension SPOrderLogisticsView {
    @objc fileprivate func sp_clickCance(){
        sp_dealComplete(isSuccess: false)
        sp_remove()
    }
    @objc fileprivate func sp_clickDone(){
          sp_sendSubmit()
    }
    fileprivate func sp_remove(){
        self.removeFromSuperview()
    }
    fileprivate func sp_dealComplete(isSuccess : Bool){
        guard let block = self.complete else {
            return
        }
        if isSuccess {
            SPOrderHandle.sp_dealOrderNotificaton(orderModel: orderModel)
        }
        block(isSuccess)
    }
    fileprivate func sp_showPicker(){
        guard let list = self.dataArray else {
            sp_showTextAlert(tips: "请稍后")
            return
        }
        var stringArray = [String]()
        for model  in list {
            if sp_getString(string: model.corp_name).count > 0 {
                stringArray.append(sp_getString(string: model.corp_name))
            }
        }
        
        SPPickerView.sp_show(data: stringArray) { (isSuccess, select, index) in
            if isSuccess {
                if index < sp_getArrayCount(array: self.dataArray){
                    self.selectLogModel = self.dataArray?[index]
                }
                self.nameTextField.content = sp_getString(string: select)
            }
        }
        
    }

}
extension SPOrderLogisticsView {
    fileprivate func sp_sendLogistic(){
        let request = SPRequestModel()
        let parm = [String:Any]()
        request.parm = parm
        sp_showAnimation(view: self, title: nil)
        SPOrderRequest.sp_getLogisticsList(requestModel: request) {(code, list, errorModel, total) in
            sp_hideAnimation(view: self)
            if code == SP_Request_Code_Success{
                self.dataArray = list as? [SPLogisticsModel]
            }else{
                self.sp_sendLogistic()
            }
        }
    }
    fileprivate func sp_sendSubmit(){
        guard let model = self.selectLogModel else {
            sp_showTextAlert(tips: "请选择快递公司")
            return
        }
        guard sp_getString(string: self.numTextField.textFiled.text).count > 0  else {
            sp_showTextAlert(tips: "请输入快递单号")
            return
        }
        sp_showAnimation(view: self, title: nil)
        let request = SPRequestModel()
        var  parm = [String:Any]()
      
        parm.updateValue(sp_getString(string: self.numTextField.textFiled.text), forKey: "logi_no")
        parm.updateValue(sp_getString(string: model.corp_code), forKey: "corp_code")
       
        
        if SPAPPManager.sp_isBusiness() {
            parm.updateValue(self.orderModel?.tid ?? 0, forKey: "tid")
            if sp_getString(string: SP_SHOP_ACCESSTOKEN).count > 0   {
                parm.updateValue(SP_SHOP_ACCESSTOKEN, forKey: "accessToken")
            }
        }else{
              parm.updateValue(sp_getString(string: self.orderModel?.aftersales_bn), forKey: "aftersales_bn")
        }
         request.parm = parm
        if SPAPPManager.sp_isBusiness() {
            SPOrderRequest.sp_getShopDelivery(requestModel: request) { (code, msg, errorModel) in
                sp_hideAnimation(view: self)
                if code == SP_Request_Code_Success{
                    sp_showTextAlert(tips: msg.count > 0 ? msg : "提交成功")
                    self.sp_dealComplete(isSuccess: true)
                    self.sp_remove()
                }else{
                    sp_showTextAlert(tips: msg.count > 0 ? msg : "提交失败")
                }
            }
        }else{
            SPOrderRequest.sp_getSubmitLogistics(requestModel: request) { (code , msg, errorModel) in
                sp_hideAnimation(view: self)
                if code == SP_Request_Code_Success{
                    sp_showTextAlert(tips: msg.count > 0 ? msg : "提交成功")
                    self.sp_dealComplete(isSuccess: true)
                    self.sp_remove()
                }else{
                    sp_showTextAlert(tips: msg.count > 0 ? msg : "提交失败")
                }
                
            }
        }
        
    }
    
    
}
