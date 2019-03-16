//
//  SPPersonalInfoVC.swift
//  Chunlangjiu
//
//  Created by 黄树鹏 on 2019/3/8.
//  Copyright © 2019 Chunlang. All rights reserved.
//

import Foundation
import SnapKit
class SPPersonalInfoVC: SPBaseVC {
    
    fileprivate lazy var scrollView : UIScrollView = {
        let view = UIScrollView()
        return view
    }()
    fileprivate lazy var headImgView : SPPersonalHeadImg = {
        let view = SPPersonalHeadImg()
        view.clickBlock = { [weak self] in
            self?.sp_clickIconAction()
        }
        return view
    }()
    fileprivate lazy var userNameView : SPPersonalSelectView = {
        let view = SPPersonalSelectView()
        view.sp_nextImg(isHidden: true)
        view.titleLabel.text = "用户名"
        return view
    }()
    fileprivate lazy var sexView : SPPersonalSelectView = {
        let view = SPPersonalSelectView()
        view.titleLabel.text = "性别"
        view.clickBlock = { [weak self] in
            self?.sp_clickSex()
        }
        return view
    }()
    fileprivate lazy var shopNameView : SPPersonalSelectView = {
        let view = SPPersonalSelectView()
        view.titleLabel.text = "店铺名称"
        view.isHidden = true
        view.clickBlock = { [weak self] in
            self?.sp_clickShopName()
        }
        return view
    }()
    fileprivate lazy var shopIntroductionView : SPPersonalManyView = {
        let view = SPPersonalManyView()
        view.title = "店铺简介"
        view.isHidden = true
        view.placeholder = "请填写店铺简介..."
        view.clickBlock = { [weak self] in
            self?.sp_clickShopIntroduction()
        }
        return view
    }()
    fileprivate lazy var shopAddressView : SPPersonalManyView = {
        let view = SPPersonalManyView()
        view.title = "店铺地址"
        view.placeholder = "请填写店铺地址..."
        view.isHidden = true
        view.clickBlock = { [weak self] in
            self?.sp_clickShopAddress()
        }
        return view
    }()
    fileprivate lazy var phoneView : SPPersonalSelectView = {
        let view = SPPersonalSelectView()
        view.titleLabel.text = "联系方式"
        view.isHidden = true
        view.clickBlock = { [weak self] in
            self?.sp_clickPhone()
        }
        return view
    }()
    fileprivate lazy var personAuthView : SPPersonAuthInfoView = {
        let view = SPPersonAuthInfoView()
        view.isHidden = true
        return view
    }()
    fileprivate lazy var companyAuthView : SPPersonCompanyAuthInfoView = {
        let view = SPPersonCompanyAuthInfoView()
        view.isHidden = true
        return view
    }()
    fileprivate lazy var toAuthView : SPPersonalSelectView = {
        let view = SPPersonalSelectView()
        view.titleLabel.text = "去认证"
        view.titleLabel.textColor = SPColorForHexString(hex: SP_HexColor.color_b31f3f.rawValue)
        view.isHidden = true
        view.clickBlock = { [weak self] in
            self?.sp_clickToAuthVC()
        }
        return view
    }()
    fileprivate var companyAuth : SPCompanyAuth?
    fileprivate var realNameAuth : SPRealNameAuth?
    fileprivate var selectSex : String?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.sp_setupUI()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        sp_sendRequest()
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
        self.navigationItem.title = "我的资料"
        self.view.addSubview(self.scrollView)
        self.scrollView.addSubview(self.headImgView)
        self.scrollView.addSubview(self.userNameView)
        self.scrollView.addSubview(self.sexView)
        self.scrollView.addSubview(self.shopNameView)
        self.scrollView.addSubview(self.shopIntroductionView)
        self.scrollView.addSubview(self.shopAddressView)
        self.scrollView.addSubview(self.phoneView)
        self.scrollView.addSubview(self.personAuthView)
        self.scrollView.addSubview(self.companyAuthView)
        self.scrollView.addSubview(self.toAuthView)
        self.sp_addConstraint()
     
    }
    /// 处理有没数据
    override func sp_dealNoData(){
        
    }
    
    /// 更新layout
    ///
    /// - Parameter isAuth: 是否认证
    fileprivate func sp_dealLayout(isAuth : Bool){
        self.toAuthView.snp.remakeConstraints { (maker) in
            maker.left.right.height.equalTo(self.sexView).offset(0)
            maker.top.equalTo(self.toAuthView.snp.bottom).offset(0)
            if !isAuth {
                maker.bottom.equalTo(self.scrollView.snp.bottom).offset(0)
            }
        }
        self.companyAuthView.snp.remakeConstraints { (maker) in
            maker.left.right.equalTo(self.personAuthView).offset(0)
            maker.top.equalTo(self.personAuthView.snp.bottom).offset(0)
            maker.height.greaterThanOrEqualTo(0)
            if isAuth {
                maker.bottom.equalTo(self.scrollView.snp.bottom).offset(0)
            }
        }
    }
    /// 处理view是否显示
    ///
    /// - Parameter isAuth: 是否认证
    fileprivate func sp_dealViewIsHidden(isAuth : Bool){
        self.toAuthView.isHidden = isAuth
        self.shopNameView.isHidden = !isAuth
        self.shopAddressView.isHidden = !isAuth
        self.shopIntroductionView.isHidden = !isAuth
        self.phoneView.isHidden = !isAuth
        self.personAuthView.isHidden = !isAuth
        self.companyAuthView.isHidden = !isAuth
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
        self.headImgView.snp.makeConstraints { (maker) in
            maker.left.right.equalTo(self.scrollView).offset(0)
            maker.top.equalTo(self.scrollView).offset(10)
            maker.height.equalTo(100)
            maker.centerX.equalTo(self.scrollView.snp.centerX).offset(0)
        }
        self.userNameView.snp.makeConstraints { (maker) in
            maker.left.right.equalTo(self.scrollView).offset(0)
            maker.top.equalTo(self.headImgView.snp.bottom).offset(0)
            maker.height.equalTo(40)
        }
        self.sexView.snp.makeConstraints { (maker) in
            maker.left.right.equalTo(self.userNameView).offset(0)
            maker.height.equalTo(self.userNameView.snp.height).offset(0)
            maker.top.equalTo(self.userNameView.snp.bottom).offset(0)
        }
        self.toAuthView.snp.makeConstraints { (maker) in
            maker.left.right.height.equalTo(self.sexView).offset(0)
            maker.top.equalTo(self.sexView.snp.bottom).offset(0)
        }
        self.shopNameView.snp.makeConstraints { (maker) in
            maker.left.right.equalTo(self.sexView).offset(0)
            maker.top.equalTo(self.sexView.snp.bottom).offset(0)
            maker.height.equalTo(self.sexView.snp.height).offset(0)
        }
        self.shopIntroductionView.snp.makeConstraints { (maker) in
            maker.left.right.equalTo(self.shopNameView).offset(0)
            maker.top.equalTo(self.shopNameView.snp.bottom).offset(0)
            maker.height.greaterThanOrEqualTo(0)
        }
        self.shopAddressView.snp.makeConstraints { (maker) in
            maker.left.right.equalTo(self.shopIntroductionView).offset(0)
            maker.top.equalTo(self.shopIntroductionView.snp.bottom).offset(0)
            maker.height.greaterThanOrEqualTo(0)
        }
        self.phoneView.snp.makeConstraints { (maker) in
            maker.left.right.equalTo(self.shopAddressView).offset(0)
            maker.top.equalTo(self.shopAddressView.snp.bottom).offset(0)
            maker.height.equalTo(self.shopNameView.snp.height).offset(0)
        }
        self.personAuthView.snp.makeConstraints { (maker) in
            maker.left.right.equalTo(self.phoneView).offset(0)
            maker.top.equalTo(self.phoneView.snp.bottom).offset(0)
            maker.height.greaterThanOrEqualTo(0)
        }
        self.companyAuthView.snp.makeConstraints { (maker) in
            maker.left.right.equalTo(self.personAuthView).offset(0)
            maker.top.equalTo(self.personAuthView.snp.bottom).offset(0)
            maker.height.greaterThanOrEqualTo(0)
//            maker.bottom.equalTo(self.scrollView.snp.bottom).offset(0)
        }
    }
    deinit {
        
    }
}
extension SPPersonalInfoVC {
    
