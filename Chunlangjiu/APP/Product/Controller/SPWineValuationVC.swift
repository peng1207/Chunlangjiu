//
//  SPWineValuationVC.swift
//  Chunlangjiu
//
//  Created by 黄树鹏 on 2018/7/22.
//  Copyright © 2018年 Chunlang. All rights reserved.
//
// 酒估价
import Foundation
import SnapKit
class SPWineValuationVC: SPBaseVC {
    fileprivate lazy var scrollView : UIScrollView = UIScrollView()
    fileprivate lazy var baseView : SPWineValuationView = {
        let view = SPWineValuationView()
        return view
    }()
//    fileprivate lazy var showImageView : SPProductAddImgContentView = {
//        let view = SPProductAddImgContentView()
////        view.clickAddComplete = { [weak self](addView) in
////            self?.sp_clickAddView(addView: addView)
////        }
//
//        return view
//    }()
    fileprivate lazy var addImgView : SPProductAddImgView = {
        let view = SPProductAddImgView()
        view.clickAddBlock = { [weak self] (addView) in
            self?.sp_clickAddView(addView: addView)
        }
        return view
    }()
    fileprivate lazy var submitBtn : UIButton = {
        let btn = UIButton(type: UIButtonType.custom)
        btn.setTitle("提交", for: UIControlState.normal)
        btn.setTitleColor(UIColor.white, for: UIControlState.normal)
        btn.titleLabel?.font = sp_getFontSize(size: 18)
        btn.backgroundColor = SPColorForHexString(hex: SP_HexColor.color_b31f3f.rawValue)
        btn.addTarget(self, action: #selector(sp_clickSubmitAction), for: UIControlEvents.touchUpInside)
        return btn
    }()
     fileprivate var tempAddView : SPAddImageView?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "估价"
        self.sp_setupUI()
        self.sp_addNotification()
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
        self.scrollView.addSubview(self.baseView)
        self.scrollView.addSubview(self.addImgView)
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
            maker.height.equalTo(48)
            if #available(iOS 11.0, *) {
                maker.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(0)
            } else {
                maker.bottom.equalTo(self.view.snp.bottom).offset(0)
            }
        }
        self.baseView.snp.makeConstraints { (maker) in
            maker.left.right.top.equalTo(self.scrollView).offset(0)
            maker.height.greaterThanOrEqualTo(0)
            maker.centerX.equalTo(self.scrollView.snp.centerX).offset(0)
        }
        self.addImgView.snp.makeConstraints { (maker) in
            maker.left.right.equalTo(self.scrollView).offset(0)
            maker.height.greaterThanOrEqualTo(0)
            maker.top.equalTo(self.baseView.snp.bottom).offset(10)
            
            maker.bottom.equalTo(self.scrollView.snp.bottom).offset(-20)
        }
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
//MARK: - action
extension SPWineValuationVC {
    @objc fileprivate func sp_clickSubmitAction() {

        guard sp_getString(string: self.baseView.titleView.textFiled.text).count > 0  else {
            sp_showTextAlert(tips: "请输入商品标题")
            return
        }
        guard sp_getString(string: self.baseView.placeView.textFiled.text).count > 0 else {
            sp_showTextAlert(tips: "请输入品牌产地")
            return
        }
        guard sp_getString(string: self.baseView.seriesView.textFiled.text).count > 0  else {
            sp_showTextAlert(tips: "请输入所属系列")
            return
        }
//        let imageArray = self.addImgView.sp_getImgs()
         let imageArray = self.addImgView.sp_getSelect()
        if sp_getArrayCount(array: imageArray) >= 5  {
            var imgList = [UIImage]()
            for value in imageArray {
                if value is UIImage{
                    imgList.append(value as! UIImage)
                }
            }
            
            sp_send(uploadImg: imgList)
        }else{
            sp_showTextAlert(tips: "请添加商品图片,至少5张")
        }
    }
    ///  点击添加图片事件
    ///
    /// - Parameter addView: 添加对象view
    fileprivate func sp_clickAddView(addView : SPAddImageView){
        tempAddView = addView
        //        sp_showSelectImage(viewController: self, delegate: self)
        sp_thrSelectImg(viewController: self, nav: self.navigationController) { [weak self](img) in
            if let view = self?.tempAddView {
//                self?.showImageView.sp_update(image: img, addImageView: view)
                 self?.addImgView.sp_update(view: view, img: img)
            }
        }
    }
    
}
extension SPWineValuationVC : UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let image = info[ UIImagePickerControllerEditedImage] as? UIImage
        if let view = self.tempAddView {
//            self.showImageView.sp_update(image: image, addImageView: view)
              self.addImgView.sp_update(view: view, img: image)
        }
        picker.dismiss(animated: true, completion: nil)
    }
}
extension SPWineValuationVC {
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
// MARK: - request
extension SPWineValuationVC {
    fileprivate func sp_send(uploadImg:[UIImage]){
        sp_showAnimation(view: nil, title: nil)
        SPOrderHandle.sp_uploadImage(imageType: "rate", imageArray: uploadImg) { [weak self](isSuccess, imagePaths) in
            if isSuccess {
                self?.sp_send(imagePaths: imagePaths)
            }else{
                sp_hideAnimation(view: nil)
                sp_showTextAlert(tips: "上传图片失败")
            }
        }
    }
    fileprivate func sp_send(imagePaths:[String]?){
        var parm = [String : Any]()
        parm.updateValue(sp_getString(string: self.baseView.titleView.textFiled.text), forKey: "title")
        parm.updateValue(sp_getString(string: self.baseView.placeView.textFiled.text), forKey: "name")
        parm.updateValue(sp_getString(string: self.baseView.seriesView.textFiled.text), forKey: "series")
        if sp_isArray(array: imagePaths) {
            parm.updateValue( sp_getString(string: imagePaths?.joined(separator: ",")), forKey: "img")
        }
        self.requestModel.parm = parm
        SPAppRequest.sp_getValuation(requestModel: self.requestModel) { [weak self](code , msg, errorModel) in
            sp_hideAnimation(view: nil)
            if code == SP_Request_Code_Success {
                        let successVC = SPWineValuationSuccessVC()
                        self?.navigationController?.pushViewController(successVC, animated: true)
            }else{
                sp_showTextAlert(tips: msg)
            }
        }
    }
}
