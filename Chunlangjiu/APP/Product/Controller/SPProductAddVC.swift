//
//  SPProductAddVC.swift
//  Chunlangjiu
//
//  Created by 黄树鹏 on 2018/7/21.
//  Copyright © 2018年 Chunlang. All rights reserved.
//

import Foundation
import SnapKit
class SPProductAddVC: SPBaseVC ,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    fileprivate lazy var scrollView : UIScrollView =  UIScrollView()
    fileprivate lazy var baseView : SPProductBaseView = {
        let view =  SPProductBaseView()
        view.backgroundColor = UIColor.white
        
        view.pSortView.selectBlock = {[weak self]() in
            self?.sp_clickSortAction()
        }
        view.brandView.selectBlock = {[weak self]() in
            self?.sp_clickBrandAction()
        }
        view.placeView.selectBlock = { [weak self]() in
            self?.sp_clickPlace()
        }
        view.typeView.selectBlock = { [weak self]() in
            self?.sp_clickType()
        }
//        view.alcoholDegreeView.selectBlock = {  [weak self]() in
//            self?.sp_clickAlcohol()
//        }
        return view
    }()
    fileprivate lazy var priceView : SPProductPriceView = {
        let view = SPProductPriceView()
        view.backgroundColor = UIColor.white
        return view
    }()