    fileprivate func sp_clickSex(){
        let actionSheetVC = UIAlertController(title: "选择性别", message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
        actionSheetVC.addAction(UIAlertAction(title: "男", style: UIAlertActionStyle.default, handler: {[weak self] (action) in
            self?.selectSex = "1"
            self?.sp_sendSexRequest()
        }))
        actionSheetVC.addAction(UIAlertAction(title: "女", style: UIAlertActionStyle.default, handler: { [weak self](action) in
            self?.selectSex = "0"
             self?.sp_sendSexRequest()
        }))
        actionSheetVC.addAction(UIAlertAction(title: "取消", style: UIAlertActionStyle.cancel, handler: { (action) in
            
        }))
        self.present(actionSheetVC, animated: true, completion: nil)
    }
    fileprivate func sp_dealSex(){
        self.sexView.contentLabel.text = sp_getSexString(sex: self.selectSex)
       
    }
    fileprivate func sp_clickShopName(){
        let vc = SPPersonalEditVC()
        vc.type = .shopName
        vc.text = sp_getString(string: self.shopNameView.contentLabel.text)
        vc.successBlock = { [weak self] (text)in
            self?.shopNameView.contentLabel.text = sp_getString(string: text)
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    fileprivate func sp_clickShopAddress(){
        let vc = SPPersonalEditVC()
        vc.type = .shopAddress
        vc.text = sp_getString(string: self.shopAddressView.content)
        vc.successBlock = {  [weak self] (text)in
            self?.shopAddressView.content = sp_getString(string: text)
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    fileprivate func sp_clickShopIntroduction(){
        let vc = SPPersonalEditVC()
        vc.type = .shopIntroduction
        vc.text = sp_getString(string: self.shopIntroductionView.content)
        vc.successBlock = {  [weak self] (text)in
            self?.shopIntroductionView.content = sp_getString(string: text)
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    fileprivate func sp_clickPhone(){
        let vc = SPPersonalEditVC()
        vc.type = .phone
        vc.text = sp_getString(string: self.phoneView.contentLabel.text)
        vc.successBlock = { [weak self] (text)in
            self?.phoneView.contentLabel.text = sp_getString(string: text)
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    fileprivate func sp_clickToAuthVC(){
        let authVC = SPAuthHomeVC()
        self.navigationController?.pushViewController(authVC, animated: true)
    }
    /// 点击头像
    fileprivate func sp_clickIconAction(){
        //        self.pushVC = true
        //        sp_showSelectImage(viewController: self, delegate: self)
        sp_thrSelectImg(viewController: self, nav: self.navigationController) { [weak self](img) in
            self?.sp_uploadImage(image: img)
        }
    }
    fileprivate func sp_setupData(){
        var isAuth : Bool = false
        
        if sp_getString(string: self.realNameAuth?.status) == SP_STATUS_FINISH || sp_getString(string: self.companyAuth?.status) == SP_STATUS_FINISH || sp_getString(string: self.realNameAuth?.status) == SP_STATUS_MODIFIER || sp_getString(string: self.companyAuth?.status) == SP_STATUS_MODIFIER{
            isAuth = true
        }
        sp_dealLayout(isAuth: isAuth)
        sp_dealViewIsHidden(isAuth: isAuth)
        
        self.shopNameView.contentLabel.text = sp_getString(string: SPAPPManager.instance().memberModel?.shop_name)
        self.headImgView.url = sp_getString(string: SPAPPManager.instance().memberModel?.head_portrait)
        self.userNameView.contentLabel.text = sp_getString(string: SPAPPManager.instance().memberModel?.login_account)
        self.sexView.contentLabel.text = sp_getSexString(sex: SPAPPManager.instance().memberModel?.sex)
        self.shopIntroductionView.content = sp_getString(string: SPAPPManager.instance().memberModel?.bulletin)
        self.shopAddressView.content = sp_getString(string: SPAPPManager.instance().memberModel?.area)
        self.phoneView.contentLabel.text = sp_getString(string:  SPAPPManager.instance().memberModel?.phone)
        self.selectSex = sp_getString(string: SPAPPManager.instance().memberModel?.sex)
        self.personAuthView.sp_setupData()
        self.companyAuthView.sp_setupData()
        if sp_getString(string: self.realNameAuth?.status) == SP_STATUS_FINISH || sp_getString(string: self.realNameAuth?.status) == SP_STATUS_MODIFIER {
            self.personAuthView.snp.remakeConstraints { (maker) in
                maker.left.right.equalTo(self.phoneView).offset(0)
                maker.top.equalTo(self.phoneView.snp.bottom).offset(0)
                maker.height.greaterThanOrEqualTo(0)
            }
        }else{
            self.personAuthView.snp.remakeConstraints { (maker) in
                maker.left.right.equalTo(self.phoneView).offset(0)
                maker.top.equalTo(self.phoneView.snp.bottom).offset(0)
                maker.height.equalTo(0)
            }
        }
        if sp_getString(string: self.companyAuth?.status) == SP_STATUS_FINISH || sp_getString(string: self.companyAuth?.status) == SP_STATUS_MODIFIER {
            self.companyAuthView.snp.remakeConstraints { (maker) in
                maker.left.right.equalTo(self.personAuthView).offset(0)
                maker.top.equalTo(self.personAuthView.snp.bottom).offset(0)
                maker.height.greaterThanOrEqualTo(0)
                if isAuth {
                    maker.bottom.equalTo(self.scrollView.snp.bottom).offset(0)
                }
            }
        }else{
            self.companyAuthView.snp.remakeConstraints { (maker) in
                maker.left.right.equalTo(self.personAuthView).offset(0)
                maker.top.equalTo(self.personAuthView.snp.bottom).offset(0)
                maker.height.equalTo(0)
                if isAuth {
                    maker.bottom.equalTo(self.scrollView.snp.bottom).offset(0)
                }
            }
        }
    }
    
    fileprivate func sp_getSexString(sex : String? )->String{
        if sp_getString(string:sex) == "0"{
            return "女"
        }else if sp_getString(string: sex) == "1"{
            return "男"
        }else{
            return ""
        }
        
    }
    

    
}
extension SPPersonalInfoVC {
    /// 上传图片 头像
    ///
    /// - Parameter image: 图片
    fileprivate func sp_uploadImage(image : UIImage?){
        guard let uImage = image else {
            return
        }
        let uploadImage = sp_fixOrientation(aImage: uImage)
        let d = sp_resetImgSize(sourceImage: uploadImage)
        //        let data = UIImageJPEGRepresentation(uploadImage, 1.0)
        //        if let d = data {
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
        sp_showAnimation(view: nil, title: nil)
        SPAppRequest.sp_getUserUploadImg(requestModel: imageRequestModel) { [weak self](code, msg, uploadImageModel, errorModel) in
            if code == SP_Request_Code_Success, let upload = uploadImageModel{
                self?.sp_sendSet(img:sp_getString(string: upload.url))
            }else{
                sp_showTextAlert(tips: msg)
                sp_hideAnimation(view: nil)
            }
            
        }
        //        }
    }
    fileprivate func sp_sendSet(img imgUrl : String){
        let request = SPRequestModel()
        var parm = [String:Any]()
        parm.updateValue(sp_getString(string: imgUrl), forKey: "img_url")
        request.parm = parm
        SPAppRequest.sp_getUserImgSet(requestModel: request) { [weak self](code, msg, errorModel) in
            sp_hideAnimation(view: nil)
            if code == SP_Request_Code_Success {
                if let model = SPAPPManager.instance().memberModel {
                    model.head_portrait = imgUrl
                    SPAPPManager.instance().memberModel = model
                    self?.headImgView.url = imgUrl
                }
            }
            
        }
    }
    fileprivate func sp_sendRequest(){
        sp_showAnimation(view: self.view, title: nil)
        let workingGroup = DispatchGroup()
        workingGroup.enter()
        let request = SPRequestModel()
        SPAppRequest.sp_getMemberInfo(requestModel: request) { (code, memberModel, errorModel) in
            if code == SP_Request_Code_Success{
                SPAPPManager.instance().memberModel = memberModel
            }
            workingGroup.leave()
        }
        workingGroup.enter()
        let companyRequest = SPRequestModel()
        SPAppRequest.sp_getCompanyAuthStatus(requestModel: companyRequest) { [weak self](code , model, errorModel) in
            if code == SP_Request_Code_Success{
                self?.companyAuth = model
            }
            workingGroup.leave()
        }
        workingGroup.enter()
        let realRequest = SPRequestModel()
        SPAppRequest.sp_getRealNameAuth(requestModel: realRequest) { [weak self](code , model , errorModel) in
            if code == SP_Request_Code_Success{
                self?.realNameAuth = model
            }
            workingGroup.leave()
        }
        workingGroup.notify(queue: DispatchQueue(label: "request.queue")) { [weak self] in
           
            sp_mainQueue {
            self?.sp_setupData()
             sp_hideAnimation(view: self?.view)
            }
           
        }
    }
    fileprivate func sp_sendSexRequest(){
        sp_showAnimation(view: self.view, title: nil)
        var parm = [String : Any]()
        parm.updateValue(sp_getString(string: SPAPPManager.instance().memberModel?.shop_name), forKey: "shopname")
        parm.updateValue(sp_getString(string: SPAPPManager.instance().memberModel?.bulletin), forKey: "bulletin")
        parm.updateValue(sp_getString(string: self.selectSex), forKey: "sex")
        parm.updateValue(sp_getString(string: SPAPPManager.instance().memberModel?.area), forKey: "area")
        parm.updateValue(sp_getString(string: SPAPPManager.instance().memberModel?.phone), forKey: "phone")
        
        self.requestModel.parm = parm
        SPAppRequest.sp_getUpdateInfo(requestModel: self.requestModel) { [weak self](code, msg, errorModel) in
            self?.sp_dealSexRequest(code: code, msg: msg, errorModel: errorModel)
        }
    }
    fileprivate func sp_dealSexRequest(code : String,msg: String,errorModel : SPRequestError?){
        sp_hideAnimation(view: self.view)
        if code == SP_Request_Code_Success {
            sp_showTextAlert(tips: sp_getString(string: msg).count > 0 ? sp_getString(string: msg) : "修改成功")
            sp_dealSex()
            if let model = SPAPPManager.instance().memberModel {
                model.sex = sp_getString(string: selectSex)
                SPAPPManager.instance().memberModel = model
                
            }
        }else{
            sp_showTextAlert(tips: sp_getString(string: msg).count > 0 ? sp_getString(string: msg) : "修改失败")
        }
    }
    
}
