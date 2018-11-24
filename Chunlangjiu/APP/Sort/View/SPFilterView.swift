//
//  SPFilterView.swift
//  Chunlangjiu
//
//  Created by 黄树鹏 on 2018/8/1.
//  Copyright © 2018年 Chunlang. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

/// 筛选回调
typealias SPFilterBlock = (_ minPrice : String?,_ maxPrice: String?,_ minYear : String?,_ maxYear : String?,_ brand_id : Int?, _ wineryId : Int?) -> Void

class SPFilterView:  UIView{
    
    fileprivate lazy var hideView : UIView = {
        let view = UIView()
        let tap = UITapGestureRecognizer(target: self, action: #selector(sp_removeView))
        view.addGestureRecognizer(tap)
        return view
    }()
    
    fileprivate lazy var contentView : UIView = {
        let view = UIView()
        view.backgroundColor = SPColorForHexString(hex: SP_HexColor.color_eeeeee.rawValue)
        return view
    }()
    fileprivate lazy var resBtn : UIButton = {
        let btn = UIButton(type: UIButtonType.custom)
        btn.setTitle("重置", for: UIControlState.normal)
        btn.setTitleColor(SPColorForHexString(hex: SP_HexColor.color_999999.rawValue), for: UIControlState.normal)
        btn.titleLabel?.font = sp_getFontSize(size: 16)
        btn.backgroundColor = UIColor.white
        btn.addTarget(self, action: #selector(sp_clickResAction), for: UIControlEvents.touchUpInside)
        return btn
    }()
    fileprivate lazy var doneBtn : UIButton = {
        let btn = UIButton(type: UIButtonType.custom)
        btn.setTitleColor(UIColor.white, for: UIControlState.normal)
        btn.setTitle("确定", for: UIControlState.normal)
        btn.titleLabel?.font = sp_getFontSize(size: 16)
        btn.backgroundColor = SPColorForHexString(hex: SP_HexColor.color_b31f3f.rawValue)
        btn.addTarget(self, action: #selector(sp_clickDoneAction), for: UIControlEvents.touchUpInside)
        return btn
    }()
    fileprivate var collectionView : UICollectionView!
    fileprivate let minimumLineSpacing : CGFloat = 5
    fileprivate let numCount : CGFloat = 3
    fileprivate var selectBrand : SPBrand?
    fileprivate var selectSort : SPSortRootModel?
    fileprivate var minPrice : String?
    fileprivate var maxPrice : String?
    fileprivate var minYear : String?
    fileprivate var maxYear : String?
    var filterModel : SPFilterModel?{
        didSet{
            self.sp_dealData()
        }
    }
    var filterBlock : SPFilterBlock?
    private let filterCollectionCellID =  "filterCollectionCellID"
    private let filterCollectionIntervalHeaderID = "filterCollectionIntervalHeaderID"
    private let fileteCollectionSectionHeaderID = "fileteCollectionSectionHeaderID"
    fileprivate var dataArray : [SPFilterHeaderMode]?
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = SPColorForHexString(hex: SP_HexColor.color_000000.rawValue).withAlphaComponent(0.5)
        self.sp_setupUI()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    /// 添加UI
    fileprivate func sp_setupUI(){
        self.addSubview(self.hideView)
        self.addSubview(self.contentView)
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = minimumLineSpacing
        layout.minimumInteritemSpacing = minimumLineSpacing
        layout.sectionInset = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 10)
        self.collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        self.collectionView.backgroundColor = SPColorForHexString(hex: SP_HexColor.color_ffffff.rawValue)
        self.collectionView.register(SPFilterCollectionCell.self, forCellWithReuseIdentifier: filterCollectionCellID)
        self.collectionView.register(SPFilterIntervalHeaderView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: filterCollectionIntervalHeaderID)
        self.collectionView.register(SPFilterSectionHeaderView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: fileteCollectionSectionHeaderID)
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.showsVerticalScrollIndicator = false
        self.contentView.addSubview(self.collectionView)
        self.contentView.addSubview(self.resBtn)
        self.contentView.addSubview(self.doneBtn)
        self.sp_addConstraint()
    }
    /// 添加约束
    fileprivate func sp_addConstraint(){
        self.hideView.snp.makeConstraints { (maker) in
            maker.left.right.top.bottom.equalTo(self).offset(0)
        }
        self.contentView.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.snp.left).offset(44)
            maker.top.right.equalTo(self).offset(0)
            maker.bottom.equalTo(self.snp.bottom).offset(0)
        }
        self.collectionView.snp.makeConstraints { (maker) in
            maker.top.equalTo(self.contentView).offset(0)
            maker.left.right.equalTo(self.contentView).offset(0)
            maker.bottom.equalTo(self.resBtn.snp.top).offset(0)
        }
        self.resBtn.snp.makeConstraints { (maker) in
            maker.left.bottom.equalTo(self.contentView).offset(0)
            maker.height.equalTo(44)
            maker.width.equalTo(self.doneBtn.snp.width).offset(0)
        }
        self.doneBtn.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.resBtn.snp.right).offset(0)
            maker.right.equalTo(self.contentView.snp.right).offset(0)
            maker.bottom.equalTo(self.resBtn.snp.bottom).offset(0)
            maker.height.equalTo(self.resBtn.snp.height).offset(0)
        }
    }
    deinit {
        
    }
}
extension SPFilterView : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sp_getArrayCount(array: self.dataArray)
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section < sp_getArrayCount(array: self.dataArray) {
            let model = self.dataArray![section]
            if model.showAll {
                return sp_getArrayCount(array: model.list)
            }else{
                return sp_getArrayCount(array: model.list) > 6 ? 6 : sp_getArrayCount(array: model.list)
            }
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell : SPFilterCollectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: filterCollectionCellID, for: indexPath) as! SPFilterCollectionCell
        if indexPath.section < sp_getArrayCount(array: self.dataArray) {
            let headerModel = self.dataArray![indexPath.section]
            if indexPath.row < sp_getArrayCount(array: headerModel.list){
                var isSelect : Bool = false
                if sp_getString(string:  headerModel.type) == SP_FILTER_HEADER_TYPE_BRAND {
                    let model : SPBrand = headerModel.list![indexPath.row] as! SPBrand
                    cell.titleLabel.text = sp_getString(string: model.brand_name)
                    if let select = self.selectBrand {
                        if select.brand_id == model.brand_id{
                            isSelect = true
                        }
                    }
                }else if sp_getString(string: headerModel.type) == SP_FILTER_HEADER_TYPE_CAT {
                    let model : SPSortRootModel = headerModel.list![indexPath.row] as! SPSortRootModel
                    cell.titleLabel.text = sp_getString(string: model.cat_name)
                    if let select = self.selectSort {
                        if select.cat_id == model.cat_id {
                            isSelect = true
                        }
                    }
                }
                cell.titleLabel.textColor = isSelect ? SPColorForHexString(hex: SP_HexColor.color_b31f3f.rawValue) : SPColorForHexString(hex: SP_HexColor.color_333333.rawValue)
            }
            
        }
        
        //        if indexPath.row < sp_getArrayCount(array: self.filterModel?.brand){
        //            let model = self.filterModel?.brand![indexPath.row]
        //            cell.titleLabel.text = sp_getString(string: model?.brand_name)
        //        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.frame.size.width - 32 - ((numCount - 1.0) * minimumLineSpacing)) / numCount
        return CGSize(width: width, height: 44)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if section < sp_getArrayCount(array: self.dataArray) {
            let model = self.dataArray![section]
            return CGSize(width: collectionView.frame.size.height, height: model.height)
        }
        return CGSize.zero
    }
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        var cellID = ""
        var headerModel : SPFilterHeaderMode?
        if indexPath.section < sp_getArrayCount(array: self.dataArray){
            let model = self.dataArray![indexPath.section]
            if model.type == SP_FILTER_HEADER_TYPE_PRICE || model.type == SP_FILTER_HEADER_TYPE_YEAR {
                cellID = filterCollectionIntervalHeaderID
            }else{
                cellID = fileteCollectionSectionHeaderID
            }
            headerModel = model
        }
        let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: cellID, for: indexPath)
        if let header = headerModel {
            if header.type == SP_FILTER_HEADER_TYPE_PRICE || header.type == SP_FILTER_HEADER_TYPE_YEAR{
                let headerView = view as! SPFilterIntervalHeaderView
                headerView.headerView.titleLabel.text = sp_getString(string: header.name)
                headerView.headerView.minTextField.placeholder = sp_getString(string: header.minPl)
                headerView.headerView.maxTextField.placeholder = sp_getString(string: header.maxPl)
                headerView.headerView.valueBlock = { ( minText , maxText) in
                    self.sp_dealTextComplete(headerModel: header, minText: minText, maxText: maxText)
                }
                if header.type == SP_FILTER_HEADER_TYPE_PRICE {
                    headerView.headerView.minTextField.text = sp_getString(string: self.minPrice)
                    headerView.headerView.maxTextField.text = sp_getString(string: self.maxPrice)
                }else if header.type == SP_FILTER_HEADER_TYPE_YEAR{
                    headerView.headerView.minTextField.text = sp_getString(string: self.minYear)
                    headerView.headerView.maxTextField.text = sp_getString(string: self.maxYear)
                }
                view.backgroundColor = SPColorForHexString(hex: SP_HexColor.color_eeeeee.rawValue)
            }else{
                let headerView = view as! SPFilterSectionHeaderView
                headerView.clickComplete = {
                    header.showAll = !header.showAll
                    self.collectionView.reloadData()
                }
                headerView.titleLabel.text = sp_getString(string: header.name)
                if indexPath.section == 1 {
                    headerView.topLineView.isHidden = true
                }else{
                    headerView.topLineView.isHidden = false
                }
                headerView.moreBtn.isSelected = header.showAll ? true : false
                view.backgroundColor = SPColorForHexString(hex: SP_HexColor.color_ffffff.rawValue)
            }
        }
        
        return view
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section < sp_getArrayCount(array: self.dataArray) {
            let headerModel = self.dataArray![indexPath.section]
            if indexPath.row < sp_getArrayCount(array: headerModel.list){
                if sp_getString(string:  headerModel.type) == SP_FILTER_HEADER_TYPE_BRAND {
                    let model : SPBrand = headerModel.list![indexPath.row] as! SPBrand
                    self.selectBrand = model
                }else if sp_getString(string: headerModel.type) == SP_FILTER_HEADER_TYPE_CAT {
                    let model : SPSortRootModel = headerModel.list![indexPath.row] as! SPSortRootModel
                    self.selectSort = model
                }
                collectionView.reloadData()
            }
        }
        
    }
}
extension SPFilterView {
    @objc fileprivate func sp_clickResAction(){
        self.selectSort = nil
        self.selectBrand = nil
        self.minPrice = ""
        self.maxPrice = ""
        self.minYear = ""
        self.maxYear = ""
        self.collectionView.reloadData()
    }
    @objc fileprivate func sp_clickDoneAction(){
        guard let block = self.filterBlock else {
            sp_removeView()
            return
        }
        block(self.minPrice,self.maxPrice,self.minYear,self.maxYear,self.selectBrand?.brand_id,self.selectSort?.cat_id)
        sp_removeView()
        
    }
    
