//
//  SPRealNameAuthenticationVC.swift
//  Chunlangjiu
//
//  Created by 黄树鹏 on 2018/7/22.
//  Copyright © 2018年 Chunlang. All rights reserved.
//

import Foundation
import SnapKit
class SPRealNameAuthenticationVC: SPBaseVC {
    
    fileprivate lazy var scrollView : UIScrollView = {
        let view = UIScrollView()
        return view
    }()
    fileprivate lazy var titleLabel : UILabel = {
        let label = UILabel()
        label.font = sp_getFontSize(size: 15)
        label.textColor = SPColorForHexString(hex: SP_HexColor.color_333333.rawValue)
        label.textAlignment = .left
        let mAtt = NSMutableAttributedString()
        mAtt.append(NSAttributedString(string: "实名认证", attributes: [NSAttributedStringKey.font : sp_getFontSize(size: 15),NSAttributedStringKey.foregroundColor : SPColorForHexString(hex: SP_HexColor.color_333333.rawValue)]))
        mAtt.append(NSAttributedString(string: "（请上传真实的个人信息，认证通过后将无法修改）", attributes: [NSAttributedStringKey.font : sp_getFontSize(size: 11),NSAttributedStringKey.foregroundColor : SPColorForHexString(hex: SP_HexColor.color_666666.rawValue)]))
        label.attributedText = mAtt
        label.numberOfLines = 0
        return label
    }()
    fileprivate lazy var phoneTipLabel : UILabel = {
        let label = UILabel()
        label.font = sp_getFontSize(size: 12)
        label.textColor = SPColorForHexString(hex: SP_HexColor.color_999999.rawValue)
        label.textAlignment = .right
        label.text = "请填写有效电话，工作人员将会致电核实"
        return label
    }()
    fileprivate lazy var confirmTipLabel : UILabel = {
        let label = UILabel()
        label.font = sp_getFontSize(size: 12)
        label.textColor = SPColorForHexString(hex: SP_HexColor.color_999999.rawValue)
        label.textAlignment = .center
        label.text = "请确认以上信息准确无误"
        return label
    }()
    fileprivate lazy var infoLabel : UILabel = {
        let label = UILabel()
        label.font = sp_getFontSize(size: 10)
        label.textColor = SPColorForHexString(hex: SP_HexColor.color_999999.rawValue)
        label.textAlignment = .left
        label.numberOfLines = 0
        label.text = "认证说明：\n1、实名认证后，用户可发布酒类商品进行销售(最大数量为3件)；\n2、订单成交成功后，平台将抽取交易总额的3%作为平台佣金。\n3、升级成为星级卖家及城市合伙人，将获得更多的权益及优惠。"
        return label
    }()
    fileprivate lazy var nameView : SPAddressEditView = {
        let view = SPAddressEditView()
        view.titleLabel.text = "姓名"
        view.textFiled.placeholder = "请输入真实的姓名"
        view.backgroundColor = UIColor.white
        view.sp_updateTitleLeft(left: 20)
        return view
    }()
    fileprivate lazy var typeView : SPAddressSelectView = {
        let view = SPAddressSelectView()
        view.titleLabel.text = "证件类型"
        view.placeholder = "请选择"
        view.content = "身份证"
        view.sp_updateTitleLeft(left: 20)
        view.nextImageView.isHidden = false
        view.backgroundColor = UIColor.white
        return view
    }()
    fileprivate lazy var numView : SPAddressEditView = {
        let view = SPAddressEditView()
        view.titleLabel.text = "身份证账号"
        view.textFiled.placeholder = "请输入身份证账号"
        view.backgroundColor = UIColor.white
        view.lineView.isHidden = false
        view.textFiled.keyboardType = .asciiCapable
        view.sp_updateTitleLeft(left: 20)
        return view
    }()
    fileprivate lazy var phoneView : SPAddressEditView = {
        let view = SPAddressEditView()
        view.titleLabel.text = "手机号"
        view.textFiled.placeholder = "请输入有效电话"
        view.backgroundColor = UIColor.white
        view.lineView.isHidden = true
        view.textFiled.keyboardType = .asciiCapable
         view.sp_updateTitleLeft(left: 20)
        return view
    }()
    /// 正面证件
    fileprivate lazy var positiveView : SPAuthAddImgView = {
        let view = SPAuthAddImgView()
        view.titleLabel.text = "身份证正面照"
        view.detLabel.text = "请用手机横向拍摄以保证图片正常显示"
        view.submitBtn.setTitle("上传正面照", for: UIControlState.normal)
        view.clickAddBlock = { [weak self](addView)in
             self?.sp_dealClickImageAction(addView: addView)
        }
        return view
    }()
    ///  反面证件
    fileprivate lazy var oppositeView : SPAuthAddImgView = {
        let view = SPAuthAddImgView()
        view.titleLabel.text = "身份证反面照"
        view.detLabel.text = "请用手机横向拍摄以保证图片正常显示"
        view.submitBtn.setTitle("上传反面照", for: UIControlState.normal)
        view.clickAddBlock = { [weak self](addView)in
            self?.sp_dealClickImageAction(addView: addView)
        }
        return view
    }()
    /// 手持证件
    fileprivate lazy var holdView : SPAuthAddImgView = {
        let view = SPAuthAddImgView()
        view.titleLabel.text = "手持身份证照"
        view.detLabel.text = "请用手机横向拍摄以保证图片正常显示"
        view.submitBtn.setTitle("上传手持身份证照", for: UIControlState.normal)
        view.clickAddBlock = { [weak self](addView)in
            self?.sp_dealClickImageAction(addView: addView)
        }
        return view
    }()
    fileprivate lazy var submitBtn : UIButton = {
        let btn = UIButton()
        btn.setTitle("提交审核", for: UIControlState.normal)
        btn.setTitleColor(UIColor.white, for: UIControlState.normal)
        btn.titleLabel?.font = sp_getFontSize(size: 15)
        btn.backgroundColor = SPColorForHexString(hex: SP_HexColor.color_b31f3f.rawValue)
        btn.addTarget(self, action: #selector(sp_clickSubmit), for: UIControlEvents.touchUpInside)
        btn.sp_cornerRadius(cornerRadius: 5)
        return btn
    }()
    fileprivate var tempAddImageView : SPAuthAddImgView?
    fileprivate var positiveUrl : String?
    fileprivate var oppositeUrl : String?
    fileprivate var holdUrl : String?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "个人认证信息"
        self.sp_setupUI()
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
//        self.view.addSubview(self.submitBtn)
        self.scrollView.addSubview(self.titleLabel)
        self.scrollView.addSubview(self.phoneTipLabel)
        self.scrollView.addSubview(self.nameView)
//        self.scrollView.addSubview(self.typeView)
        self.scrollView.addSubview(self.numView)
        self.scrollView.addSubview(self.phoneView)
        self.scrollView.addSubview(self.positiveView)
        self.scrollView.addSubview(self.oppositeView)
        self.scrollView.addSubview(self.holdView)
        self.scrollView.addSubview(self.confirmTipLabel)
        self.scrollView.addSubview(self.infoLabel)
        self.scrollView.addSubview(self.submitBtn)
        
        self.sp_addConstraint()
    }
    /// 添加约束
    fileprivate func sp_addConstraint(){
        self.scrollView.snp.makeConstraints { (maker) in
            maker.left.top.right.equalTo(self.view).offset(0)
//            maker.bottom.equalTo(self.submitBtn.snp.top).offset(0)
            if #available(iOS 11.0, *) {
                maker.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(0)
            } else {
                // Fallback on earlier versions
                maker.bottom.equalTo(self.view.snp.bottom).offset(0)
            }
        }
//        self.submitBtn.snp.makeConstraints { (maker) in
//            maker.left.right.equalTo(self.view).offset(0)
//            maker.height.equalTo(49)
//            if #available(iOS 11.0, *) {
//                maker.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(0)
//            } else {
//                // Fallback on earlier versions
//                maker.bottom.equalTo(self.view.snp.bottom).offset(0)
//            }
//        }
        self.titleLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.scrollView).offset(10)
            maker.right.equalTo(self.scrollView).offset(-10)
            maker.centerX.equalTo(self.scrollView.snp.centerX).offset(0)
            maker.height.greaterThanOrEqualTo(0)
            maker.top.equalTo(self.scrollView).offset(18)
        }
        self.nameView.snp.makeConstraints { (maker) in
            maker.left.right.equalTo(self.scrollView).offset(0)
            maker.top.equalTo(self.titleLabel.snp.bottom).offset(19)
            maker.height.equalTo(50)
            maker.centerX.equalTo(self.scrollView.snp.centerX).offset(0)
        }
