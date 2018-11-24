//
//  SPSortView.swift
//  Chunlangjiu
//
//  Created by 黄树鹏 on 2018/7/4.
//  Copyright © 2018年 Chunlang. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

///  选择分类回调
typealias SPSortViewSelectComplete = (_ rootModel : SPSortRootModel?, _ lv2Model : SPSortLv2Model?,  _ lv3Model : SPSortLv3Model?) ->Void

class SPSortView:  UIView{
    
    fileprivate lazy var contentView : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        return view
    }()
    fileprivate lazy var hideView : UIView = {
        let view = UIView()
        view.backgroundColor = SPColorForHexString(hex: SP_HexColor.color_333333.rawValue).withAlphaComponent(0.3)
        let tap = UITapGestureRecognizer(target: self, action: #selector(sp_clickHideViewAction))
        view.addGestureRecognizer(tap)
        return view
    }()
    fileprivate lazy var lineView : UIView = {
        return sp_getLineView()
    }()
    fileprivate var mainTableView : UITableView!
    fileprivate var secondTableView : UITableView!
    fileprivate var thirdTableView : UITableView!
    fileprivate var secondArray : [SPSortLv2Model]?
    fileprivate var thirdArray : [SPSortLv3Model]?
    var mainSelectIndex : Int = 0
    var secondSelectIndex : Int = 0
    var thirdSelectIndex : Int = 0
    var sortArray : [SPSortRootModel]?{
        didSet{
             self.sp_setupData()
        }
    }
    var selectComplete : SPSortViewSelectComplete?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.sp_setupUI()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    /// 赋值
    fileprivate func sp_setupData(){
        self.secondArray?.removeAll()
        self.thirdArray?.removeAll()
        if self.mainSelectIndex < sp_getArrayCount(array: self.sortArray) {
            let model = self.sortArray![self.mainSelectIndex]
            self.secondArray = model.lv2
            if self.secondSelectIndex < sp_getArrayCount(array: self.secondArray) {
                let lv2Model = self.secondArray![self.secondSelectIndex]
                self.thirdArray = lv2Model.lv3
            }
        }
        self.mainTableView.reloadData()
        self.secondTableView.reloadData()
        self.thirdTableView.reloadData()
        if self.mainSelectIndex < sp_getArrayCount(array: self.sortArray) {
            self.mainTableView.scrollToRow(at: IndexPath(item: self.mainSelectIndex, section: 0), at: UITableViewScrollPosition.top, animated: false)
        }
        if self.secondSelectIndex < sp_getArrayCount(array: self.secondArray){
            self.secondTableView.scrollToRow(at: IndexPath(item: self.secondSelectIndex, section: 0), at: UITableViewScrollPosition.top, animated: false)
        }
        if self.thirdSelectIndex < sp_getArrayCount(array: self.thirdArray) {
            self.thirdTableView.scrollToRow(at: IndexPath(item: self.thirdSelectIndex, section: 0), at: UITableViewScrollPosition.top, animated: false)
        }
    }
    /// 添加UI
    fileprivate func sp_setupUI(){
        self.mainTableView = self.sp_createTableView()
        self.secondTableView = self.sp_createTableView()
        self.thirdTableView = self.sp_createTableView()
        self.addSubview(self.hideView)
        self.addSubview(self.contentView)
        self.contentView.addSubview(self.mainTableView)
        self.contentView.addSubview(self.secondTableView)
        self.contentView.addSubview(self.thirdTableView)
        self.contentView.addSubview(self.lineView)
        self.sp_addConstraint()
    }
    
    fileprivate func sp_createTableView() -> UITableView{
        let tableView = UITableView(frame: CGRect.zero, style: UITableViewStyle.plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.rowHeight = 49
        tableView.backgroundColor = UIColor.white
        tableView.showsVerticalScrollIndicator = false
        return tableView
    }
    
    /// 添加约束
    fileprivate func sp_addConstraint(){
        self.hideView.snp.makeConstraints { (maker) in
            maker.left.right.top.bottom.equalTo(self).offset(0)
        }
        self.contentView.snp.makeConstraints { (maker) in
            maker.left.right.top.equalTo(self).offset(0)
            maker.height.equalTo(210)
        }
        self.mainTableView.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.contentView).offset(5)
            maker.top.bottom.equalTo(self.contentView).offset(0)
            maker.width.equalTo(self.secondTableView.snp.width).offset(0)
        }
        self.secondTableView.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.mainTableView.snp.right).offset(0)
            maker.top.bottom.equalTo(self.mainTableView).offset(0)
            maker.width.equalTo(self.thirdTableView.snp.width).offset(0)
        }
        self.thirdTableView.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.secondTableView.snp.right).offset(0)
            maker.top.bottom.equalTo(self.secondTableView).offset(0)
            maker.right.equalTo(self.contentView.snp.right).offset(-10)
        }
        self.lineView.snp.makeConstraints { (maker) in
            maker.left.right.bottom.equalTo(self.contentView).offset(0)
            maker.height.equalTo(sp_lineHeight)
        }
    }
    deinit {
        self.mainTableView.delegate = nil
        self.mainTableView.dataSource = nil
        self.secondTableView.delegate = nil
        self.secondTableView.dataSource = nil
        self.thirdTableView.delegate = nil
        self.thirdTableView.dataSource = nil
    }
}
extension SPSortView : UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.mainTableView == tableView{
            return sp_getArrayCount(array: self.sortArray)
        }else if self.secondTableView == tableView{
            return sp_getArrayCount(array: self.secondArray)
        }else if self.thirdTableView == tableView {
            return sp_getArrayCount(array: self.thirdArray)
        }else{
            return 0
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var sortCellID = ""
        var title = ""
        var isSelect = false
        if self.mainTableView == tableView {
           sortCellID = "sortMainCellID"
            if indexPath.row < sp_getArrayCount(array: self.sortArray){
                let model  = self.sortArray![indexPath.row]
                title = sp_getString(string: model.cat_name)
            }
            if indexPath.row == self.mainSelectIndex {
                isSelect = true
            }
        }else if self.secondTableView == tableView{
            sortCellID = "sortSecondCellID"
            if indexPath.row < sp_getArrayCount(array: self.secondArray){
                let model = self.secondArray![indexPath.row]
                title = sp_getString(string: model.cat_name)
            }
            if indexPath.row == self.secondSelectIndex {
                isSelect = true
            }
        }else{
              sortCellID = "sortThirdCellID"
            if indexPath.row < sp_getArrayCount(array: self.thirdArray){
                let model = self.thirdArray![indexPath.row]
                title = sp_getString(string: model.cat_name)
            }
            if indexPath.row == self.thirdSelectIndex {
                isSelect = true
            }
        }
        var cell : SPSortTableCell? = tableView.dequeueReusableCell(withIdentifier: sortCellID) as? SPSortTableCell
        if cell == nil{
            cell = SPSortTableCell(style: UITableViewCellStyle.default, reuseIdentifier: sortCellID)
            cell?.selectionStyle = .none
        }
        cell?.titleLabel.text = title
        cell?.titleView.isHidden = isSelect ? false : true
        return cell!
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == self.mainTableView {
            if indexPath.row < sp_getArrayCount(array: self.sortArray){
                self.mainSelectIndex = indexPath.row
                self.secondSelectIndex = 0
                self.thirdSelectIndex = 0
                self.sp_setupData()
            }
        }else if tableView == self.secondTableView {
            if indexPath.row < sp_getArrayCount(array: self.secondArray){
                self.secondSelectIndex = indexPath.row
                self.thirdSelectIndex = 0
                self.sp_setupData()
                if sp_getArrayCount(array: self.secondArray) <= 0 {
                    self.thirdSelectIndex = 0
                    self.sp_dealComplete()
                    self.sp_clickHideViewAction()
                }
            }
        }else{
            if indexPath.row < sp_getArrayCount(array: self.thirdArray){
                self.thirdSelectIndex = indexPath.row
                self.thirdTableView.reloadData()
                self.sp_dealComplete()
                self.sp_clickHideViewAction()
            }
        }
    }
}
extension SPSortView {
    /// 隐藏view
    @objc fileprivate func sp_clickHideViewAction(){
        self.isHidden = true
        self.removeFromSuperview()
    }
    /// 处理回调
    fileprivate func sp_dealComplete(){
        guard let block = self.selectComplete else {
            return
        }
        var rootModel : SPSortRootModel?
        var lv2Model : SPSortLv2Model?
        var lv3Model : SPSortLv3Model?
        
        if self.mainSelectIndex < sp_getArrayCount(array: self.sortArray) {
            rootModel = self.sortArray![self.mainSelectIndex]
        }
        if self.secondSelectIndex < sp_getArrayCount(array: self.secondArray) {
            lv2Model = self.secondArray![self.secondSelectIndex]
        }
        if self.thirdSelectIndex < sp_getArrayCount(array: self.thirdArray) {
            lv3Model = self.thirdArray![self.thirdSelectIndex]
        }
        block(rootModel,lv2Model,lv3Model)
    }
}