    /// 移除view
    @objc fileprivate func sp_removeView(){
        self.sp_removeNotication()
        self.removeFromSuperview()
    }
    fileprivate func sp_getPrice()->SPFilterHeaderMode {
        let model = SPFilterHeaderMode()
        model.type = SP_FILTER_HEADER_TYPE_PRICE
        model.name = "价格区间"
        model.height = 98
        model.minPl = "最低价"
        model.maxPl = "最高价"
        return model
    }
    fileprivate func sp_getYear()->SPFilterHeaderMode{
        let model = SPFilterHeaderMode()
        model.type = SP_FILTER_HEADER_TYPE_YEAR
        model.name = "上市年份"
        model.height = 98
        model.minPl = "开始年份"
        model.maxPl = "结束年份"
        return model
    }
    fileprivate func sp_getOther()-> SPFilterHeaderMode{
        let model = SPFilterHeaderMode()
        model.type = SP_FILTER_HEADER_TYPE_OTHER
        model.height = 44
        return model
    }
    fileprivate func sp_dealData(){
        var list = [SPFilterHeaderMode]()
        list.append(sp_getPrice())
        if let model = self.filterModel {
            if sp_getArrayCount(array: model.brand) > 0 {
                let brandModel = sp_getOther()
                brandModel.type = SP_FILTER_HEADER_TYPE_BRAND
                brandModel.name = "品牌"
                brandModel.list = model.brand
                list.append(brandModel)
            }
            if sp_getArrayCount(array:model.cat) > 0 {
                let sortModel = sp_getOther()
                sortModel.type = SP_FILTER_HEADER_TYPE_CAT
                sortModel.name = "分类"
                sortModel.list = model.cat
                list.append(sortModel)
            }
        }
        
        list.append(self.sp_getYear())
        self.dataArray = list
        self.collectionView.reloadData()
    }
    fileprivate func sp_dealTextComplete(headerModel : SPFilterHeaderMode?,minText : String?,maxText : String?){
        guard let model = headerModel else {
            return
        }
        if model.type == SP_FILTER_HEADER_TYPE_YEAR {
            self.minYear = minText
            self.maxYear = maxText
        }else if model.type == SP_FILTER_HEADER_TYPE_PRICE {
            self.minPrice = minText
            self.maxPrice = maxText
        }
        
    }
}
// MARK: - notification 通知
extension SPFilterView {
    /// 添加通知
    func sp_addNotication(){
        
        NotificationCenter.default.addObserver(self, selector: #selector(sp_keyBoardShow(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(sp_keyBoardHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    /// 移除通知
    @objc fileprivate func sp_removeNotication(){
        NotificationCenter.default.removeObserver(self)
    }
    /// 键盘升起
    @objc fileprivate func sp_keyBoardShow(notification : Notification){
        
        
        let height = sp_getKeyBoardheight(notification: notification)
        
        self.sp_dealCollectionLayout(isShow: true, keyHeight: height)
    }
    /// 键盘隐藏
    @objc fileprivate func sp_keyBoardHide(){
        self.sp_dealCollectionLayout(isShow: false, keyHeight: 0)
    }
    fileprivate func sp_dealCollectionLayout(isShow : Bool,keyHeight : CGFloat ){
        self.collectionView.snp.remakeConstraints { (maker) in
            maker.top.equalTo(self.contentView).offset(0)
            maker.left.right.equalTo(self.contentView).offset(0)
            if isShow {
                maker.bottom.equalTo(self.contentView.snp.bottom).offset(-keyHeight)
            }else{
                maker.bottom.equalTo(self.resBtn.snp.top).offset(0)
            }
            
        }
    }
    
}

