//
//  SPConditionView.swift
//  Chunlangjiu
//
//  Created by 黄树鹏 on 2018/7/6.
//  Copyright © 2018年 Chunlang. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

enum SPConditionBtnType {
    /// 综合
    case comprehensive
    /// 新品
    case new
    /// 升序
    case price_asc
    /// 降序
    case price_desc
}
typealias SPConditionClickComplete  = (_ type :SPConditionBtnType)-> Void
fileprivate  let btnFontSize : CGFloat = 14.0
class SPConditionView:  UIView{
    
    fileprivate var sortCollectionView : UICollectionView!
    
    fileprivate lazy var lineView : UIView = {
       return sp_getLineView()
    }()
    fileprivate lazy var sortView : SPSortView = {
        let view  = SPSortView()
        view.isHidden = true
        
        return view
    }()
    fileprivate lazy var filterView : SPFilterView = {
        let view = SPFilterView()
        return view
    }()
    var sortArray : [SPSortLv3Model]? {
        didSet{
            self.sortCollectionView.reloadData()
        }
    }
    var selectComplete : SPSortViewSelectComplete?
    var filterComplete : SPFilterBlock?{
        didSet{
            self.filterView.filterBlock = filterComplete
        }
    }
    var filterModel : SPFilterModel?{
        didSet{
            self.filterView.filterModel = filterModel
        }
    }
    fileprivate lazy var sortLineView : UIView = {
        return sp_getLineView()
    }()
    fileprivate lazy var brandBtn : UIButton = {
        let btn = UIButton(type: UIButtonType.custom)
        btn.setTitle("品牌", for: UIControlState.normal)
        btn.setImage(UIImage(named: "public_down"), for: UIControlState.normal)
        btn.titleLabel?.font = sp_getFontSize(size: btnFontSize)
        btn.setTitleColor(SPColorForHexString(hex: SP_HexColor.color_999999.rawValue), for: UIControlState.normal)
        btn.setTitleColor(SPColorForHexString(hex: SP_HexColor.color_333333.rawValue), for: UIControlState.selected)
        btn.addTarget(self, action: #selector(sp_clickDefaultAction), for: UIControlEvents.touchUpInside)
        self.sp_setBtnEdge(btn: btn)
        return btn
    }()
    
    fileprivate lazy var placeBtn : UIButton = {
       let btn = UIButton(type: UIButtonType.custom)
        btn.setTitle("产地", for: UIControlState.normal)
          btn.setImage(UIImage(named: "public_down"), for: UIControlState.normal)
        btn.titleLabel?.font = sp_getFontSize(size: btnFontSize)
        btn.setTitleColor(SPColorForHexString(hex: SP_HexColor.color_999999.rawValue), for: UIControlState.normal)
        btn.addTarget(self, action: #selector(sp_clickNewAction), for: UIControlEvents.touchUpInside)
        btn.setTitleColor(SPColorForHexString(hex: SP_HexColor.color_333333.rawValue), for: UIControlState.selected)
          self.sp_setBtnEdge(btn: btn)
        return btn
    }()
    fileprivate lazy var typeBtn : UIButton = {
        let btn = UIButton(type: UIButtonType.custom)
            let title = "类型"
        btn.setTitle(title, for: UIControlState.normal)
        btn.setImage(UIImage(named: "public_down"), for: UIControlState.normal)
        btn.setTitleColor(SPColorForHexString(hex: SP_HexColor.color_999999.rawValue), for: UIControlState.normal)
        btn.titleLabel?.font = sp_getFontSize(size: btnFontSize)
        btn.addTarget(self, action: #selector(sp_clickPriceAction), for: UIControlEvents.touchUpInside)
        btn.setTitleColor(SPColorForHexString(hex: SP_HexColor.color_333333.rawValue), for: UIControlState.selected)
          self.sp_setBtnEdge(btn: btn)
        return btn;
    }()
    fileprivate lazy var alcoholDegreeBtn : UIButton = {
        let btn = UIButton(type: UIButtonType.custom)
        let title = "酒精度"
        btn.setTitle(title, for: UIControlState.normal)
        btn.setImage(UIImage(named: "public_down"), for: UIControlState.normal)
        btn.setTitleColor(SPColorForHexString(hex: SP_HexColor.color_999999.rawValue), for: UIControlState.normal)
        btn.setTitleColor(SPColorForHexString(hex: SP_HexColor.color_333333.rawValue), for: UIControlState.selected)
        btn.titleLabel?.font = sp_getFontSize(size: btnFontSize)
        btn.addTarget(self, action: #selector(sp_clickSortAction), for: UIControlEvents.touchUpInside)
          self.sp_setBtnEdge(btn: btn)
        return btn;
    }()
    fileprivate lazy var priceBtn : UIButton = {
        let btn = UIButton(type: UIButtonType.custom)
        let title = "价格区间"
        btn.setTitle(title, for: UIControlState.normal)
        btn.setImage(UIImage(named: "public_down"), for: UIControlState.normal)
        btn.setTitleColor(SPColorForHexString(hex: SP_HexColor.color_999999.rawValue), for: UIControlState.normal)
        btn.setTitleColor(SPColorForHexString(hex: SP_HexColor.color_333333.rawValue), for: UIControlState.selected)
        btn.titleLabel?.font = sp_getFontSize(size: btnFontSize)
        btn.addTarget(self, action: #selector(sp_clickFilterAction), for: UIControlEvents.touchUpInside)
          self.sp_setBtnEdge(btn: btn)
        return btn;
    }()
    fileprivate lazy var conditionFilterView : SPConditionFilterView! = {
        let view = SPConditionFilterView()
        view.selectCompete = { [weak self](model) in
            self?.sp_dealFilter(model: model)
        }
        view.hiddenComplete = { [weak self]() in
            self?.sp_setDefaultSelect()
        }
        return view
    }()
    
    var clickBtnBlock : SPConditionClickComplete?
    var defaultBlock : SPBtnClickBlock?
    fileprivate let conditionSortCellID = "conditionSortCellID"
    fileprivate let collectionHeight : CGFloat = 40
    var selectSortModel : SPSortLv3Model?{
        didSet{
            self.sortCollectionView.reloadData()
            self.sp_sendReqest()
        }
    }
  
    var selectBrand : SPBrandModel?{
        didSet{
            if let brandid = selectBrand?.brand_id , brandid > 0 {
              self.brandBtn.setTitle(sp_getString(string: selectBrand?.brand_name).count > 0  ? sp_getString(string: selectBrand?.brand_name) : "品牌", for: UIControlState.normal)
            }else{
                self.brandBtn.setTitle("品牌", for: UIControlState.normal)
            }
            self.sp_setBtnEdge(btn: self.brandBtn)
        }
    }
    var selectPlace : SPPlaceModel?{
        didSet{
            if let placeId = selectPlace?.area_id, placeId > 0   {
                  self.placeBtn.setTitle(sp_getString(string:selectPlace?.area_name).count > 0  ? sp_getString(string: selectPlace?.area_name) : "产地", for: UIControlState.normal)
            }else{
                self.placeBtn.setTitle("产地", for: UIControlState.normal)
            }
            self.sp_setBtnEdge(btn: self.placeBtn)
        }
    }
    var selectType : SPTypeModel?{
        didSet{
            if let typeId = selectType?.odor_id , typeId > 0  {
                self.typeBtn.setTitle(sp_getString(string:selectType?.odor_name).count > 0  ? sp_getString(string: selectType?.odor_name) : "类型", for: UIControlState.normal)
            }else{
                self.typeBtn.setTitle("类型", for: UIControlState.normal)
            }
        self.sp_setBtnEdge(btn: typeBtn)
        }
    }
    var alcoholDegree : SPAlcoholDegree?{
        didSet{
            if let alcoholId = alcoholDegree?.alcohol_id, alcoholId > 0 {
                  self.alcoholDegreeBtn.setTitle(sp_getString(string:alcoholDegree?.alcohol_name).count > 0  ? sp_getString(string: alcoholDegree?.alcohol_name) : "酒精度", for: UIControlState.normal)
            }else{
                self.alcoholDegreeBtn.setTitle("酒精度", for: UIControlState.normal)
            }
           self.sp_setBtnEdge(btn: alcoholDegreeBtn)
        }
    }
    var selectprice : SPPriceRange?{
        didSet{
            if let type = selectprice?.type , type != SPPirceRangeType.all {
                 self.priceBtn.setTitle(sp_getString(string:selectprice?.showPrice).count > 0  ? sp_getString(string: selectprice?.showPrice) : "价格区间", for: UIControlState.normal)
            }else{
                self.priceBtn.setTitle("价格区间", for: UIControlState.normal)
            }
            self.sp_setBtnEdge(btn: self.priceBtn)
        }
    }
    var brandArray : [SPBrandModel]?
    var placeArray : [SPPlaceModel]?
    var typeArray : [SPTypeModel]?
    var alcoholDegreeArray : [SPAlcoholDegree]?
    var priceArray : [SPPriceRange]?
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.sp_setupUI()
//        sp_sendReqest()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    fileprivate func sp_setBtnEdge(btn : UIButton){
        var imageW : CGFloat = 0.0
        if let w = btn.imageView?.image?.size.width {
            imageW = w
        }
        var titleW : CGFloat = 0.00
        if let w = btn.titleLabel?.intrinsicContentSize.width {
            titleW = w
        }
        if titleW + imageW > btn.frame.size.width , btn.frame.size.width > 0 {
            titleW = btn.frame.size.width - imageW - 5
        }
        
        btn.titleEdgeInsets = UIEdgeInsets(top: 0, left: -imageW, bottom: 0, right: imageW)
        btn.imageEdgeInsets = UIEdgeInsets(top: 0, left: titleW  , bottom: 0, right: -titleW)
    }
    /// 添加UI
    fileprivate func sp_setupUI(){
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.estimatedItemSize = CGSize(width: sp_getScreenWidth(), height: collectionHeight)
        self.sortCollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        self.sortCollectionView.delegate = self
        self.sortCollectionView.dataSource = self
        self.sortCollectionView.register(SPConditionSortView.self, forCellWithReuseIdentifier: conditionSortCellID)
        self.sortCollectionView.backgroundColor = UIColor.white
        self.addSubview(self.sortCollectionView)
        self.addSubview(self.sortLineView)
        self.addSubview(self.brandBtn)
        self.addSubview(self.placeBtn)
        self.addSubview(self.typeBtn)
        self.addSubview(self.alcoholDegreeBtn)
        self.addSubview(self.priceBtn)
        self.addSubview(self.lineView)
        self.sp_addConstraint()
        sp_asyncAfter(time: 0.1) {[weak self] in
            if let btn = self?.priceBtn{
                  self?.sp_setBtnEdge(btn: btn)
            }
        }
       
    }
    /// 添加约束
    fileprivate func sp_addConstraint(){
        self.sortCollectionView.snp.makeConstraints { (maker) in
            maker.left.top.right.equalTo(self).offset(0)
            maker.height.equalTo(collectionHeight)
        }
        self.sortLineView.snp.makeConstraints { (maker) in
            maker.left.right.equalTo(self).offset(0)
            maker.top.equalTo(self.sortCollectionView.snp.bottom).offset(0)
            maker.height.equalTo(sp_lineHeight)
        }
        self.brandBtn.snp.makeConstraints { (maker) in
            maker.top.equalTo(self.sortLineView.snp.bottom).offset(0)
            maker.left.equalTo(self).offset(0)
            maker.height.equalTo(40)
            maker.width.equalTo(self.placeBtn.snp.width).offset(0)
        }
        self.placeBtn.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.brandBtn.snp.right).offset(0)
            maker.top.bottom.equalTo(self.brandBtn).offset(0);
            maker.width.equalTo(self.typeBtn.snp.width).offset(0)
        }
        self.typeBtn.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.placeBtn.snp.right).offset(0)
            maker.top.bottom.equalTo(self.placeBtn).offset(0)
            maker.width.equalTo(self.alcoholDegreeBtn.snp.width).offset(0)
        }
        self.alcoholDegreeBtn.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.typeBtn.snp.right).offset(0)
            maker.top.bottom.equalTo(self.typeBtn).offset(0)
            maker.width.equalTo(self.priceBtn.snp.width).offset(0)
        }
        self.priceBtn.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.alcoholDegreeBtn.snp.right).offset(0)
            maker.top.bottom.equalTo(self.alcoholDegreeBtn).offset(0)
            maker.right.equalTo(self.snp.right).offset(0)
        }
        
        self.lineView.snp.makeConstraints { (maker) in
            maker.left.right.equalTo(self).offset(0);
            maker.top.equalTo(self.priceBtn.snp.bottom).offset(0)
            maker.height.equalTo(sp_lineHeight)
            maker.bottom.equalTo(self).offset(0)
        }
    }
    deinit {
        
    }
}
extension SPConditionView {
    @objc fileprivate func sp_clickDefaultAction(){
        sp_setDefaultSelect()
        self.brandBtn.isSelected = true
        sp_show(selectModel: self.selectBrand, list: self.brandArray)
    }
    @objc fileprivate func sp_clickNewAction(){
         sp_setDefaultSelect()
        self.placeBtn.isSelected = true
        sp_show(selectModel: self.selectPlace, list: self.placeArray)
    }
    @objc fileprivate func sp_clickPriceAction(){
          sp_setDefaultSelect()
        self.typeBtn.isSelected = true
        sp_show(selectModel: self.selectType, list: self.typeArray)
    }
    @objc fileprivate func sp_clickSortAction(){
         sp_setDefaultSelect()
        self.alcoholDegreeBtn.isSelected = true
        
        sp_show(selectModel: self.alcoholDegree, list: self.alcoholDegreeArray)
    }
    @objc fileprivate func sp_clickFilterAction(){
        sp_setDefaultSelect()
        self.priceBtn.isSelected = true
        sp_show(selectModel: self.selectprice, list: self.priceArray)
    }
    fileprivate func sp_show(selectModel : Any?,list : [Any]?){
        self.conditionFilterView.dataAraay = list
        self.conditionFilterView.selectModel = selectModel
        self.conditionFilterView.sp_reload()
        if self.conditionFilterView?.superview == nil {
            self.superview?.addSubview(self.conditionFilterView)
            self.conditionFilterView?.snp.makeConstraints({ (maker) in
                maker.left.right.equalTo(self.superview!).offset(0)
                maker.top.equalTo(self.snp.bottom).offset(0)
                if #available(iOS 11.0, *) {
                    maker.bottom.equalTo((self.superview?.safeAreaLayoutGuide.snp.bottom)!).offset(0)
                } else {
                    // Fallback on earlier versions
                    maker.bottom.equalTo((self.superview?.snp.bottom)!).offset(0)
                }
            })
        }
    }
    fileprivate func sp_setDefaultSelect(){
        self.brandBtn.isSelected = false
        self.placeBtn.isSelected = false
        self.typeBtn.isSelected = false
        self.alcoholDegreeBtn.isSelected = false
        self.priceBtn.isSelected = false
    }
    fileprivate func sp_removeSortView(){
        self.sortView.isHidden = true
        self.sortView.removeFromSuperview()
    }
    fileprivate func sp_dealFilter(model : Any?){
        if self.brandBtn.isSelected {
            self.selectBrand = model as? SPBrandModel
            SPThridManager.sp_search(eventId: SP_EventID.searchBrand.rawValue, name: self.selectBrand?.brand_name)
        }else if self.placeBtn.isSelected {
            self.selectPlace = model as? SPPlaceModel
            SPThridManager.sp_search(eventId: SP_EventID.searchPlace.rawValue, name: self.selectPlace?.area_name)
        }else if self.typeBtn.isSelected {
            self.selectType = model as? SPTypeModel
            SPThridManager.sp_search(eventId: SP_EventID.searchType.rawValue, name: self.selectType?.odor_name)
        }else if self.alcoholDegreeBtn.isSelected {
            self.alcoholDegree = model as? SPAlcoholDegree
            SPThridManager.sp_search(eventId: SP_EventID.searchAlcoholDegree.rawValue, name: self.alcoholDegree?.alcohol_name)
        }else if self.priceBtn.isSelected {
            self.selectprice = model as? SPPriceRange
            SPThridManager.sp_search(eventId: SP_EventID.searchPrice.rawValue, name: self.selectprice?.showPrice)
        }
        sp_dealDefaultBlock()
        sp_setDefaultSelect()
        self.conditionFilterView.removeFromSuperview()
    }
    fileprivate func sp_dealDefaultBlock(){
        guard let block = self.defaultBlock else {
            return
        }
        block()
    }
    fileprivate func sp_dealSelect(model :  SPSortLv3Model?){
        self.selectSortModel = model
        guard let block = self.selectComplete else {
            return
        }
        block(nil,nil,model)
        SPThridManager.sp_search(eventId: SP_EventID.searchSort.rawValue, name: model?.cat_name)
//        sp_sendReqest()
    }
    fileprivate func sp_dealComlete(type : SPConditionBtnType){
        guard let block  = self.clickBtnBlock else {
            return
        }
        block(type)
    }
}
extension SPConditionView:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sp_getArrayCount(array: self.sortArray) > 0 ? 1 : 0
     }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sp_getArrayCount(array: self.sortArray)
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell :  SPConditionSortView = collectionView.dequeueReusableCell(withReuseIdentifier: conditionSortCellID, for: indexPath) as! SPConditionSortView
        if  indexPath.row < sp_getArrayCount(array: self.sortArray) {
            let lv3Model = self.sortArray?[indexPath.row]
            cell.titleLabel.text = sp_getString(string: lv3Model?.cat_name)
            if let m = self.selectSortModel?.cat_id,let lv3 = lv3Model?.cat_id {
                if m == lv3{
                    cell.isSelect = true
                }else{
                    cell.isSelect = false
                }
            }else{
                if self.selectSortModel != nil{
                    if self.selectSortModel?.cat_id == nil && lv3Model?.cat_id == nil{
                        cell.isSelect = true
                    }else{
                         cell.isSelect = false
                    }
                }else{
                     cell.isSelect = false
                }
            }
            
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row < sp_getArrayCount(array: self.sortArray) {
            sp_dealSelect(model: self.sortArray?[indexPath.row])
        }
    }
    
}
// MARK: - request
extension SPConditionView {
    func sp_sendReqest(){
        sp_setDefaultSelect()
        self.conditionFilterView.removeFromSuperview()
        self.selectType = nil
        self.selectBrand = nil
        self.selectPlace = nil
        self.alcoholDegree = nil
        sp_sendType()
        sp_sendBrand()
        sp_sendPlace()
        sp_sendAlcohol()
        sp_sendPriceRange()
    }
    fileprivate func sp_sendPlace(){
        let request = SPRequestModel()
        var parm = [String : Any]()
        if let m = self.selectSortModel?.cat_id {
            parm.updateValue(m, forKey: "cat_id")
        }
        request.parm = parm
        SPAppRequest.sp_getPlace(requestModel: request) { [weak self](code, list, errorModel, total) in
            if code == SP_Request_Code_Success{
                self?.placeArray = list as? [SPPlaceModel]
            }
        }
    }
    fileprivate func sp_sendBrand(){
        let request = SPRequestModel()
        var parm = [String : Any]()
        if let m = self.selectSortModel?.cat_id {
            parm.updateValue(m, forKey: "cat_id")
        }
        request.parm = parm
        SPAppRequest.sp_getBrand(requestModel: request) { [weak self](code, list , errorModel, total) in
            if code == SP_Request_Code_Success{
                self?.brandArray = list as? [SPBrandModel]
            }
        }
    }
    fileprivate func sp_sendType(){
        let request = SPRequestModel()
        var parm = [String : Any]()
        if let m = self.selectSortModel?.cat_id {
            parm.updateValue(m, forKey: "cat_id")
        }
        request.parm = parm
        SPAppRequest.sp_getType(requestModel: request) { [weak self](code, list , errorModel, total) in
            if code  == SP_Request_Code_Success{
                self?.typeArray = list as? [SPTypeModel]
            }
        }
    }
    fileprivate func sp_sendAlcohol(){
        let request = SPRequestModel()
        var parm = [String : Any]()
        if let m = self.selectSortModel?.cat_id {
            parm.updateValue(m, forKey: "cat_id")
        }
        request.parm = parm
        SPAppRequest.sp_getAlcohol(requestModel: request) { [weak self](code , list , errorModel, total) in
            if code == SP_Request_Code_Success{
                self?.alcoholDegreeArray = list as? [SPAlcoholDegree]
            }
        }
    }
    fileprivate func sp_sendPriceRange(){
        var list = [SPPriceRange]()
        list.append(SPPriceRange.sp_init(maxPrice: "", minPrice: "",type: SPPirceRangeType.all))
         list.append(SPPriceRange.sp_init(maxPrice: "999", minPrice: nil,type: SPPirceRangeType.range900))
         list.append(SPPriceRange.sp_init(maxPrice: "2999", minPrice: "1000",type: SPPirceRangeType.range2999))
         list.append(SPPriceRange.sp_init(maxPrice: "4999", minPrice: "3000",type: SPPirceRangeType.range4999))
         list.append(SPPriceRange.sp_init(maxPrice: "9999", minPrice: "5000",type: SPPirceRangeType.range9999))
         list.append(SPPriceRange.sp_init(maxPrice: nil, minPrice: "10000",type: SPPirceRangeType.range10000))
        self.priceArray = list
    }
}