//        self.typeView.snp.makeConstraints { (maker) in
//            maker.left.right.height.equalTo(self.nameView).offset(0)
//            maker.top.equalTo(self.nameView.snp.bottom).offset(0)
//        }
        self.numView.snp.makeConstraints { (maker) in
            maker.left.right.height.equalTo(self.nameView).offset(0)
            maker.top.equalTo(self.nameView.snp.bottom).offset(0)
        }
        self.phoneView.snp.makeConstraints { (maker) in
            maker.left.right.height.equalTo(self.numView).offset(0)
            maker.top.equalTo(self.numView.snp.bottom).offset(0)
        }
        self.phoneTipLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.scrollView).offset(10)
            maker.right.equalTo(self.scrollView).offset(-10)
            maker.top.equalTo(self.phoneView.snp.bottom).offset(10)
            maker.height.greaterThanOrEqualTo(0)
        }
        self.positiveView.snp.makeConstraints { (maker) in
            maker.left.right.equalTo(self.scrollView).offset(0)
            maker.top.equalTo(self.phoneTipLabel.snp.bottom).offset(10)
            maker.height.greaterThanOrEqualTo(0)
        }
        self.oppositeView.snp.makeConstraints { (maker) in
            maker.left.right.equalTo(self.scrollView).offset(0)
            maker.top.equalTo(self.positiveView.snp.bottom).offset(10)
            maker.height.greaterThanOrEqualTo(0)
        }
        self.holdView.snp.makeConstraints { (maker) in
            maker.left.right.equalTo(self.scrollView).offset(0)
            maker.top.equalTo(self.oppositeView.snp.bottom).offset(10)
            maker.height.greaterThanOrEqualTo(0)
        }
        self.confirmTipLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.scrollView).offset(10)
            maker.right.equalTo(self.scrollView).offset(-10)
            maker.top.equalTo(self.holdView.snp.bottom).offset(20)
            maker.height.greaterThanOrEqualTo(0)
        }
        self.infoLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.scrollView).offset(33)
            maker.right.equalTo(self.scrollView.snp.right).offset(-33)
            maker.top.equalTo(self.confirmTipLabel.snp.bottom).offset(45)
            maker.height.greaterThanOrEqualTo(0)
        }
        self.submitBtn.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.scrollView).offset(10)
            maker.right.equalTo(self.scrollView).offset(-10)
            maker.height.equalTo(40)
            maker.top.equalTo(self.infoLabel.snp.bottom).offset(43)
            maker.bottom.equalTo(self.scrollView.snp.bottom).offset(-17)
        }
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
extension SPRealNameAuthenticationVC {
    fileprivate func sp_dealClickImageAction(addView : SPAuthAddImgView?){
        self.tempAddImageView = addView
        sp_showSelectImage(viewController: self, allowsEditing: false,delegate: self)
    }
    
}
extension SPRealNameAuthenticationVC :UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let image = info[ UIImagePickerControllerOriginalImage] as? UIImage
        if let view = self.tempAddImageView {
            if view == self.positiveView {
                self.positiveUrl = nil
            }else if view == self.oppositeView{
                self.oppositeUrl = nil
            }else if view == self.holdView {
                self.holdUrl = nil
            }
            view.sp_update(image: image)
        }
        picker.dismiss(animated: true, completion: nil)
    }
}
extension SPRealNameAuthenticationVC {
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
            maker.bottom.equalTo(self.submitBtn.snp.top).offset(0)
        }
    }
}
// MARK: - action
extension SPRealNameAuthenticationVC{
    @objc fileprivate func sp_clickSubmit(){
        guard sp_getString(string: self.nameView.textFiled.text).count > 0 else {
            sp_showTextAlert(tips: "请输入姓名")
            return
        }
        guard sp_getString(string: self.numView.textFiled.text).count > 0 else {
            sp_showTextAlert(tips: "请输入您的身份证号码")
            return
        }
        guard self.positiveView.imgView.image != nil else {
            sp_showTextAlert(tips: "请上传身份证正面")
            return
        }
        guard self.oppositeView.imgView.image != nil else {
            sp_showTextAlert(tips: "请上传身份证反面")
            return
        }
        guard self.holdView.imgView.image != nil else {
            sp_showTextAlert(tips: "请上传手持本人身份证")
            return
        }
        sp_uploadImg()
    }
}
// MARK: - 请求
extension SPRealNameAuthenticationVC{
    
