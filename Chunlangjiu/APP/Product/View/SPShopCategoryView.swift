//
//  SPShopCategoryView.swift
//  Chunlangjiu
//
//  Created by chengzong liang on 2018/9/4.
//  Copyright © 2018年 Chunlang. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
typealias SPShopCategoryComplete = (_ mainModel : SPShopCategory?,_ nextModel : SPShopCategory?)->Void
class SPShopCategoryView : UIView{
    
    fileprivate lazy var contentView : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        return view
    }()
    fileprivate lazy var hideView : UIView = {
        let view = UIView()
        view.backgroundColor = SPColorForHexString(hex: SP_HexColor.color_000000.rawValue).withAlphaComponent(0.3)
        let tap = UITapGestureRecognizer(target: self, action: #selector(sp_hideView))
        view.addGestureRecognizer(tap)
        return view
    }()
    fileprivate  var firstTabelView : UITableView!
    fileprivate var secondTableView : UITableView!
    
    var dataArray : [SPShopCategory]?{
        didSet{
            self.firstTabelView.reloadData()
            if sp_getArrayCount(array: dataArray) > 0  {
                firstModel = self.dataArray?.first
                children = firstModel?.children
                self.secondTableView.reloadData()
            }
        }
        
    }
    fileprivate var children : [SPShopCategory]?
    var firstModel : SPShopCategory?
    var secondModel : SPShopCategory?
    var selectBlock : SPShopCategoryComplete?
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.sp_setupUI()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    /// 添加UI
    fileprivate func sp_setupUI(){
        self.addSubview(self.hideView)
        self.addSubview(self.contentView)
        self.firstTabelView = UITableView(frame: CGRect.zero, style: UITableViewStyle.plain)
        self.secondTableView = UITableView(frame: CGRect.zero, style: UITableViewStyle.plain)
        self.firstTabelView.delegate = self
        self.firstTabelView.dataSource = self
        self.firstTabelView.rowHeight = 44
        self.firstTabelView.separatorStyle = .none
        self.secondTableView.delegate = self
        self.secondTableView.dataSource = self
        self.secondTableView.rowHeight = 44
        self.secondTableView.separatorStyle = .none
        self.contentView.addSubview(self.firstTabelView)
        self.contentView.addSubview(self.secondTableView)
        self.sp_addConstraint()
    }
    /// 添加约束
    fileprivate func sp_addConstraint(){
        self.hideView.snp.makeConstraints { (maker) in
            maker.left.right.top.bottom.equalTo(self).offset(0)
        }
        self.contentView.snp.makeConstraints { (maker) in
            maker.left.top.right.equalTo(self).offset(0)
            maker.bottom.equalTo(self.snp.bottom).offset(-80)
        }
        self.firstTabelView.snp.makeConstraints { (maker) in
            maker.left.top.bottom.equalTo(self.contentView).offset(0)
            maker.width.equalTo(self.secondTableView).offset(0)
        }
        self.secondTableView.snp.makeConstraints { (maker) in
            maker.top.right.bottom.equalTo(self.contentView).offset(0)
            maker.left.equalTo(self.firstTabelView.snp.right).offset(0)
        }
    }
    deinit {
        
    }
}

extension SPShopCategoryView : UITableViewDelegate,UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        if tableView == self.firstTabelView {
            return sp_getArrayCount(array: self.dataArray) > 0 ? 1 : 0
        }else if tableView == self.secondTableView {
            return sp_getArrayCount(array: self.children) > 0 ? 1 : 0
        }
        return 0
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.firstTabelView {
            return sp_getArrayCount(array: self.dataArray)
        }else if tableView == self.secondTableView {
            return sp_getArrayCount(array: self.children)
        }
        return 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == self.firstTabelView {
            let shopCategoryFirstCellID = "shopCategoryFirstCellID"
            var cell : UITableViewCell? = tableView.dequeueReusableCell(withIdentifier: shopCategoryFirstCellID)
            if cell == nil {
                cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: shopCategoryFirstCellID)
                cell?.selectionStyle = .none
                let lineView  = sp_getLineView()
                cell?.contentView.addSubview(lineView)
                lineView.snp.makeConstraints { (maker) in
                    maker.left.equalTo((cell?.contentView)!).offset(5)
                    maker.right.equalTo((cell?.contentView)!).offset(-5)
                    maker.bottom.equalTo((cell?.contentView)!).offset(0)
                    maker.height.equalTo(sp_lineHeight)
                }
            }
            if indexPath.row < sp_getArrayCount(array: self.dataArray) {
                let model = self.dataArray?[indexPath.row]
                cell?.textLabel?.text = sp_getString(string: model?.cat_name)
                if firstModel?.cat_id == model?.cat_id {
                    cell?.textLabel?.textColor = SPColorForHexString(hex: SP_HexColor.color_b31f3f.rawValue)
                }else{
                    cell?.textLabel?.textColor = SPColorForHexString(hex: SP_HexColor.color_333333.rawValue)
                }
            }
            return cell!
        }else{
            let shopCategorySecondCellID = "shopCategorySecondCellID"
            var cell : UITableViewCell? = tableView.dequeueReusableCell(withIdentifier: shopCategorySecondCellID)
            if cell == nil {
                cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: shopCategorySecondCellID)
                cell?.selectionStyle = .none
                let lineView  = sp_getLineView()
                cell?.contentView.addSubview(lineView)
                lineView.snp.makeConstraints { (maker) in
                    maker.left.equalTo((cell?.contentView)!).offset(5)
                    maker.right.equalTo((cell?.contentView)!).offset(-5)
                    maker.bottom.equalTo((cell?.contentView)!).offset(0)
                    maker.height.equalTo(sp_lineHeight)
                }
            }
            if indexPath.row < sp_getArrayCount(array: self.children) {
                let model = self.children?[indexPath.row]
                cell?.textLabel?.text = sp_getString(string: model?.cat_name)
                if secondModel?.cat_id == model?.cat_id {
                    cell?.textLabel?.textColor = SPColorForHexString(hex: SP_HexColor.color_b31f3f.rawValue)
                }else{
                    cell?.textLabel?.textColor = SPColorForHexString(hex: SP_HexColor.color_333333.rawValue)
                }
            }
            return cell!
            
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == self.firstTabelView {
            if indexPath.row < sp_getArrayCount(array: self.dataArray) {
                let model = self.dataArray?[indexPath.row]
                self.children = model?.children
                self.firstModel = model
                self.secondModel = nil
                self.firstTabelView.reloadData()
                self.secondTableView.reloadData()
            }
        }else{
            if indexPath.row < sp_getArrayCount(array: self.children){
                let model = self.children?[indexPath.row]
                self.secondModel = model
                self.sp_dealSelct()
                self.secondTableView.reloadData()
            }
        }
    }
}
extension SPShopCategoryView{
    fileprivate func sp_dealSelct(){
        guard let block = self.selectBlock else {
            return
        }
        block(self.firstModel,self.secondModel)
        self.sp_hideView()
    }
    @objc fileprivate func sp_hideView(){
        self.isHidden = true
    }
}
