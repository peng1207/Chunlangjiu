//
//  SPAppraisalEditInfoVC.swift
//  Chunlangjiu
//
//  Created by 黄树鹏 on 2019/4/13.
//  Copyright © 2019 Chunlang. All rights reserved.
//
// 鉴定师编辑

import Foundation
import SnapKit
class SPAppraisalEditInfoVC: SPBaseVC {
    fileprivate lazy var scrollView : UIScrollView = {
        let view = UIScrollView()
        return view
    }()
    fileprivate lazy var headerView : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        return view
    }()
    fileprivate lazy var iconImgView : UIImageView = {
        let view = UIImageView()
        view.sp_cornerRadius(cornerRadius: 36)
        view.image = sp_getDefaultImg()
        return view
    }()
    fileprivate lazy var changeBtn : UIButton = {
        let btn = UIButton(type: UIButtonType.custom)
        btn.setTitle("更换头像", for: UIControlState.normal)
        btn.setTitleColor(SPColorForHexString(hex: SP_HexColor.color_b31f3f.rawValue), for: UIControlState.normal)
      
        btn.titleLabel?.font = sp_getFontSize(size: 15)
        btn.addTarget(self, action: #selector(sp_clickChange), for: UIControlEvents.touchUpInside)
        return btn
    }()
    fileprivate lazy var lineView : UIView = {
        return sp_getLineView()
    }()
    fileprivate lazy var nameView : SPAddressEditView = {
        let view = SPAddressEditView()
        view.backgroundColor = SPColorForHexString(hex: SP_HexColor.color_ffffff.rawValue)
        view.titleLabel.text = "我的名称"
        view.textFiled.attributedPlaceholder = NSAttributedString(string: "输入昵称", attributes: [NSAttributedStringKey.foregroundColor : SPColorForHexString(hex: SP_HexColor.color_999999.rawValue),NSAttributedStringKey.font : sp_getFontSize(size: 15)])
        view.textFiled.font = sp_getFontSize(size: 15)
        view.textFiled.textColor = SPColorForHexString(hex: SP_HexColor.color_333333.rawValue)
       
        return view
    }()
    fileprivate lazy var rangView : SPAddressFlexView = {
        let view = SPAddressFlexView()
        view.backgroundColor = SPColorForHexString(hex: SP_HexColor.color_ffffff.rawValue)
        view.textView.minHeight = 44
        view.titleLabel.text = "鉴定范围"
        view.textView.placeholderLabel.text = "例：鉴定茅台、五粮液、泸州老家等中国十大白酒特供品。"
        view.textView.placeholderLabel.font = sp_getFontSize(size: 15)
         view.textView.textView.isScrollEnabled = false
        return view
    }()
    fileprivate lazy var requireView : SPAddressFlexView = {
        let view = SPAddressFlexView()
        view.backgroundColor = SPColorForHexString(hex: SP_HexColor.color_ffffff.rawValue)
        view.textView.minHeight = 55
        view.titleLabel.text = "鉴定要求"
        view.textView.placeholderLabel.text = "例：拍摄物品图清晰、商品标签完整，标签正反面拍摄，地方老酒注意拍摄物品的特点等。"
        view.textView.placeholderLabel.font = sp_getFontSize(size: 15)
        view.textView.textView.isScrollEnabled = false
        return view
    }()
    fileprivate lazy var tipsView : SPAddressFlexView = {
        let view = SPAddressFlexView()
        view.backgroundColor = SPColorForHexString(hex: SP_HexColor.color_ffffff.rawValue)
        view.textView.minHeight = 44
        view.titleLabel.text = "注意事项"
        view.textView.placeholderLabel.text = "例：按要求补图，请勿私自鉴定，拼揍图片不鉴定。      "
        view.textView.placeholderLabel.font = sp_getFontSize(size: 15)
        view.textView.textView.isScrollEnabled = false
        return view
    }()
    fileprivate lazy var canceBtn : UIButton = {
        let btn = UIButton(type: UIButtonType.custom)
        btn.setTitle("取消", for: UIControlState.normal)
        btn.setTitleColor(SPColorForHexString(hex: SP_HexColor.color_ffffff.rawValue), for: UIControlState.normal)
         btn.frame = CGRect(x: 0, y: 0, width: 40, height: 30)
        btn.titleLabel?.font = sp_getFontSize(size: 15)
        btn.addTarget(self, action: #selector(sp_clickBackAction), for: UIControlEvents.touchUpInside)
        return btn
    }()
    fileprivate lazy var doneBtn : UIButton = {
        let btn = UIButton(type: UIButtonType.custom)
        btn.setTitle("完成", for: UIControlState.normal)
        btn.setTitleColor(SPColorForHexString(hex: SP_HexColor.color_ffffff.rawValue), for: UIControlState.normal)
        btn.frame = CGRect(x: 0, y: 0, width: 40, height: 30)
        btn.titleLabel?.font = sp_getFontSize(size: 15)
        btn.addTarget(self, action: #selector(sp_clickDone), for: UIControlEvents.touchUpInside)
        return btn
    }()
    fileprivate var headerUrl : String?
    fileprivate var selectImg : UIImage?
    var infoModel : SPAppraisalInfoModel?
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
        self.iconImgView.sp_cache(string: sp_getString(string: self.infoModel?.authenticate_img), plImage: sp_getLogoImg())
        self.headerUrl = sp_getString(string: self.infoModel?.authenticate_img)
        sp_asyncAfter(time: 0.3) {
            self.nameView.textFiled.text = sp_getString(string: self.infoModel?.authenticate_name)
            self.rangView.textView.content = sp_getString(string: self.infoModel?.authenticate_scope)
            self.requireView.textView.content = sp_getString(string: self.infoModel?.authenticate_require)
            self.tipsView.textView.content = sp_getString(string: self.infoModel?.authenticate_content)
        }
    }
    /// 创建UI
    override func sp_setupUI() {
        self.navigationItem.title = "编辑资料"
        self.view.addSubview(self.scrollView)
        self.scrollView.addSubview(self.headerView)
        self.headerView.addSubview(self.iconImgView)
        self.headerView.addSubview(self.changeBtn)
        self.headerView.addSubview(self.lineView)
        self.scrollView.addSubview(self.nameView)
        self.scrollView.addSubview(self.rangView)
        self.scrollView.addSubview(self.requireView)
        self.scrollView.addSubview(self.tipsView)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: self.canceBtn)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: self.doneBtn)
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
        self.headerView.snp.makeConstraints { (maker) in
            maker.width.equalTo(self.scrollView).offset(0)
            maker.left.equalTo(self.scrollView.snp.left).offset(0)
            maker.right.equalTo(self.scrollView).offset(0)
            maker.centerX.equalTo(self.scrollView.snp.centerX).offset(0)
            maker.top.equalTo(self.scrollView).offset(0)
            maker.height.equalTo(160)
        }
        self.iconImgView.snp.makeConstraints { (maker) in
            maker.width.height.equalTo(72)
            maker.top.equalTo(self.headerView).offset(30)
            maker.centerX.equalTo(self.headerView).offset(0)
        }
        self.lineView.snp.makeConstraints { (maker) in
            maker.left.right.bottom.equalTo(self.headerView).offset(0)
            maker.height.equalTo(sp_lineHeight)
        }
        self.changeBtn.snp.makeConstraints { (maker) in
            maker.width.greaterThanOrEqualTo(0)
            maker.centerX.equalTo(self.headerView).offset(0)
            maker.height.greaterThanOrEqualTo(0)
            maker.top.equalTo(self.iconImgView.snp.bottom).offset(15)
        }
        self.nameView.snp.makeConstraints { (maker) in
            maker.left.right.equalTo(self.scrollView).offset(0)
            maker.height.equalTo(40)
            maker.top.equalTo(self.headerView.snp.bottom).offset(0)
        }
        self.rangView.snp.makeConstraints { (maker) in
            maker.left.right.equalTo(self.nameView).offset(0)
            maker.height.greaterThanOrEqualTo(60)
            maker.top.equalTo(self.nameView.snp.bottom).offset(0)
        }
        self.requireView.snp.makeConstraints { (maker) in
            maker.left.right.equalTo(self.rangView).offset(0)
            maker.height.greaterThanOrEqualTo(65)
            maker.top.equalTo(self.rangView.snp.bottom).offset(0)
        }
        self.tipsView.snp.makeConstraints { (maker) in
            maker.left.right.equalTo(self.requireView).offset(0)
            maker.height.greaterThanOrEqualTo(60)
            maker.top.equalTo(self.requireView.snp.bottom).offset(0)
            maker.bottom.equalTo(self.scrollView).offset(-30)
            maker.centerX.equalTo(self.scrollView.snp.centerX).offset(0)
        }
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
extension SPAppraisalEditInfoVC{
    
    @objc fileprivate func sp_clickDone(){
        guard sp_getString(string: self.nameView.textFiled.text).count > 0  else {
            sp_showTextAlert(tips: "请输入昵称")
            return
        }
//        guard sp_getString(string: self.rangView.textView.textView.text).count > 0  else {
//            sp_showTextAlert(tips: "请输入鉴定范围")
//            return
//        }
//        guard sp_getString(string: self.requireView.textView.textView.text).count > 0 else {
//            sp_showTextAlert(tips: "请输入鉴定要求")
//            return
//        }
//        guard sp_getString(string: self.tipsView.textView.textView.text).count > 0  else {
//            sp_showTextAlert(tips: "请输入注意事项")
//            return
//        }
        if self.selectImg != nil , sp_getString(string: self.headerUrl).count <= 0 {
            sp_uploadImg()
        }else{
            sp_showAnimation(view: self.view, title: nil)
            sp_sendRequest()
        }
        
    }
    
    @objc fileprivate func sp_clickChange(){
        sp_thrSelectImg(viewController: self, nav: self.navigationController) { [weak self](img) in
//            self?.sp_uploadImage(image: img)
            self?.iconImgView.image = img
            self?.headerUrl = ""
            self?.selectImg = img
        }
    }
    
}
extension SPAppraisalEditInfoVC {
    
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
extension SPAppraisalEditInfoVC {
    
    fileprivate func sp_uploadImg(){
        guard let uImage = self.selectImg else {
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
        sp_showAnimation(view: self.view, title: nil)
        SPAppRequest.sp_getUserUploadImg(requestModel: imageRequestModel) { [weak self](code, msg, uploadImageModel, errorModel) in
            if code == SP_Request_Code_Success, let upload = uploadImageModel{
                self?.headerUrl = sp_getString(string: upload.url)
                self?.sp_sendRequest()
            }else{
                sp_showTextAlert(tips: msg)
                sp_hideAnimation(view: self?.view)
            }
        }
    }
    fileprivate func sp_sendRequest(){
        var parm = [String : Any]()
        parm.updateValue(sp_getString(string: self.nameView.textFiled.text), forKey: "name")
        parm.updateValue(sp_getString(string: self.rangView.textView.textView.text), forKey: "scope")
        parm.updateValue(sp_getString(string: self.requireView.textView.textView.text), forKey: "require")
        parm.updateValue(sp_getString(string: self.tipsView.textView.textView.text), forKey: "content")
        parm.updateValue(sp_getString(string: self.headerUrl), forKey: "img")
        self.requestModel.parm = parm
        
        SPAppraisalRequest.sp_getEditAppraisalInfo(requestModel: self.requestModel) { [weak self](code, msg, errorModel) in
            sp_hideAnimation(view: self?.view)
            if code == SP_Request_Code_Success{
                sp_showTextAlert(tips: msg.count > 0 ? msg : "提交成功")
                sp_asyncAfter(time: 0.8, complete: {
                    self?.navigationController?.popViewController(animated: true)
                })
            }else{
                sp_showTextAlert(tips: msg.count > 0 ? msg : "请重试")
            }
        }
    }
    
}