    /// 上传图片
    fileprivate func sp_uploadImg(){
        sp_showAnimation(view: nil, title: nil)
        
        if sp_getString(string: self.positiveUrl).count == 0 || sp_getString(string: self.oppositeUrl).count == 0 || sp_getString(string: self.holdUrl).count == 0 {
            let group = DispatchGroup()
            
            if sp_getString(string: self.positiveUrl).count == 0{
                let uploadImage = sp_fixOrientation(aImage: self.positiveView.imgView.image!)
                let data = UIImageJPEGRepresentation(uploadImage, 0.5)
                
                if let d = data {
                    group.enter()
                    let imageRequestModel = SPRequestModel()
                    imageRequestModel.data = [d]
                    imageRequestModel.name = "image"
                    imageRequestModel.fileName = ["proudct.jpg"]
                    imageRequestModel.mineType = "image/jpg"
                    var parm = [String:Any]()
                    parm.updateValue("rate", forKey: "image_type")
                    parm.updateValue("proudct.jpg", forKey: "image_input_title")
                    parm.updateValue("binary", forKey: "upload_type")
                    imageRequestModel.parm = parm
                    SPAppRequest.sp_getUserUploadImg(requestModel: imageRequestModel) { [weak self](code, msg, uploadImageModel, errorModel) in
                        if code == SP_Request_Code_Success, let upload = uploadImageModel{
                            self?.positiveUrl = sp_getString(string: upload.url)
                        }
                        group.leave()
                    }
                }
            }
            if sp_getString(string: self.oppositeUrl).count == 0{
                let uploadImage1 = sp_fixOrientation(aImage: self.oppositeView.imgView.image!)
                let data1 = UIImageJPEGRepresentation(uploadImage1, 0.5)
                
                if let d1 = data1 {
                    group.enter()
                    let imageRequestModel1 = SPRequestModel()
                    imageRequestModel1.data = [d1]
                    imageRequestModel1.name = "image"
                    imageRequestModel1.fileName = ["proudct.jpg"]
                    imageRequestModel1.mineType = "image/jpg"
                    var parm1 = [String:Any]()
                    parm1.updateValue("rate", forKey: "image_type")
                    parm1.updateValue("proudct.jpg", forKey: "image_input_title")
                    parm1.updateValue("binary", forKey: "upload_type")
                    imageRequestModel1.parm = parm1
                    SPAppRequest.sp_getUserUploadImg(requestModel: imageRequestModel1) { [weak self](code, msg, uploadImageModel, errorModel) in
                        if code == SP_Request_Code_Success, let upload = uploadImageModel{
                            self?.oppositeUrl = sp_getString(string: upload.url)
                        }
                        group.leave()
                    }
                }
            }
            if sp_getString(string: self.holdUrl).count == 0{
                let uploadImage2 = sp_fixOrientation(aImage: self.holdView.imgView.image!)
                let data2 = UIImageJPEGRepresentation(uploadImage2, 0.5)
               
                if let d2 = data2 {
                    group.enter()
                    let imageRequestModel2 = SPRequestModel()
                    imageRequestModel2.data = [d2]
                    imageRequestModel2.name = "image"
                    imageRequestModel2.fileName = ["proudct.jpg"]
                    imageRequestModel2.mineType = "image/jpg"
                    var parm2 = [String:Any]()
                    parm2.updateValue("rate", forKey: "image_type")
                    parm2.updateValue("proudct.jpg", forKey: "image_input_title")
                    parm2.updateValue("binary", forKey: "upload_type")
                    
                    imageRequestModel2.parm = parm2
                    SPAppRequest.sp_getUserUploadImg(requestModel: imageRequestModel2) { [weak self](code, msg, uploadImageModel, errorModel) in
                        if code == SP_Request_Code_Success, let upload = uploadImageModel{
                            self?.holdUrl = sp_getString(string: upload.url)
                        }
                        group.leave()
                    }
                }
            }
            
            group.notify(queue: .main) { [weak self]() in
                if sp_getString(string: self?.oppositeUrl).count != 0 , sp_getString(string: self?.positiveUrl).count != 0, sp_getString(string: self?.holdUrl).count != 0{
                    self?.sp_sendRequest()
                }else{
                    sp_hideAnimation(view: nil)
                    sp_showTextAlert(tips: "上传图片失败")
                }
            }
        }else{
            sp_sendRequest()
        }
    }
    
    fileprivate func sp_sendRequest(){
        var parm = [String : Any]()
        parm.updateValue(sp_getString(string: self.nameView.textFiled.text), forKey: "name")
        parm.updateValue(sp_getString(string: self.numView.textFiled.text), forKey: "idcard")
        parm.updateValue(sp_getString(string: self.holdUrl), forKey: "dentity")
        parm.updateValue(sp_getString(string: self.positiveUrl), forKey: "dentity_front")
        parm.updateValue(sp_getString(string: self.oppositeUrl), forKey: "dentity_reverse")
        self.requestModel.parm = parm
        SPAppRequest.sp_getAuthonYm(requestModel: self.requestModel) { [weak self](code, msg, errorModel) in
            sp_hideAnimation(view: nil)
          
            if code == SP_Request_Code_Success{
                sp_showTextAlert(tips: "提交成功")
                sp_asyncAfter(time: 2, complete: {
                      self?.navigationController?.popViewController(animated: true)
                })
            }else{
                  sp_showTextAlert(tips: msg)
            }
        }
    }
}
