//
//  SPAddressAreaView.swift
//  Chunlangjiu
//
//  Created by 黄树鹏 on 2018/7/18.
//  Copyright © 2018年 Chunlang. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

/// 选择地址之后回调
typealias SPSelectAreaComplete = (_ provinceModel : SPAreaModel?,_ cityModel : SPAreaModel? ,_ areaModel : SPAreaModel?) -> Void

class SPAddressAreaView:  UIView{
    
    fileprivate lazy var hideView : UIView = {
        let view = UIView()
        let tap = UITapGestureRecognizer(target: self, action: #selector(sp_removeView))
        view.addGestureRecognizer(tap)
        return view
    }()
    
    fileprivate lazy var contentView : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        return view
    }()
    
    fileprivate lazy var topView : UIView = {
        let view = UIView()
        view.backgroundColor = SPColorForHexString(hex: SP_HexColor.color_333333.rawValue)
        return view
    }()
    
    fileprivate lazy var titleLabel : UILabel = {
        let label = UILabel()
        label.text = "配送至"
        label.font = sp_getFontSize(size: 16)
        label.textColor = UIColor.white
        return label
    }()
    fileprivate lazy var closeBtn : UIButton = {
        let btn = UIButton(type: UIButtonType.custom)
        btn.setImage(UIImage(named: "public_close_white"), for: UIControlState.normal)
        btn.addTarget(self, action: #selector(sp_removeView), for: UIControlEvents.touchUpInside)
        return btn
    }()
    fileprivate lazy var scrollView : UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.delegate = self
        scrollView.bounces = false
        return scrollView
    }()
    fileprivate lazy var provinceTableView : UITableView = {
        let tableView = UITableView(frame: CGRect.zero, style: UITableViewStyle.plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 44
        return tableView
    }()
    fileprivate lazy var cityTableView : UITableView = {
        let tableView = UITableView(frame: CGRect.zero, style: UITableViewStyle.plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 44
        return tableView
    }()
    fileprivate lazy var areaTableView : UITableView = {
        let tableView = UITableView(frame: CGRect.zero, style: UITableViewStyle.plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 44
        return tableView
    }()
    fileprivate lazy var provinceBtn : UIButton = {
        let btn = UIButton(type: UIButtonType.custom)
        btn.setTitle("请选择", for: UIControlState.normal)
        btn.setTitleColor(SPColorForHexString(hex: SP_HexColor.color_b31f3f.rawValue), for: UIControlState.selected)
        btn.setTitleColor(SPColorForHexString(hex: SP_HexColor.color_333333.rawValue), for: UIControlState.normal)
        btn.titleLabel?.font = sp_getFontSize(size: 14)
        btn.isSelected = true
        btn.addTarget(self, action: #selector(sp_clickProvinceAction), for: UIControlEvents.touchUpInside)
        return btn
    }()
    fileprivate lazy var cityBtn : UIButton = {
        let btn = UIButton(type: UIButtonType.custom)
        btn.setTitle("请选择", for: UIControlState.normal)
        btn.setTitleColor(SPColorForHexString(hex: SP_HexColor.color_b31f3f.rawValue), for: UIControlState.selected)
        btn.setTitleColor(SPColorForHexString(hex: SP_HexColor.color_333333.rawValue), for: UIControlState.normal)
        btn.titleLabel?.font = sp_getFontSize(size: 14)
        btn.isHidden = true
        btn.addTarget(self, action: #selector(sp_clickCityAction), for: UIControlEvents.touchUpInside)
        return btn
    }()
    fileprivate lazy var areaBtn : UIButton = {
        let btn = UIButton(type: UIButtonType.custom)
        btn.setTitle("请选择", for: UIControlState.normal)
        btn.setTitleColor(SPColorForHexString(hex: SP_HexColor.color_b31f3f.rawValue), for: UIControlState.selected)
        btn.setTitleColor(SPColorForHexString(hex: SP_HexColor.color_333333.rawValue), for: UIControlState.normal)
        btn.titleLabel?.font = sp_getFontSize(size: 14)
        btn.isHidden = true
        btn.addTarget(self, action: #selector(sp_clickAreaAction), for: UIControlEvents.touchUpInside)
        return btn
    }()
    
    fileprivate lazy var lineView : UIView = {
        let  view = UIView()
        view.backgroundColor = SPColorForHexString(hex: SP_HexColor.color_b31f3f.rawValue)
        return view
    }()
    var selectComplete : SPSelectAreaComplete?
    fileprivate var showDataArray : Array<SPAreaModel>?
    fileprivate var cityDataArray : Array<SPAreaModel>?
    fileprivate var areaDataArray : Array<SPAreaModel>?
     var provinceModel : SPAreaModel?
     var cityModel : SPAreaModel?
     var areaModel : SPAreaModel?
    var provinceID : String?
    var cityID : String?
    var areaID : String?

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.sp_setupUI()
        self.sp_setupData()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func sp_showView(){
        if self.superview == nil {
            let appDelegate : AppDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.window?.addSubview(self)
            self.snp.makeConstraints { (maker) in
                maker.left.right.top.equalTo(appDelegate.window!).offset(0)
                if #available(iOS 11.0, *) {
                    maker.bottom.equalTo((appDelegate.window?.safeAreaLayoutGuide.snp.bottom)!).offset(0)
                } else {
                    // Fallback on earlier versions
                    maker.bottom.equalTo(appDelegate.window!).offset(0)
                }
            }
        }
       self.isHidden = false
        sp_asyncAfter(time: 0.5) {
             self.sp_dealShowView()
        }
    }
    /// 赋值
    fileprivate func sp_setupData(){
        SPAPPManager.sp_getAreaData(isCity: false) { (list) in
            self.showDataArray = list as? Array<SPAreaModel>
            self.sp_dealData()
            self.provinceTableView.reloadData()
            self.cityTableView.reloadData()
            self.areaTableView.reloadData()
            self.sp_dealShowView()
        }
    }
    func sp_dealData(){
        if sp_getArrayCount(array: self.showDataArray) <= 0 {
            return
        }
        if sp_getString(string: provinceID).count == 0 && sp_getString(string: cityID).count == 0  && sp_getString(string: areaID).count == 0  {
            return
        }
        
        for pModel  in self.showDataArray! {
            if sp_getString(string: pModel.id) == sp_getString(string: provinceID) {
                self.provinceModel = pModel
                self.cityDataArray = pModel.children
                for cModel in pModel.children{
                    if sp_getString(string: cModel.id) == sp_getString(string: cityID){
                        self.cityModel = cModel
                        self.areaDataArray = cModel.children
                        for aModel in cModel.children{
                            if sp_getString(string: aModel.id) == sp_getString(string: aModel.id) {
                                 self.areaModel = aModel
                                break
                            }
                        }
                        break
                    }
                }
                break
            }
        }
    }
    fileprivate func sp_dealShowView(){
        var index = 0
        if let p = self.provinceModel {
            index = 1
            self.provinceBtn.setTitle(sp_getString(string: p.value), for: UIControlState.normal)
            self.provinceBtn.isSelected = true
            self.provinceBtn.isHidden = false
        }
        if let c = self.cityModel {
            index = 2
            self.cityBtn.setTitle(sp_getString(string: c.value), for: UIControlState.normal)
            self.provinceBtn.isSelected = false
            self.cityBtn.isSelected = true
            self.cityBtn.isHidden = false
        }
        if let a = self.areaModel {
            index = 3
            self.areaBtn.setTitle(sp_getString(string: a.value), for: UIControlState.normal)
            self.provinceBtn.isSelected = false
            self.cityBtn.isSelected = false
            self.areaBtn.isSelected = true
            self.areaBtn.isHidden = false
        }
        self.sp_selectTable(index:index > 0 ? index - 1 : 0)
        self.sp_setScrollViewContentSize(page: index)
      
    }
    
    /// 添加UI
    fileprivate func sp_setupUI(){
        self.addSubview(self.hideView)
        self.addSubview(self.contentView)
        self.contentView.addSubview(self.topView)
        self.topView.addSubview(self.titleLabel)
        self.topView.addSubview(self.closeBtn)
        self.contentView.addSubview(self.provinceBtn)
        self.contentView.addSubview(self.cityBtn)
        self.contentView.addSubview(self.areaBtn)
        self.contentView.addSubview(self.scrollView)
        self.contentView.addSubview(self.lineView)
        self.scrollView.addSubview(self.provinceTableView)
        self.scrollView.addSubview(self.cityTableView)
        self.scrollView.addSubview(self.areaTableView)
        self.sp_addConstraint()
    }
    /// 添加约束
    fileprivate func sp_addConstraint(){
        self.hideView.snp.makeConstraints { (maker) in
            maker.left.right.top.bottom.equalTo(self).offset(0)
        }
        self.contentView.snp.makeConstraints { (maker) in
            maker.left.right.bottom.equalTo(self).offset(0)
            maker.top.equalTo(self).offset(187)
        }
        self.topView.snp.makeConstraints { (maker) in
            maker.left.right.top.equalTo(self.contentView).offset(0)
            maker.height.equalTo(39)
        }
        self.titleLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.topView.snp.left).offset(10)
            maker.top.bottom.equalTo(self.topView).offset(0)
            maker.right.equalTo(self.closeBtn.snp.left).offset(-10)
        }
        self.closeBtn.snp.makeConstraints { (maker) in
            maker.right.equalTo(self.topView.snp.right).offset(-10)
            maker.width.equalTo(16)
            maker.height.equalTo(16)
            maker.centerY.equalTo(self.topView.snp.centerY).offset(0)
        }
        self.provinceBtn.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.contentView).offset(0)
            maker.top.equalTo(self.topView.snp.bottom).offset(0)
            maker.height.equalTo(44)
            maker.width.equalTo(62)
        }
        self.cityBtn.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.provinceBtn.snp.right).offset(0)
            maker.top.equalTo(self.provinceBtn.snp.top).offset(0)
            maker.height.equalTo(self.provinceBtn.snp.height).offset(0)
            maker.width.equalTo(self.provinceBtn.snp.width).offset(0)
        }
        self.areaBtn.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.cityBtn.snp.right).offset(0)
            maker.top.equalTo(self.cityBtn.snp.top).offset(0)
            maker.width.equalTo(self.cityBtn.snp.width).offset(0)
            maker.height.equalTo(self.cityBtn.snp.height).offset(0)
        }
        self.lineView.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.provinceBtn.snp.left).offset(0)
            maker.top.equalTo(self.provinceBtn.snp.bottom).offset(0)
            maker.height.equalTo(sp_heightOfScale(height: 2))
            maker.width.equalTo(self.provinceBtn.snp.width).offset(0)
        }
        self.scrollView.snp.makeConstraints { (maker) in
            maker.left.bottom.right.equalTo(self.contentView).offset(0)
            maker.top.equalTo(self.lineView.snp.bottom).offset(0)
        }
        self.provinceTableView.snp.makeConstraints { (maker) in
            maker.left.top.bottom.equalTo(self.scrollView).offset(0)
            maker.width.equalTo(self.scrollView.snp.width).offset(0)
            maker.centerY.equalTo(self.scrollView.snp.centerY).offset(0)
        }
        self.cityTableView.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.provinceTableView.snp.right).offset(0)
            maker.top.bottom.width.equalTo(self.provinceTableView).offset(0)
        }
        self.areaTableView.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.cityTableView.snp.right).offset(0)
            maker.top.bottom.width.equalTo(self.cityTableView).offset(0)
        }
    }
    deinit {
        
    }
}
extension SPAddressAreaView : UITableViewDelegate,UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        if tableView == self.provinceTableView {
              return sp_getArrayCount(array: self.showDataArray) > 0 ? 1 : 0
        }else if tableView == self.cityTableView {
            return sp_getArrayCount(array: self.cityDataArray) > 0 ? 1 : 0
        }else if tableView == self.areaTableView {
            return sp_getArrayCount(array: self.areaDataArray) > 0 ? 1 : 0
        }
        return 0
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.provinceTableView {
            return sp_getArrayCount(array: self.showDataArray)
        }else if tableView == self.cityTableView {
            return sp_getArrayCount(array: self.cityDataArray)
        }else if tableView == self.areaTableView {
            return sp_getArrayCount(array: self.areaDataArray)
        }
        return 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var addressAreaCellID = ""
        var model : SPAreaModel?
        var selectID : String?
        if tableView == self.provinceTableView {
            addressAreaCellID = "addressAreaProvinceCellID"
            if indexPath.row < sp_getArrayCount(array: self.showDataArray){
                model = self.showDataArray?[indexPath.row]
                selectID = self.provinceModel?.id
            }
        }else if tableView == self.cityTableView {
             addressAreaCellID = "addressAreaCityCellID"
            if indexPath.row < sp_getArrayCount(array: self.cityDataArray){
                model = self.cityDataArray?[indexPath.row]
                selectID =  self.cityModel?.id
            }
        }else if tableView == self.areaTableView {
             addressAreaCellID = "addressAreaAreaCellID"
            if indexPath.row < sp_getArrayCount(array: self.areaDataArray){
                model = self.areaDataArray?[indexPath.row]
                selectID =  self.areaModel?.id
            }
        }
     
        var cell : UITableViewCell? = tableView.dequeueReusableCell(withIdentifier: addressAreaCellID)
        if  cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: addressAreaCellID)
            cell?.selectionStyle = .none
        }
        if let m = model {
            cell?.textLabel?.text = sp_getString(string: m.value)
            if sp_getString(string: m.id) == sp_getString(string: selectID){
                cell?.textLabel?.textColor = SPColorForHexString(hex: SP_HexColor.color_b31f3f.rawValue)
            }else{
                cell?.textLabel?.textColor = SPColorForHexString(hex: SP_HexColor.color_333333.rawValue)
            }
        }
        return  cell!
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if  tableView == self.provinceTableView {
            self.areaBtn.isHidden = true
            self.cityBtn.setTitle("请选择", for: UIControlState.normal)
            self.provinceBtn.isSelected = false
            if indexPath.row < sp_getArrayCount(array: self.showDataArray){
                let model = self.showDataArray![indexPath.row]
                self.provinceModel = model
                self.provinceBtn.setTitle(sp_getString(string: model.value), for: UIControlState.normal)
                self.cityModel = nil
                self.areaModel = nil
                if sp_getArrayCount(array: model.children) > 0 {
                    self.cityBtn.isHidden = false
                     self.cityBtn.isSelected = true
                    self.cityDataArray = model.children
                    self.sp_selectTable(index: 1)
                    self.cityTableView.reloadData()
                    self.cityTableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: UITableViewScrollPosition.top, animated: false)
                    self.sp_setScrollViewContentSize(page: 2)
                }else{
                    self.sp_dealSelectComplete()
                    self.sp_setScrollViewContentSize(page: 1)
                    self.sp_removeView()
                }
            }
        }else if tableView == self.cityTableView{
            if indexPath.row < sp_getArrayCount(array: self.cityDataArray){
                let model = self.cityDataArray![indexPath.row]
                self.cityBtn.setTitle(sp_getString(string: model.value), for: UIControlState.normal)
                self.areaModel = nil
                self.cityModel = model
                if sp_getArrayCount(array: model.children) > 0  {
                    self.areaDataArray = model.children
                    self.sp_selectTable(index: 2)
                    self.areaTableView .reloadData()
                    self.areaBtn.isHidden = false
                    self.areaBtn.setTitle("请选择", for: UIControlState.normal)
                    self.areaBtn.isSelected = true
                    self.cityBtn.isSelected = false
                    self.areaTableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: UITableViewScrollPosition.top, animated: false)
                     self.sp_setScrollViewContentSize(page: 3)
                }else{
                    self.areaBtn.isHidden = true
                    self.areaBtn.setTitle("请选择", for: UIControlState.normal)
                    self.areaBtn.isSelected = false
                    self.cityBtn.isSelected = true
                    self.sp_dealSelectComplete()
                    self.sp_removeView()
                    self.sp_setScrollViewContentSize(page: 2)
                }
            }
        }else if tableView == self.areaTableView{
            if indexPath.row < sp_getArrayCount(array: self.areaDataArray){
                let model  = self.areaDataArray![indexPath.row]
                self.areaBtn.setTitle(sp_getString(string: model.value), for: UIControlState.normal)
                self.areaModel = model
                self.sp_dealSelectComplete()
                self.sp_removeView()
            }
        }
        tableView.reloadData()
    }
}
extension SPAddressAreaView {
    
