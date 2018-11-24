//
//  SPOrderApplyRefundVC.swift
//  Chunlangjiu
//
//  Created by 黄树鹏 on 2018/9/2.
//  Copyright © 2018年 Chunlang. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
import SnapKit


class SPOrderApplyRefundVC: SPBaseVC {
    
    fileprivate lazy var scrollView : UIScrollView = {
        var view = UIScrollView()
        return view
    }()
    fileprivate lazy var titleLabel : UILabel = {
        let label = UILabel()
        label.backgroundColor = UIColor.white
        label.font = sp_getFontSize(size: 14)
        label.textColor = SPColorForHexString(hex: SP_HexColor.color_333333.rawValue)
        label.text = "   售后商品"
        return label
    }()
    fileprivate lazy var cellView : SPOrderProductView = {
        let view = SPOrderProductView()
        view.backgroundColor = UIColor.white
        return view
    }()
    fileprivate lazy var numView : SPAddressSelectView = {
        let view = SPAddressSelectView()
        view.titleLabel.text = "申请数量"
        view.placeholder = "请选择"
        view.backgroundColor =  UIColor.white
        return view
    }()
    fileprivate lazy var reasonView : SPAddressSelectView = {
        let view = SPAddressSelectView()
        view.titleLabel.text = "售后原因"
        view.placeholder = "请选择"
        view.backgroundColor = UIColor.white
        view.selectBlock = { [weak self]() in
            self?.sp_clickReason()
        }
        return view
    }()
    fileprivate lazy var remarkView : SPAddressEditView = {
        let view = SPAddressEditView()
        view.titleLabel.text = "备注"
        view.textFiled.placeholder = "请填写"
        view.textFiled.textAlignment = .right
        view.backgroundColor = UIColor.white
        return view
    }()
    fileprivate lazy var addView : SPOrderAddView  = {
        let view = SPOrderAddView()
        view.viewController = self
        return view
    }()
    fileprivate lazy var submitBtn : UIButton = {
        let btn = UIButton(type: UIButtonType.custom)
        btn.setTitle("提交售后申请", for: UIControlState.normal)
        btn.setTitleColor(UIColor.white, for: UIControlState.normal)
        btn.titleLabel?.font = sp_getFontSize(size: 18)
        btn.backgroundColor = SPColorForHexString(hex: SP_HexColor.color_b31f3f.rawValue)
        btn.addTarget(self, action: #selector(sp_clickSubmit), for: UIControlEvents.touchUpInside)
        return btn
    }()
    
    var itemModel : SPOrderItemModel?
    var orderModel : SPOrderModel? 
    fileprivate var reasonArray : [String]?
    override func viewDidLoad() {
        super.viewDidLoad()
         self.navigationItem.title = "申请售后"
        self.sp_setupUI()
        sp_setupData()
        sp_showAnimation(view: self.view, title: nil)
        sp_sendReasonRequest()
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
        self.cellView.orderItem = self.itemModel
    }
    /// 创建UI
    override func sp_setupUI() {
        self.view.addSubview(self.scrollView)
        self.scrollView.addSubview(self.titleLabel)
        self.scrollView.addSubview(self.cellView)
//        self.scrollView.addSubview(self.numView)
        self.scrollView.addSubview(self.reasonView)
        self.scrollView.addSubview(self.remarkView)
        self.scrollView.addSubview(self.addView)
        self.view.addSubview(self.submitBtn)
        self.sp_addConstraint()
    }
    
    /// 添加约束
    fileprivate func sp_addConstraint(){
        self.scrollView.snp.makeConstraints { (maker) in
            maker.left.right.top.equalTo(self.view).offset(0)
            maker.bottom.equalTo(self.submitBtn.snp.top).offset(0)
        }
        self.submitBtn.snp.makeConstraints { (maker) in
            maker.left.right.equalTo(self.view).offset(0)
            maker.height.equalTo(49)
            if #available(iOS 11.0, *) {
                maker.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(0)
            } else {
                maker.bottom.equalTo(self.view.snp.bottom).offset(0)
            }
        }
        self.titleLabel.snp.makeConstraints { (maker) in
            maker.left.top.equalTo(self.scrollView).offset(0)
            maker.width.equalTo(self.scrollView.snp.width).offset(0)
            maker.centerX.equalTo(self.scrollView.snp.centerX).offset(0)
            maker.height.equalTo(44)
        }
        self.cellView.snp.makeConstraints { (maker) in
            maker.left.right.equalTo(self.titleLabel).offset(0)
            maker.top.equalTo(self.titleLabel.snp.bottom).offset(0)
            maker.height.equalTo(70)
        }
//        self.numView.snp.makeConstraints { (maker) in
//            maker.left.right.equalTo(self.titleLabel).offset(0)
//            maker.top.equalTo(self.cellView.snp.bottom).offset(0)
//            maker.height.equalTo(44)
//        }
        self.reasonView.snp.makeConstraints { (maker) in
            maker.left.right.equalTo(self.titleLabel).offset(0)
            maker.height.equalTo(44)
            maker.top.equalTo(self.cellView.snp.bottom).offset(0)
        }
        self.remarkView.snp.makeConstraints { (maker) in
            maker.left.right.equalTo(self.titleLabel).offset(0)
            maker.top.equalTo(self.reasonView.snp.bottom).offset(10)
            maker.height.equalTo(44)
        }
        self.addView.snp.makeConstraints { (maker) in
            maker.left.right.equalTo(self.titleLabel).offset(0)
            maker.height.greaterThanOrEqualTo(0)
            maker.top.equalTo(self.remarkView.snp.bottom).offset(0)
            maker.bottom.equalTo(self.scrollView).offset(0)
        }
       
    }
    deinit {
        
    }
}
// MARK: - action data
extension SPOrderApplyRefundVC {
    fileprivate func sp_clickReason(){
        SPPickerView.sp_show(data: self.reasonArray) { [weak self](isSuccess, selectString,index) in
            if isSuccess {
                self?.reasonView.content = sp_getString(string: selectString)
            }
        }
    }
    @objc fileprivate func sp_clickSubmit(){
        guard sp_getString(string: self.reasonView.contentLabel.text).count > 0 else {
            sp_showTextAlert(tips: "请选择售后原因")
            return
        }
        sp_sendUpload()
    }
}
// MARK: - request
extension SPOrderApplyRefundVC {
    /// 获取申请退货的理由
    fileprivate func sp_sendReasonRequest(){
        let request = SPRequestModel()
        var parm = [String: Any]()
        parm.updateValue(self.itemModel?.oid ?? 0 , forKey: "oid")
        request.parm = parm
        SPOrderRequest.sp_getApplyRefundReason(requestModel: request) { [weak self](code, list, errorModel, total) in
            if code == SP_Request_Code_Success {
                self?.reasonArray = list as? [String]
            }
            sp_hideAnimation(view: self?.view)
        }
    }
    fileprivate func sp_sendUpload(){
        let imageArray = self.addView.sp_getImage()
         sp_showAnimation(view: self.view, title: "提交中...")
        SPOrderHandle.sp_uploadImage(imageType: "aftersales", imageArray: imageArray) { [weak self](isSuccess, imagePaths) in
            if isSuccess {
                self?.sp_sendApply(imageList: imagePaths)
            }else{
                sp_hideAnimation(view: self?.view)
                sp_showTextAlert(tips: "上传图片失败")
            }
        }
    }
    
    /// 提交申请退货
    fileprivate func sp_sendApply(imageList : [String]?){
        var parm = [String:Any]()
        parm.updateValue(self.orderModel?.tid ?? 0, forKey: "tid")
        parm.updateValue(self.itemModel?.oid ?? 0, forKey: "oid")
        parm.updateValue(sp_getString(string: self.reasonView.contentLabel.text), forKey: "reason")
        parm.updateValue(sp_getString(string: self.remarkView.textFiled.text), forKey: "description")
        parm.updateValue("REFUND_GOODS", forKey: "aftersales_type")
        if sp_isArray(array: imageList) {
            parm.updateValue( sp_getString(string: imageList?.joined(separator: ",")), forKey: "evidence_pic")
        }
        self.requestModel.parm = parm
        
        
        SPOrderRequest.sp_getApplyRefund(requestModel: self.requestModel) { [weak self](code, msg, errorModel) in
            sp_hideAnimation(view: self?.view)
            if code  == SP_Request_Code_Success {
                sp_showTextAlert(tips: msg.count > 0 ? msg : "申请成功")
                self?.navigationController?.popViewController(animated: true)
            }else{
                sp_showTextAlert(tips: msg.count > 0  ? msg : "申请失败")
            }
        }
    }
}
