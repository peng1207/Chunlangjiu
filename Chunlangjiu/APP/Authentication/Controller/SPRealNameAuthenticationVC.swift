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
    fileprivate lazy var nameView : SPAddressEditView = {
        let view = SPAddressEditView()
        view.titleLabel.text = "姓名"
        view.textFiled.placeholder = "请输入"
        view.backgroundColor = UIColor.white
        return view
    }()
    fileprivate lazy var typeView : SPAddressSelectView = {
        let view = SPAddressSelectView()
        view.titleLabel.text = "证件类型"
        view.placeholder = "请选择"
        view.content = "身份证"
        view.nextImageView.isHidden = true
        view.backgroundColor = UIColor.white
        return view
    }()
    fileprivate lazy var numView : SPAddressEditView = {
        let view = SPAddressEditView()
        view.titleLabel.text = "证件号码"
        view.textFiled.placeholder = "请输入"
        view.backgroundColor = UIColor.white
        view.lineView.isHidden = true
        view.textFiled.keyboardType = .asciiCapable
        return view
    }()
    /// 正面证件
    fileprivate lazy var positiveView : SPAddImageView = {
        let view = SPAddImageView()
        view.showDelete = true
        view.showImageView.titleLabel.text = "上传身份证正面"
        view.showImageView.sp_border(color: SPColorForHexString(hex: SP_HexColor.color_dddddd.rawValue), width: sp_lineHeight)
        view.clickAddBlock = { [weak self](addImageView) in
            self?.sp_dealClickImageAction(addView: addImageView)
        }
        return view
    }()
    ///  反面证件
    fileprivate lazy var oppositeView : SPAddImageView = {
        let view = SPAddImageView()
        view.showDelete = true
        view.showImageView.titleLabel.text = "上传身份证反面"
        view.showImageView.sp_border(color: SPColorForHexString(hex: SP_HexColor.color_dddddd.rawValue), width: sp_lineHeight)
        view.clickAddBlock = { [weak self](addImageView) in
            self?.sp_dealClickImageAction(addView: addImageView)
        }
        return view
    }()
    /// 手持证件
    fileprivate lazy var holdView : SPAddImageView = {
        let view = SPAddImageView()
        view.showDelete = true
        view.showImageView.titleLabel.text = "手持本人身份证"
        view.showImageView.sp_border(color: SPColorForHexString(hex: SP_HexColor.color_dddddd.rawValue), width: sp_lineHeight)
        view.clickAddBlock = { [weak self](addImageView) in
            self?.sp_dealClickImageAction(addView: addImageView)
        }
        return view
    }()
    fileprivate lazy var submitBtn : UIButton = {
        let btn = UIButton()
        btn.setTitle("提交审核", for: UIControlState.normal)
        btn.setTitleColor(UIColor.white, for: UIControlState.normal)
        btn.titleLabel?.font = sp_getFontSize(size: 18)
        btn.backgroundColor = SPColorForHexString(hex: SP_HexColor.color_b31f3f.rawValue)
        btn.addTarget(self, action: #selector(sp_clickSubmit), for: UIControlEvents.touchUpInside)
        return btn
    }()
    fileprivate var tempAddImageView : SPAddImageView?
    fileprivate var positiveUrl : String?
    fileprivate var oppositeUrl : String?
    fileprivate var holdUrl : String?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "实名认证"
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
        self.view.addSubview(self.submitBtn)
        self.scrollView.addSubview(self.nameView)
        self.scrollView.addSubview(self.typeView)
        self.scrollView.addSubview(self.numView)
        self.scrollView.addSubview(self.positiveView)
        self.scrollView.addSubview(self.oppositeView)
        self.scrollView.addSubview(self.holdView)
        self.sp_addConstraint()
    }
    /// 添加约束
    fileprivate func sp_addConstraint(){
        self.scrollView.snp.makeConstraints { (maker) in
            maker.left.top.right.equalTo(self.view).offset(0)
            maker.bottom.equalTo(self.submitBtn.snp.top).offset(0)
        }
        self.submitBtn.snp.makeConstraints { (maker) in
            maker.left.right.equalTo(self.view).offset(0)
            maker.height.equalTo(49)
            if #available(iOS 11.0, *) {
                maker.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(0)
            } else {
                // Fallback on earlier versions
                maker.bottom.equalTo(self.view.snp.bottom).offset(0)
            }
        }
        self.nameView.snp.makeConstraints { (maker) in
            maker.left.top.right.equalTo(self.scrollView).offset(0)
            maker.height.equalTo(44)
            maker.centerX.equalTo(self.scrollView.snp.centerX).offset(0)
        }
        self.typeView.snp.makeConstraints { (maker) in
            maker.left.right.height.equalTo(self.nameView).offset(0)
            maker.top.equalTo(self.nameView.snp.bottom).offset(0)
        }
        self.numView.snp.makeConstraints { (maker) in
            maker.left.right.height.equalTo(self.typeView).offset(0)
            maker.top.equalTo(self.typeView.snp.bottom).offset(0)
        }
        self.positiveView.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.scrollView.snp.left).offset(10)
            maker.top.equalTo(self.numView.snp.bottom).offset(10)
            maker.width.equalTo(self.oppositeView.snp.width).offset(0)
            maker.height.equalTo(self.positiveView.snp.width).multipliedBy(0.64)
        }
        self.oppositeView.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.positiveView.snp.right).offset(10)
            maker.right.equalTo(self.scrollView.snp.right).offset(-10)
            maker.top.equalTo(self.positiveView.snp.top).offset(0)
            maker.height.equalTo(self.positiveView.snp.height).offset(0)
        }
        self.holdView.snp.makeConstraints { (maker) in
            maker.left.right.height.equalTo(self.positiveView).offset(0)
            maker.top.equalTo(self.positiveView.snp.bottom).offset(10)
            maker.bottom.equalTo(self.scrollView.snp.bottom).offset(-10)
        }
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
extension SPRealNameAuthenticationVC {
    fileprivate func sp_dealClickImageAction(addView : SPAddImageView?){
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
        guard self.positiveView.imageView.image != nil else {
            sp_showTextAlert(tips: "请上传身份证正面")
            return
        }
        guard self.oppositeView.imageView.image != nil else {
            sp_showTextAlert(tips: "请上传身份证反面")
            return
        }
        guard self.holdView.imageView.image != nil else {
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
                let uploadImage = sp_fixOrientation(aImage: self.positiveView.imageView.image!)
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
                let uploadImage1 = sp_fixOrientation(aImage: self.oppositeView.imageView.image!)
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
                let uploadImage2 = sp_fixOrientation(aImage: self.holdView.imageView.image!)
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