//    fileprivate lazy var showImageView : SPProductAddImgContentView = {
//        let view = SPProductAddImgContentView()
//        view.clickAddComplete = { [weak self](addView) in
//            self?.sp_clickAddView(addView: addView)
//        }
//        return view
//    }()
    fileprivate lazy var addImgView : SPProductAddImgView = {
        let view = SPProductAddImgView()
        view.clickAddBlock = { [weak self] (addView) in
            self?.sp_clickAddView(addView: addView)
        }
        return view
    }()
   fileprivate lazy var titleView : SPAddressEditView = {
        let view = SPAddressEditView()
        view.titleLabel.text = "商品标题"
        view.textFiled.placeholder = "请填写"
        view.backgroundColor = SPColorForHexString(hex: SP_HexColor.color_ffffff.rawValue)
        return view
    }()
   fileprivate lazy var labelView : SPAddressEditView = {
        let view = SPAddressEditView()
        view.titleLabel.text = "商品标签"
        view.textFiled.placeholder = "例：产地，品牌，年份"
        view.lineView.isHidden = true
        view.backgroundColor = SPColorForHexString(hex: SP_HexColor.color_ffffff.rawValue)
        return view
    }()
    
    fileprivate lazy var explainView : SPProductExplainView = {
        let view = SPProductExplainView()
        view.backgroundColor = UIColor.white
        return view
    }()
    fileprivate lazy var parmView : SPProductParmView = {
        let view = SPProductParmView()
        view.backgroundColor = UIColor.white
        return view
    }()
    fileprivate lazy var saveBtn : UIButton = {
        let btn = UIButton(type: UIButtonType.custom)
        btn.setTitle("保存并提交审核", for: UIControlState.normal)
        btn.setTitleColor(UIColor.white, for: UIControlState.normal)
        btn.titleLabel?.font = sp_getFontSize(size: 15)
        btn.backgroundColor = SPColorForHexString(hex: SP_HexColor.color_b31f3f.rawValue)
        btn.addTarget(self, action: #selector(sp_clickSaveAction), for: UIControlEvents.touchUpInside)
        return btn
    }()
    fileprivate lazy var sortView : SPShowSortView = {
        let view = SPShowSortView()
        view.isHidden = true
        
        view.selectBlock = { [weak self](model)in
            self?.sp_dealSortComplete(lv3Model: model)
        }
        return view
    }()
    fileprivate lazy var brandView : SPShopBrandView = {
        let view = SPShopBrandView()
        view.selectBlock = { [weak self](model) in
            self?.sp_dealSelectBrand(model: model)
        }
        view.isHidden = true
        return view
    }()
    fileprivate lazy var typeView : SPShopTypeView = {
        let view = SPShopTypeView()
        view.selectBlock = { [weak self](model)in
            self?.sp_dealType(model: model)
        }
        view.isHidden = true
        return view
    }()
    fileprivate lazy var placeView : SPShopPlaceView = {
        let view = SPShopPlaceView()
        view.selectBlock = { [weak self](model)in
            self?.sp_dealPlace(model: model)
        }
        view.isHidden = true
        return view
    }()
    fileprivate lazy var alcoholView : SPShopAlcoholView = {
        let view = SPShopAlcoholView()
        view.selectBlock = { [weak self](model)in
            self?.sp_dealAlcohol(model: model)
        }
        view.isHidden = true
        return view
    }()
    fileprivate var productModel : SPProductModel?
    fileprivate var lv3Model : SPSortLv3Model?
    fileprivate var brandModel : SPBrandModel?
    fileprivate var placeModel : SPPlaceModel?
    fileprivate var typeModel : SPTypeModel?
    fileprivate var alcoholModel : SPAlcoholDegree?
    fileprivate var sortArray : [SPSortLv3Model]?
    fileprivate var tempAddView : SPAddImageView?
    fileprivate var selectSort : SPSortRootModel?
    fileprivate var brandArray : [SPBrandModel]?
    fileprivate var shopCategoryArray : [SPShopCategory]?
    fileprivate var placeArray : [SPPlaceModel]?
    fileprivate var typeArray : [SPTypeModel]?
    fileprivate var alcoholArray : [SPAlcoholDegree]?
    var item_id : String?
    var edit : Bool! = false
    override func viewDidLoad() {
        super.viewDidLoad()
        self.sp_setupUI()
        self.sp_addNotification()
        if edit {
            sp_sendEdit()
        }else{
             self.sp_sendRequest()
        }
        
       
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
        self.scrollView.addSubview(self.saveBtn)
        self.scrollView.addSubview(self.baseView)
        self.scrollView.addSubview(self.priceView)
//        self.scrollView.addSubview(self.showImageView)
        self.scrollView.addSubview(self.addImgView)
        self.scrollView.addSubview(self.titleView)
        self.scrollView.addSubview(self.labelView)
        self.scrollView.addSubview(self.explainView)
        self.scrollView.addSubview(self.parmView)
        self.view.addSubview(self.brandView)
        self.view.addSubview(self.sortView)
        self.view.addSubview(self.placeView)
        self.view.addSubview(self.typeView)
        self.view.addSubview(self.alcoholView)
        self.sp_addConstraint()
    }
    /// 添加约束
    fileprivate func sp_addConstraint(){
        self.scrollView.snp.makeConstraints { (maker) in
            maker.left.top.right.equalTo(self.view).offset(0)
            if #available(iOS 11.0, *) {
                maker.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(0)
            } else {
                maker.bottom.equalTo(self.view.snp.bottom).offset(0)
            }
        }
//        self.saveBtn.snp.makeConstraints { (maker) in
//            maker.left.right.equalTo(self.view).offset(0)
//            maker.height.equalTo(48)
//            if #available(iOS 11.0, *) {
//                maker.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(0)
//            } else {
//                maker.bottom.equalTo(self.view.snp.bottom).offset(0)
//            }
//        }
        self.baseView.snp.makeConstraints { (maker) in
            maker.left.right.top.equalTo(self.scrollView).offset(0)
            maker.centerX.equalTo(self.scrollView.snp.centerX).offset(0)
            maker.height.greaterThanOrEqualTo(0)
        }
        self.priceView.snp.makeConstraints { (maker) in
            maker.left.right.equalTo(self.scrollView).offset(0)
            maker.top.equalTo(self.labelView.snp.bottom).offset(10)
            maker.height.greaterThanOrEqualTo(0)
        }
        self.addImgView.snp.makeConstraints { (maker) in
            maker.left.right.equalTo(self.scrollView).offset(0)
            maker.height.greaterThanOrEqualTo(0)
            maker.top.equalTo(self.baseView.snp.bottom).offset(10)
        }
        self.titleView.snp.makeConstraints { (maker) in
            maker.left.right.equalTo(self.scrollView).offset(0)
            maker.height.equalTo(40)
            maker.top.equalTo(self.addImgView.snp.bottom).offset(10)
        }
        self.labelView.snp.makeConstraints { (maker) in
            maker.left.right.height.equalTo(self.titleView).offset(0)
            maker.top.equalTo(self.titleView.snp.bottom).offset(0)
        }
        self.explainView.snp.makeConstraints { (maker) in
            maker.left.right.equalTo(self.scrollView).offset(0)
            maker.top.equalTo(self.priceView.snp.bottom).offset(10)
            maker.height.greaterThanOrEqualTo(0)
        }
        self.parmView.snp.makeConstraints { (maker) in
            maker.left.right.equalTo(self.scrollView).offset(0)
            maker.top.equalTo(self.explainView.snp.bottom).offset(10)
            maker.height.greaterThanOrEqualTo(0)
        }
        self.saveBtn.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.scrollView).offset(10)
            maker.right.equalTo(self.scrollView).offset(-10)
            maker.height.equalTo(40)
            maker.top.equalTo(self.parmView.snp.bottom).offset(10)
             maker.bottom.equalTo(self.scrollView.snp.bottom).offset(-10)
        }
        self.sortView.snp.makeConstraints { (maker ) in
            maker.left.right.equalTo(self.view).offset(0)
            maker.top.equalTo(self.baseView.pSortView.snp.bottom).offset(0)
            if #available(iOS 11.0, *) {
                maker.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(0)
            } else {
                // Fallback on earlier versions
                maker.bottom.equalTo(self.view.snp.bottom).offset(0)
            }
        }
        self.brandView.snp.makeConstraints { (maker) in
            maker.left.right.equalTo(self.view).offset(0)
            maker.top.equalTo(self.baseView.brandView.snp.bottom).offset(0)
            if #available(iOS 11.0, *) {
                maker.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(0)
            } else {
                // Fallback on earlier versions
                maker.bottom.equalTo(self.view.snp.bottom).offset(0)
            }
        }
        self.placeView.snp.makeConstraints { (maker ) in
            maker.left.right.equalTo(self.view).offset(0)
            maker.top.equalTo(self.baseView.placeView.snp.bottom).offset(0)
            if #available(iOS 11.0, *) {
                maker.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(0)
            } else {
                // Fallback on earlier versions
                maker.bottom.equalTo(self.view.snp.bottom).offset(0)
            }
        }
        self.typeView.snp.makeConstraints { (maker ) in
            maker.left.right.equalTo(self.view).offset(0)
            maker.top.equalTo(self.baseView.typeView.snp.bottom).offset(0)
            if #available(iOS 11.0, *) {
                maker.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(0)
            } else {
                // Fallback on earlier versions
                maker.bottom.equalTo(self.view.snp.bottom).offset(0)
            }
        }
        self.alcoholView.snp.makeConstraints { (maker ) in
            maker.left.right.equalTo(self.view).offset(0)
//            maker.top.equalTo(self.baseView.alcoholDegreeView.snp.bottom).offset(0)
            if #available(iOS 11.0, *) {
                maker.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(0)
            } else {
                // Fallback on earlier versions
                maker.bottom.equalTo(self.view.snp.bottom).offset(0)
            }
        }
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.sortView.isHidden = true
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
//MARK: - action
extension SPProductAddVC {
    @objc fileprivate func sp_clickSaveAction(){
        guard self.lv3Model != nil else {
            sp_showTextAlert(tips: "请选择分类")
            return
        }
        
        guard sp_getString(string: self.titleView.textFiled.text).count > 0  else {
            sp_showTextAlert(tips: "请输入商品标题")
            return
        }
        guard sp_getString(string: self.priceView.priceView.textFiled.text).count > 0 else {
            sp_showTextAlert(tips: "请输入售价")
            return
        }
        guard self.brandModel != nil else {
            sp_showTextAlert(tips: "请选择品牌")
            return
        }
        //        guard self.placeModel != nil else {
        //            sp_showTextAlert(tips: "请选择产地")
        //            return
        //        }
        //        guard self.typeModel != nil else {
        //            sp_showTextAlert(tips: "请选择类型")
        //            return
        //        }
        //        guard self.alcoholModel != nil else {
        //            sp_showTextAlert(tips: "请选择酒精度")
        //            return
        //        }
        guard sp_getString(string: self.parmView.capacityView.textFiled.text).count > 0  else {
            sp_showTextAlert(tips: "请输入容量")
            return
        }
        guard sp_getString(string: self.parmView.sourceView.textFiled.text).count > 0  else {
            sp_showTextAlert(tips: "请输入商品来源")
            return
        }
        
        
        let imageArray = self.addImgView.sp_getImgs()
        if sp_getArrayCount(array: imageArray) >= 6 {
            sp_getSelectImage(imageArray: imageArray)
        }else{
            sp_showTextAlert(tips: "请添加商品图片,至少6张")
        }
    }
    fileprivate func sp_getSelectImage(imageArray : [UIImage]){
        let group = DispatchGroup() //创建group
        sp_showAnimation(view: self.view, title: nil)
        var i = 0
        var selectImage = [String]()
        if self.edit {
            selectImage = self.addImgView.sp_getImgPath()
        }else{
            for _  in imageArray{
                selectImage.append("")
            }
        }
        for image in imageArray {
            let uploadImage = sp_fixOrientation(aImage: image)
            let data = UIImageJPEGRepresentation(uploadImage, 0.5)
            guard let d = data else{
                continue
            }
            if i < sp_getArrayCount(array: selectImage) {
                if sp_getString(string: selectImage[i]).count > 0 {
                    i = i + 1
                    continue
                }
            }
            group.enter() // 将以下任务添加进group
            let imageRequestModel = SPRequestModel()
            imageRequestModel.data = [d]
            imageRequestModel.name = "image"
            imageRequestModel.fileName = ["proudct.jpg"]
            imageRequestModel.mineType = "image/jpg"
            var parm = [String:Any]()
            parm.updateValue("item", forKey: "image_type")
            parm.updateValue(0, forKey: "image_cat_id")
            parm.updateValue("proudct.jpg", forKey: "image_input_title")
            parm.updateValue("binary", forKey: "upload_type")
            if sp_getString(string: SP_SHOP_ACCESSTOKEN).count > 0 {
                parm.updateValue(SP_SHOP_ACCESSTOKEN, forKey: "accessToken")
            }
            imageRequestModel.parm = parm
            let index = i
            SPAppRequest.sp_getUploadImage(requestModel: imageRequestModel) { (code , msg, uploadImageModel, errorModel) in
                if code == SP_Request_Code_Success, let upload = uploadImageModel{
                    if index < selectImage.count {
                        selectImage[index] = sp_getString(string: upload.url)
                    }
                }
                sp_log(message: index)
                group.leave()
            }
            
            i = i + 1
        }
        group.notify(queue: .main) { [weak self]() in // group中的所有任务完成后再主线程中调用回调函数，将结果传出去
            sp_log(message: "请求数据成功 \(selectImage)")
            var isExist = false
            for string in selectImage {
                if sp_getString(string: string).count <= 0 {
                    isExist = true
                }
            }
            if isExist {
                sp_hideAnimation(view: self?.view)
                sp_showTextAlert(tips: "上传图片失败")
            }else{
                self?.sp_sendAddRequest(imageList: selectImage)
            }
        }
    }
    