    /// 点击地区
    @objc fileprivate func sp_clickAreaAction(){
        self.areaBtn.isHidden = false
        self.sp_selectTable(index: 2)
    }
    /// 点击城市
    @objc fileprivate func sp_clickCityAction(){
        self.cityBtn.isHidden = false
        self.sp_selectTable(index: 1)
    }
    /// 点击省份
    @objc fileprivate func sp_clickProvinceAction(){
        self.provinceBtn.isHidden = false
        self.sp_selectTable(index: 0)
    }
    fileprivate func sp_selectTable(index : Int,isScroll : Bool = true){
        if isScroll {
              self.scrollView.contentOffset = CGPoint(x: ( CGFloat(index) * self.scrollView.frame.size.width), y: 0)
        }
        UIView.animate(withDuration: 0.3) {
            self.lineView.layoutIfNeeded()
            self.lineView.snp.remakeConstraints { (maker) in
                if index == 0 {
                    maker.left.equalTo(self.provinceBtn.snp.left).offset(0)
                }else if index == 1 {
                    maker.left.equalTo(self.cityBtn.snp.left).offset(0)
                }else {
                    maker.left.equalTo(self.areaBtn.snp.left).offset(0)
                }
                maker.top.equalTo(self.provinceBtn.snp.bottom).offset(0)
                maker.height.equalTo(sp_heightOfScale(height: 2))
                maker.width.equalTo(self.provinceBtn.snp.width).offset(0)
            }
        }
        
    }
    fileprivate func sp_dealSelectComplete(){
        guard let block  = self.selectComplete else {
            return
        }
        block(self.provinceModel,self.cityModel,self.areaModel)
    }
    /// 移除view
    @objc fileprivate func sp_removeView(){
        self.isHidden = true
    }
    fileprivate func sp_setScrollViewContentSize(page : Int) {
        self.scrollView.contentSize = CGSize(width: (CGFloat(page) * self.scrollView.frame.size.width), height: self.scrollView.frame.size.height)
    }
}
extension SPAddressAreaView : UIScrollViewDelegate{
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let page = scrollView.contentOffset.x / scrollView.frame.size.width
        sp_log(message: "scrollView-------\(page)")
        sp_selectTable(index: Int(page), isScroll: false)
    }
    
}
