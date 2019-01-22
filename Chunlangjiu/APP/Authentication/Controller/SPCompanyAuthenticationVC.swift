//
//  SPCompanyAuthenticationVC.swift
//  Chunlangjiu
//
//  Created by 黄树鹏 on 2018/7/26.
//  Copyright © 2018年 Chunlang. All rights reserved.
//

import Foundation
import SnapKit
class SPCompanyAuthenticationVC: SPBaseVC {
    fileprivate lazy var scrollView : UIScrollView = {
        return UIScrollView()
    }()
    fileprivate lazy var titleLabel : UILabel = {
        let label = UILabel()
        label.font = sp_getFontSize(size: 15)
        label.textColor = SPColorForHexString(hex: SP_HexColor.color_333333.rawValue)
        label.textAlignment = .left
        let mAtt = NSMutableAttributedString()
        mAtt.append(NSAttributedString(string: "企业认证", attributes: [NSAttributedStringKey.font : sp_getFontSize(size: 15),NSAttributedStringKey.foregroundColor : SPColorForHexString(hex: SP_HexColor.color_333333.rawValue)]))
        mAtt.append(NSAttributedString(string: "（请上传真实的个人信息，认证通过后将无法修改）", attributes: [NSAttributedStringKey.font : sp_getFontSize(size: 11),NSAttributedStringKey.foregroundColor : SPColorForHexString(hex: SP_HexColor.color_666666.rawValue)]))
        label.attributedText = mAtt
        label.numberOfLines = 0
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
    fileprivate lazy var companyNameView : SPAddressEditView = {
        let view = sp_createEditView(title: "企业名称", placeholder: "请输入企业（公司）名称")
        return view
    }()
    fileprivate lazy var nameView : SPAddressEditView = {
        let view = sp_createEditView(title: "法人姓名", placeholder: "请输入企业（公司）法人姓名")
        return view
    }()
    fileprivate lazy var cardView : SPAddressEditView =  {
        let view = sp_createEditView(title: "身份证号", placeholder: "请输入企业（公司）法人身份证号")
        return view
    }()
    fileprivate lazy var codeView : SPAddressEditView = {
        let view = sp_createEditView(title: "营业执照", placeholder: "请输入")
        view.textFiled.keyboardType = UIKeyboardType.asciiCapable
        return view
    }()
    fileprivate lazy var timeView : SPAddressSelectView = {
        let view = SPAddressSelectView()
        view.titleLabel.text = "成立时间"
        view.placeholder = "请选择"
        view.backgroundColor = UIColor.white
        view.selectBlock = { [weak self] () in
            self?.sp_clickTime()
        }
        return view
    }()
    fileprivate lazy var areaView : SPAddressEditView = {
        let view = sp_createEditView(title: "经营区域", placeholder: "请输入")
        return view
    }()
    fileprivate lazy var addressView : SPAddressEditView = {
        let view = sp_createEditView(title: "详细地址", placeholder: "请输入")
        return view
    }()
    fileprivate lazy var telView : SPAddressEditView = {
        let view = sp_createEditView(title: "固定电话", placeholder: "请输入")
        view.textFiled.keyboardType = UIKeyboardType.phonePad
        return view
    }()
    fileprivate lazy var businessImageView : SPAuthAddImgView = {
        let view = SPAuthAddImgView()
        view.titleLabel.text = "营业执照副本照片"
        view.detLabel.text = "上传营业执照照片"
        view.submitBtn.setTitle("上传营业执照", for: UIControlState.normal)
        view.tipLabel.text = ""
        view.sp_update(tipBottom: -3)
        view.sp_update(imgHeight: 236)
        view.clickAddBlock = { [weak self](addView)in
            self?.sp_dealClickImageAction(addView: addView)
        }
        return view
    }()
    fileprivate lazy var cardImageView  :SPAuthAddImgView = {
        let view = SPAuthAddImgView()
        view.titleLabel.text = "法人身份证正面面照"
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
        view.titleLabel.text = "法人身份证反面照"
        view.detLabel.text = "请用手机横向拍摄以保证图片正常显示"
        view.submitBtn.setTitle("上传反面照", for: UIControlState.normal)
        view.clickAddBlock = { [weak self](addView)in
            self?.sp_dealClickImageAction(addView: addView)
        }
        return view
    }()
    fileprivate lazy var licenceImageView : SPAuthAddImgView = {
        let view = SPAuthAddImgView()
        view.titleLabel.text = "食品流通许可证/酒水流通许可证"
        view.detLabel.text = "上传许可证"
        view.submitBtn.setTitle("上传许可证", for: UIControlState.normal)
        view.tipLabel.text = ""
        view.sp_update(tipBottom: -3)
        view.sp_update(imgHeight: 236)
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
        btn.addTarget(self, action: #selector(sp_submit), for: UIControlEvents.touchUpInside)
        btn.sp_cornerRadius(cornerRadius: 5)
        return btn
    }()
    fileprivate func sp_createEditView(title:String,placeholder : String) -> SPAddressEditView{
        let view = SPAddressEditView()
        view.backgroundColor = UIColor.white
        view.titleLabel.text = title
        view.textFiled.placeholder = placeholder
        view.sp_updateTitleLeft(left: 20)
        return view
    }
    fileprivate var businessUrl : String?
    fileprivate var cardUrl : String?
    fileprivate var oppositeUrl : String?
    fileprivate var licenceUrl : String?
    fileprivate var tempAddImageView : SPAuthAddImgView?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "企业认证信息"
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
        self.scrollView.addSubview(self.companyNameView)
        self.scrollView.addSubview(self.nameView)
        self.scrollView.addSubview(self.cardView)
//        self.scrollView.addSubview(self.codeView)
//        self.scrollView.addSubview(self.timeView)
//        self.scrollView.addSubview(self.areaView)
//        self.scrollView.addSubview(self.addressView)
//        self.scrollView.addSubview(self.telView)
        self.scrollView.addSubview(self.businessImageView)
        self.scrollView.addSubview(self.cardImageView)
        self.scrollView.addSubview(self.oppositeView)
        self.scrollView.addSubview(self.licenceImageView)
        self.scrollView.addSubview(self.confirmTipLabel)
        self.scrollView.addSubview(self.submitBtn)
        self.sp_addConstraint()
    }
    /// 添加约束
    fileprivate func sp_addConstraint(){
        self.scrollView.snp.makeConstraints { (maker) in
            maker.left.right.top.equalTo(self.view).offset(0)
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
            maker.left.equalTo(self.scrollView.snp.left).offset(10)
            maker.right.equalTo(self.scrollView.snp.right).offset(-10)
            maker.height.greaterThanOrEqualTo(0)
            maker.top.equalTo(self.scrollView).offset(18)
            maker.centerX.equalTo(self.scrollView.snp.centerX).offset(0)
        }
        self.companyNameView.snp.makeConstraints { (maker) in
            maker.left.right.equalTo(self.scrollView).offset(0)
            maker.top.equalTo(self.titleLabel.snp.bottom).offset(19)
            maker.centerX.equalTo(self.scrollView.snp.centerX).offset(0)
            maker.height.equalTo(50)
        }
        self.nameView.snp.makeConstraints { (maker) in
            maker.left.right.height.equalTo(self.companyNameView).offset(0)
            maker.top.equalTo(self.companyNameView.snp.bottom).offset(0)
        }
        self.cardView.snp.makeConstraints { (maker) in
            maker.left.right.height.equalTo(self.companyNameView).offset(0)
            maker.top.equalTo(self.nameView.snp.bottom).offset(0)
        }
//        self.codeView.snp.makeConstraints { (maker) in
//            maker.left.right.height.equalTo(self.nameView).offset(0)
//            maker.top.equalTo(self.nameView.snp.bottom).offset(0)
//        }
//        self.timeView.snp.makeConstraints { (maker) in
//            maker.left.right.height.equalTo(self.codeView).offset(0)
//            maker.top.equalTo(self.codeView.snp.bottom).offset(0)
//        }
//        self.areaView.snp.makeConstraints { (maker) in
//            maker.left.right.height.equalTo(self.timeView).offset(0)
//            maker.top.equalTo(self.timeView.snp.bottom).offset(0)
//        }
//        self.addressView.snp.makeConstraints { (maker) in
//            maker.left.right.height.equalTo(self.areaView).offset(0)
//            maker.top.equalTo(self.areaView.snp.bottom).offset(0)
//        }
//        self.telView.snp.makeConstraints { (maker) in
//            maker.left.right.height.equalTo(self.addressView).offset(0)
//            maker.top.equalTo(self.addressView.snp.bottom).offset(0)
//        }
        self.businessImageView.snp.makeConstraints { (maker) in
            maker.left.right.equalTo(self.scrollView).offset(0)
            maker.top.equalTo(self.cardView.snp.bottom).offset(10)
           maker.height.greaterThanOrEqualTo(0)
        }
        self.cardImageView.snp.makeConstraints { (maker) in
            maker.left.right.equalTo(self.scrollView).offset(0)
            maker.top.equalTo(self.businessImageView.snp.bottom).offset(10)
            maker.height.greaterThanOrEqualTo(0)
        }
        self.oppositeView.snp.makeConstraints { (maker) in
            maker.left.right.equalTo(self.scrollView).offset(0)
            maker.top.equalTo(self.cardImageView.snp.bottom).offset(10)
            maker.height.greaterThanOrEqualTo(0)
        }
        self.licenceImageView.snp.makeConstraints { (maker) in
            maker.left.right.equalTo(self.scrollView).offset(0)
            maker.top.equalTo(self.oppositeView.snp.bottom).offset(10)
            maker.height.greaterThanOrEqualTo(0)
        }
        self.confirmTipLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.scrollView).offset(10)
            maker.right.equalTo(self.scrollView).offset(-10)
            maker.height.greaterThanOrEqualTo(0)
            maker.top.equalTo(self.licenceImageView.snp.bottom).offset(20)
        }
        self.submitBtn.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.scrollView).offset(10)
            maker.right.equalTo(self.scrollView).offset(-10)
            maker.top.equalTo(self.confirmTipLabel.snp.bottom).offset(10)
            maker.height.greaterThanOrEqualTo(40)
            maker.bottom.equalTo(self.scrollView.snp.bottom).offset(-10)
        }
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
extension SPCompanyAuthenticationVC {
    fileprivate func sp_dealClickImageAction(addView : SPAuthAddImgView?){
        self.tempAddImageView = addView
        sp_showSelectImage(viewController: self, allowsEditing: false,delegate: self)
    }
}
extension SPCompanyAuthenticationVC :UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let image = info[ UIImagePickerControllerOriginalImage] as? UIImage
        if let view = self.tempAddImageView {
            if view == self.businessImageView {
                self.businessUrl = nil
            }else if view == self.cardImageView {
                self.cardUrl = nil
            }else if view == self.licenceImageView {
                self.licenceUrl = nil
            }
            view.sp_update(image: image)
        }
        picker.dismiss(animated: true, completion: nil)
    }
}
extension SPCompanyAuthenticationVC{
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
extension SPCompanyAuthenticationVC {
    fileprivate func sp_clickTime(){
        sp_hideKeyboard()
        SPDatePicker.sp_show(datePickerMode: UIDatePicker.Mode.date, minDate: nil, maxDate: Date()) { (date) in
             self.timeView.content = sp_getString(string: SPDateManager.sp_dateString(to: date))
        }
    }
    @objc fileprivate func sp_submit(){
        guard sp_getString(string: self.companyNameView.textFiled.text).count > 0 else {
            sp_showTextAlert(tips: "请输入企业（公司）名称")
            return
        }
        guard sp_getString(string: self.nameView.textFiled.text).count > 0  else {
            sp_showTextAlert(tips: "请输入企业（公司）法人名称")
            return
        }
        guard sp_getString(string: self.cardView.textFiled.text).count > 0  else {
            sp_showTextAlert(tips: "请输入企业（公司）法人身份证号")
            return
        }
//        guard sp_getString(string: self.codeView.textFiled.text).count > 0 else {
//            sp_showTextAlert(tips: "请输入营业执照")
//            return
//        }
//
//        guard sp_getString(string: self.timeView.content).count > 0 else {
//            sp_showTextAlert(tips: "请输入成立时间")
//            return
//        }
//        guard sp_getString(string: self.areaView.textFiled.text).count > 0 else {
//            sp_showTextAlert(tips: "请输入经营区域")
//            return
//        }
//        guard sp_getString(string: self.addressView.textFiled.text).count > 0 else {
//            sp_showTextAlert(tips: "请输入详细地址")
//            return
//        }
//        guard sp_getString(string: self.telView.textFiled.text).count > 0  else {
//            sp_showTextAlert(tips: "请输入固定电话")
//            return
//        }
        guard businessImageView.imgView.image != nil else {
            sp_showTextAlert(tips: "请上传营业执照副本照片")
            return
        }
        guard cardImageView.imgView.image != nil else {
            sp_showTextAlert(tips: "请上传法人身份证正面面照")
            return
        }
        guard oppositeView.imgView.image != nil else {
            sp_showTextAlert(tips: "请上传法人身份证反面照")
            return
        }
        guard licenceImageView.imgView.image != nil else {
            sp_showTextAlert(tips: "请上传食品流通许可证/酒水流通许可证")
            return
        }
        sp_uploadImg()
    }
}
// MARK: - request
extension SPCompanyAuthenticationVC {
    fileprivate func sp_uploadImg(){
        sp_showAnimation(view: self.view, title: nil)
        if sp_getString(string: self.businessUrl).count == 0 || sp_getString(string: self.cardUrl).count == 0 || sp_getString(string: self.licenceUrl).count == 0 {
            let group = DispatchGroup()
            
            if sp_getString(string: self.businessUrl).count == 0{
                let uploadImage = sp_fixOrientation(aImage: self.businessImageView.imgView.image!)
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
                            self?.businessUrl = sp_getString(string: upload.url)
                        }
                        group.leave()
                    }
                }
            }
            if sp_getString(string: self.cardUrl).count == 0{
                let uploadImage = sp_fixOrientation(aImage: self.cardImageView.imgView.image!)
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
                            self?.cardUrl = sp_getString(string: upload.url)
                        }
                        group.leave()
                    }
                }
            }
            if sp_getString(string: self.oppositeUrl).count == 0 {
                let uploadImage = sp_fixOrientation(aImage: self.oppositeView.imgView.image!)
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
                            self?.oppositeUrl = sp_getString(string: upload.url)
                        }
                        group.leave()
                    }
                }
            }
            if sp_getString(string: self.licenceUrl).count == 0 {
                let uploadImage = sp_fixOrientation(aImage: self.licenceImageView.imgView.image!)
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
                            self?.licenceUrl = sp_getString(string: upload.url)
                        }
                        group.leave()
                    }
                }
            }
            
            group.notify(queue: .main) {
                if sp_getString(string: self.businessUrl).count != 0 , sp_getString(string: self.cardUrl).count != 0 ,sp_getString(string: self.licenceUrl).count != 0 ,sp_getString(string: self.oppositeUrl).count != 0{
                    self.sp_sendRequest()
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
        parm.updateValue(sp_getString(string: self.companyNameView.textFiled.text), forKey: "company_name")
        parm.updateValue(sp_getString(string: self.nameView.textFiled.text), forKey: "representative")
        parm.updateValue(sp_getString(string: self.codeView.textFiled.text), forKey: "license_num")
        parm.updateValue(sp_getString(string: self.timeView.contentLabel.text), forKey: "establish_date")
        parm.updateValue(sp_getString(string: self.areaView.textFiled.text), forKey: "area")
        parm.updateValue(sp_getString(string: self.addressView.textFiled.text), forKey: "address")
        parm.updateValue(sp_getString(string: self.telView.textFiled.text), forKey: "company_phone")
        parm.updateValue(sp_getString(string: self.businessUrl), forKey: "license_img")
        parm.updateValue(sp_getString(string: self.cardUrl), forKey: "shopuser_identity_img_z")
        parm.updateValue(sp_getString(string: self.licenceUrl), forKey: "food_or_wine_img")
        requestModel.parm = parm
      
        SPAppRequest.sp_getCompanyAuth(requestModel: self.requestModel) { [weak self](code, msg, errorModel) in
         sp_hideAnimation(view: self?.view)
          
            if code == SP_Request_Code_Success {
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