    @objc fileprivate func sp_clickSortAction(){
        
        guard sp_getArrayCount(array: self.sortArray) > 0  else {
            sp_showTextAlert(tips: "没有分类")
            return
        }
        if self.sortView.isHidden == false {
            sp_setFilter()
        }else{
            sp_setFilter()
            self.sortView.isHidden = false
        }
    }
    fileprivate func sp_setFilter(){
        self.sortView.isHidden = true
        self.brandView.isHidden = true
        self.placeView.isHidden = true
        self.typeView.isHidden = true
        self.alcoholView.isHidden = true
    }
    ///  点击添加图片事件
    ///
    /// - Parameter addView: 添加对象view
    fileprivate func sp_clickAddView(addView : SPAddImageView){
        tempAddView = addView
        sp_thrSelectImg(viewController: self, nav: self.navigationController) { [weak self](img) in
            if let view = self?.tempAddView {
//                self?.showImageView.sp_update(image: img, addImageView: view)
                self?.addImgView.sp_update(view: view, img: img)
            }
        }
        //        sp_showSelectImage(viewController: self, delegate: self)
    }
    
    fileprivate func sp_dealSortComplete(lv3Model : SPSortLv3Model?){
        var isRemove = true
        if let lv3 = self.lv3Model,let select = lv3Model {
            if lv3.cat_id == select.cat_id {
                isRemove = false
            }
        }
        self.lv3Model = lv3Model
        self.baseView.pSortView.content = sp_getString(string: self.lv3Model?.cat_name)
        if  isRemove {
            sp_dealType(model: nil)
            sp_dealPlace(model: nil)
            sp_dealSelectBrand(model: nil)
            sp_dealAlcohol(model: nil)
            sp_sendSortAfter()
        }
        
        self.sortView.isHidden = true
    }
    /// 点击品牌
    fileprivate func sp_clickBrandAction(){
        if self.lv3Model == nil {
            sp_showTextAlert(tips: "请选择分类")
            return
        }
        if self.brandView.isHidden == false {
            sp_setFilter()
            return
        }
        sp_setFilter()
        UIView.animate(withDuration: 0.3) {
            self.brandView.isHidden = false
        }
        
    }
    fileprivate func sp_clickPlace(){
        if self.lv3Model == nil {
            sp_showTextAlert(tips: "请选择分类")
            return
        }
        if self.placeView.isHidden == false {
            sp_setFilter()
            return
        }
        sp_setFilter()
        UIView.animate(withDuration: 0.3) {
            self.placeView.isHidden = false
        }
    }
    fileprivate func sp_clickType(){
        if self.lv3Model == nil {
            sp_showTextAlert(tips: "请选择分类")
            return
        }
        if self.typeView.isHidden == false {
            sp_setFilter()
            return
        }
        sp_setFilter()
        UIView.animate(withDuration: 0.3) {
            self.typeView.isHidden = false
        }
    }
    fileprivate func sp_clickAlcohol(){
        if self.lv3Model == nil {
            sp_showTextAlert(tips: "请选择分类")
            return
        }
        if  self.alcoholView.isHidden == false {
            sp_setFilter()
            return
        }
        sp_setFilter()
        UIView.animate(withDuration: 0.3) {
            self.alcoholView.isHidden = false
        }
    }
    fileprivate func sp_dealSelectBrand(model:SPBrandModel?){
        self.brandModel = model
        self.baseView.brandView.content = sp_getString(string: self.brandModel?.brand_name)
    }
    fileprivate func sp_dealPlace(model : SPPlaceModel?){
        self.placeModel = model
        self.baseView.placeView.content = sp_getString(string: self.placeModel?.area_name)
    }
    fileprivate func sp_dealType(model : SPTypeModel?){
        self.typeModel = model
        self.baseView.typeView.content = sp_getString(string: self.typeModel?.odor_name)
    }
    fileprivate func sp_dealAlcohol(model: SPAlcoholDegree?){
        self.alcoholModel = model
//        self.baseView.alcoholDegreeView.content = sp_getString(string: self.alcoholModel?.alcohol_name)
    }
    /// 赋值
    fileprivate func sp_setupData(){
        
        self.titleView.textFiled.text = sp_getString(string: self.productModel?.title)
//        self.baseView.subTitleView.textFiled.text = sp_getString(string: self.productModel?.sub_title)
        self.priceView.priceView.textFiled.text = sp_getString(string: self.productModel?.price)
        self.priceView.stockView.textFiled.text = sp_getString(string: self.productModel?.store)
        self.labelView.textFiled.text = sp_getString(string: self.productModel?.label)
        if sp_getArrayCount(array: self.sortArray) > 0  {
            for lv3Model in self.sortArray! {
                if let cat_id = Int(sp_getString(string: self.productModel?.cat_id)),let lv3Id = lv3Model.cat_id{
                    if cat_id == lv3Id {
                        self.lv3Model = lv3Model
                        break
                    }
                }
            }
        }
        if sp_getArrayCount(array: self.placeArray) > 0 {
            for place in self.placeArray! {
                if let area_id = Int(sp_getString(string: self.productModel?.area_id)), let placeId = place.area_id{
                    if area_id == placeId {
                        self.placeModel = place
                        break
                    }
                }
            }
        }
        if sp_getArrayCount(array: self.typeArray) > 0  {
            for place in self.typeArray! {
                if let area_id = Int(sp_getString(string: self.productModel?.odor_id)), let placeId = place.odor_id{
                    if area_id == placeId {
                        self.typeModel = place
                        break
                    }
                }
            }
        }
        if  sp_getArrayCount(array: self.brandArray) > 0  {
            for place in self.brandArray! {
                if let area_id = Int(sp_getString(string: self.productModel?.brand_id)), let placeId = place.brand_id{
                    if area_id == placeId {
                        self.brandModel = place
                        break
                    }
                }
            }
        }
        if sp_getArrayCount(array: self.alcoholArray) > 0  {
            for place in self.alcoholArray! {
                if let area_id = Int(sp_getString(string: self.productModel?.alcohol_id)), let placeId = place.alcohol_id{
                    if area_id == placeId {
                        self.alcoholModel = place
                        break
                    }
                }
            }
        }
        self.baseView.pSortView.content = sp_getString(string: self.lv3Model?.cat_name)
        self.baseView.brandView.content = sp_getString(string: self.brandModel?.brand_name)
        self.baseView.placeView.content = sp_getString(string: self.placeModel?.area_name)
        self.baseView.typeView.content = sp_getString(string: self.typeModel?.odor_name)
//        self.baseView.alcoholDegreeView.content = sp_getString(string: self.alcoholModel?.alcohol_name)
        self.addImgView.sp_setimg(paths: self.productModel?.images)
    
        self.explainView.textView.content = sp_getString(string: self.productModel?.explain)
        if let parmArray : [Any] = sp_stringValueArr(sp_getString(string: self.productModel?.parameter)){
            var index = 0
            for parmDic in parmArray {
                if let dic : [String :Any] = parmDic as? [String : Any]{
                    let title = sp_getString(string: dic["title"])
                    if title == "类型" || title == "产地" || title == "酒精度"{
                        continue
                    }
                    let value = sp_getString(string: dic["value"])
                    if index == 0 {
                        self.parmView.capacityView.textFiled.text = sp_getString(string: value)
                    }else if index == 1 {
                        self.parmView.wineryView.textFiled.text = sp_getString(string: value)
                    }else if index == 2 {
                        self.parmView.seriesView.textFiled.text = sp_getString(string: value)
                    }else if index == 3 {
                        self.parmView.packView.textFiled.text = sp_getString(string: value)
                    }else if index == 4 {
                        self.parmView.yearView.textFiled.text = sp_getString(string: value)
                    }else if index == 5 {
                        self.parmView.materialView.textFiled.text = sp_getString(string: value)
                    }else if index == 6 {
                        self.parmView.storageView.textFiled.text = sp_getString(string: value)
                    }else if index == 7 {
                        self.parmView.enclosureView.textFiled.text = sp_getString(string: value)
                    }else if index == 8 {
                        self.parmView.sourceView.textFiled.text = sp_getString(string: value)
                    }
                }
                index = index + 1
            }
        }
        
        
    }
    
}
extension SPProductAddVC{
    fileprivate func sp_sendRequest(complete:SPBtnClickBlock? = nil){
        let sortRequest = SPRequestModel()
        var parm = [String:Any]()
        if sp_getString(string: SP_SHOP_ACCESSTOKEN).count > 0   {
            parm.updateValue(SP_SHOP_ACCESSTOKEN, forKey: "accessToken")
        }
        sortRequest.parm = parm
        
        SPProductRequest.sp_getPlatformCategory(requestModel: sortRequest) { [weak self](code, list, errorModel, total) in
            self?.sp_dealRequest(code: code, list: list, errorModel: errorModel)
            if let block = complete{
                block()
            }
        }
    }
    fileprivate func sp_dealRequest(code:String,list:[Any]?,errorModel:SPRequestError?) {
        if sp_getArrayCount(array: list) > 0  {
            self.sortArray = list as? Array<SPSortLv3Model>
            self.sortView.dataArray = self.sortArray
        }
    }
    fileprivate func sp_sendAddRequest(imageList : [String]?){
        
        var parm = [String:Any]()
        if sp_getString(string: SP_SHOP_ACCESSTOKEN).count > 0   {
            parm.updateValue(SP_SHOP_ACCESSTOKEN, forKey: "accessToken")
        }
        if edit, let item_id = self.productModel?.item_id{
            parm.updateValue(item_id, forKey: "item_id")
        }
        
        parm.updateValue(self.selectSort?.cat_id ?? 0, forKey: "cat_id")
        parm.updateValue(sp_getString(string: self.titleView.textFiled.text), forKey: "title")
//        parm.updateValue(sp_getString(string: self.baseView.subTitleView.textFiled.text), forKey: "sub_title")
        //        let label = self.baseView.labelView.textFiled.text
        parm.updateValue(sp_getString(string: self.priceView.priceView.textFiled.text), forKey: "price")
        parm.updateValue(sp_getString(string: self.priceView.stockView.textFiled.text), forKey: "store")
        parm.updateValue(sp_getString(string: self.parmView.capacityView.textFiled.text), forKey: "weight")
        parm.updateValue(sp_getString(string: "瓶"), forKey: "unit")
        if self.lv3Model != nil {
            parm.updateValue(self.lv3Model?.cat_id ?? 0, forKey: "cat_id")
        }
        if let brandID = self.brandModel?.brand_id {
            parm.updateValue(brandID, forKey: "brand_id")
        }
        if let area_id = self.placeModel?.area_id {
            parm.updateValue(area_id, forKey: "area_id")
        }
        if let odor_id = self.typeModel?.odor_id {
            parm.updateValue(odor_id, forKey: "odor_id")
        }
        if let alcohol_id = self.alcoholModel?.alcohol_id {
            parm.updateValue(alcohol_id, forKey: "alcohol_id")
        }
        
        //        parm.updateValue(self.shopNextCategory?.cat_id ?? 0, forKey: "shop_cat_id")
        parm.updateValue(sp_getString(string: self.labelView.textFiled.text), forKey: "label")
        parm.updateValue(sp_getString(string: self.explainView.textView.textView.text), forKey: "explain")
        var list = [[String : Any]]()
        //        list.append(["title":"类型","value":sp_getString(string: self.parmView.typeView.textFiled.text)])
        list.append(["title":"容量","value":sp_getString(string: self.parmView.capacityView.textFiled.text)])
        list.append(["title":"酒庄","value":sp_getString(string: self.parmView.wineryView.textFiled.text)])
        list.append(["title":"系列","value":sp_getString(string: self.parmView.seriesView.textFiled.text)])
        list.append(["title":"包装","value":sp_getString(string: self.parmView.packView.textFiled.text)])
        list.append(["title":"年份","value":sp_getString(string: self.parmView.yearView.textFiled.text)])
        list.append(["title":"原料","value":sp_getString(string: self.parmView.materialView.textFiled.text)])
        list.append(["title":"储存条件","value":sp_getString(string: self.parmView.storageView.textFiled.text)])
        list.append(["title":"附件","value":sp_getString(string: self.parmView.enclosureView.textFiled.text)])
         list.append(["title":"商品来源","value":sp_getString(string: self.parmView.sourceView.textFiled.text)])
        //        list.append(["title":"酒精度","value":sp_getString(string: self.parmView.degreesView.textFiled.text)])
        //        list.append(["title":"产地","value":sp_getString(string: self.parmView.placeView.textFiled.text)])
        parm.updateValue(sp_getString(string: sp_arrayValueString(list)), forKey: "parameter")
        
        if sp_isArray(array: imageList) {
            parm.updateValue( sp_getString(string: imageList?.joined(separator: ",")), forKey: "list_image")
        }
        parm.updateValue("0", forKey: "use_platform")
        parm.updateValue(1, forKey: "nospec")
        //        parm.updateValue(15, forKey: "dlytmpl_id")
        self.requestModel.parm = parm
//        if self.edit {
//            SPProductRequest.sp_getShopEditProduct(requestModel: self.requestModel) {  [weak self](code, msg, errorModel) in
//                sp_hideAnimation(view: self?.view)
//                if code == SP_Request_Code_Success{
//                    let sucessVC = SPProductAddSuccessVC()
//                    self?.navigationController?.pushViewController(sucessVC, animated: true)
//                }else{
//                    sp_showTextAlert(tips: msg)
//                }
//            }
//        }else{
            SPAppRequest.sp_getShopAddProduct(requestModel: self.requestModel) { [weak self](code, msg, errorModel) in
                sp_hideAnimation(view: self?.view)
                if code == SP_Request_Code_Success{
                    let sucessVC = SPProductAddSuccessVC()
                    self?.navigationController?.pushViewController(sucessVC, animated: true)
                }else{
                    sp_showTextAlert(tips: msg)
                }
            }
//        }
        
     
    }
    fileprivate func sp_sendSortAfter(){
        sp_sendBrandRequest()
        sp_sendPlace()
        sp_sendType()
        sp_sendAlcoholDegree()
    }
    fileprivate func sp_sendBrandRequest(complete:SPBtnClickBlock? = nil){
        let request = SPRequestModel()
        
        var parm = [String :Any]()
        if let catid = self.lv3Model?.cat_id {
            parm.updateValue(catid, forKey: "cat_id")
        }
        if sp_getString(string: SP_SHOP_ACCESSTOKEN).count > 0   {
            parm.updateValue(SP_SHOP_ACCESSTOKEN, forKey: "accessToken")
        }
        request.parm = parm
        SPProductRequest.sp_getPlatformBrand(requestModel: request) { [weak self](code , list , errorModel, total) in
            if code == SP_Request_Code_Success{
                self?.brandArray = list  as? [SPBrandModel]
                self?.brandView.dataArray =  self?.brandArray
            }
            if let block = complete {
                block()
            }
        }
    }
    fileprivate func sp_sendPlace(complete:SPBtnClickBlock? = nil){
        let request  = SPRequestModel()
        var parm = [String : Any]()
        if let catid = self.lv3Model?.cat_id {
            parm.updateValue(catid, forKey: "cat_id")
        }
        request.parm = parm
        SPProductRequest.sp_getPlatformPlace(requestModel: request) {  [weak self](code , list, errorModel, total) in
            if code == SP_Request_Code_Success {
                self?.placeArray = list as? [SPPlaceModel]
                self?.placeView.dataArray = self?.placeArray
            }
            if let block = complete {
                block()
            }
        }
    }
    fileprivate func sp_sendAlcoholDegree(complete:SPBtnClickBlock? = nil){
        let request = SPRequestModel()
        var parm = [String : Any]()
        if let catid = self.lv3Model?.cat_id {
            parm.updateValue(catid, forKey: "cat_id")
        }
        request.parm = parm
        SPProductRequest.sp_getPlatformAlcohol(requestModel: request) { [weak self] (code, list, errorModel, total) in
            if code  == SP_Request_Code_Success{
                self?.alcoholArray = list as? [SPAlcoholDegree]
                self?.alcoholView.dataArray = self?.alcoholArray
            }
            if let block = complete{
                block()
            }
        }
    }
    fileprivate func sp_sendType(complete:SPBtnClickBlock? = nil){
        let request = SPRequestModel()
        var parm = [String : Any]()
        if let catid = self.lv3Model?.cat_id {
            parm.updateValue(catid, forKey: "cat_id")
        }
        request.parm = parm
        SPProductRequest.sp_getPlatformType(requestModel: request) {  [weak self](code , list , errorModel, total) in
            if code == SP_Request_Code_Success {
                self?.typeArray = list as? [SPTypeModel]
                self?.typeView.dataArray = self?.typeArray
            }
            if let block = complete{
                block()
            }
        }
    }
    fileprivate func sp_sendEdit(){
        let request = SPRequestModel()
        var parm = [String:Any]()
        if let item = Int(sp_getString(string: self.item_id)) {
            parm.updateValue(item, forKey: "item_id")
        }
        request.parm = parm
        sp_showAnimation(view: self.view, title: "加载中")
        SPProductRequest.sp_getProductDet(requestModel: request) { [weak self](code , productModel , errorModel) in
            if code == SP_Request_Code_Success {
                self?.productModel = productModel
                self?.sp_sendAll()
            }
        }
    }
    fileprivate func sp_sendAll(){
        let model = SPSortLv3Model()
        model.cat_id = Int(sp_getString(string: self.productModel?.cat_id))
        self.lv3Model = model
         let group = DispatchGroup() //创建group
        group.enter()
        sp_sendRequest {
            group.leave()
        }
        group.enter()
        sp_sendBrandRequest {
           group.leave()
        }
        group.enter()
        sp_sendType {
            group.leave()
        }
        group.enter()
        sp_sendAlcoholDegree {
            group.leave()
        }
        group.enter()
        sp_sendPlace {
            group.leave()
        }
        group.notify(queue: .main) { [weak self]in
            self?.lv3Model = nil
            self?.sp_setupData()
            sp_hideAnimation(view: self?.view)
        }
    }
    
    
}
// MARK: - deletage
extension SPProductAddVC {
    
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
// MARK: - notification
extension SPProductAddVC {
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

