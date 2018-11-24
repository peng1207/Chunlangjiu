//
//  SPShowSortView.swift
//  Chunlangjiu
//
//  Created by 黄树鹏 on 2018/8/23.
//  Copyright © 2018年 Chunlang. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

typealias SPShowSortSelectComplete = (_ model : SPSortLv3Model?)->Void

class SPShowSortView:  UIView{
    fileprivate lazy var hidenView : UIView = {
        let view = UIView()
        view.backgroundColor = SPColorForHexString(hex: SP_HexColor.color_000000.rawValue).withAlphaComponent(0.3)
        let tap = UITapGestureRecognizer(target: self, action: #selector(sp_hideView))
        view.addGestureRecognizer(tap)
        return view
    }()
    fileprivate lazy var lineView : UIView = {
        return sp_getLineView()
    }()
    fileprivate var tableView : UITableView!
    var dataArray : [SPSortLv3Model]?{
        didSet{
            self.tableView.reloadData()
        }
    }
    var selectorModel : SPSortLv3Model?
    var selectBlock : SPShowSortSelectComplete?
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.sp_setupUI()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func sp_reload(){
        self.tableView.reloadData()
    }
    /// 添加UI
    fileprivate func sp_setupUI(){
        self.addSubview(self.hidenView)
        self.tableView = UITableView(frame: CGRect.zero, style: UITableViewStyle.plain)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.separatorStyle = .none
        self.tableView.rowHeight = 30
        self.addSubview(self.tableView)
        self.addSubview(self.lineView)
        self.sp_addConstraint()
    }
    @objc fileprivate func sp_hideView(){
         self.isHidden = true
    }
    /// 添加约束
    fileprivate func sp_addConstraint(){
        self.tableView.snp.makeConstraints { (maker) in
            maker.left.right.top.equalTo(self).offset(0)
            maker.bottom.equalTo(self).offset(-50)
        }
        self.hidenView.snp.makeConstraints { (maker) in
            maker.left.right.top.bottom.equalTo(self).offset(0)
        }
        self.lineView.snp.makeConstraints { (maker ) in
            maker.left.right.top.equalTo(self).offset(0)
            maker.height.equalTo(sp_lineHeight)
        }
    }
    deinit {
        
    }
}
extension SPShowSortView : UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return sp_getArrayCount(array: self.dataArray) > 0 ? 1 : 0
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sp_getArrayCount(array: self.dataArray)
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let showSortCellID = "spShowSortCellID"
        var cell : UITableViewCell? = tableView.dequeueReusableCell(withIdentifier: showSortCellID)
        if  cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: showSortCellID)
            cell?.selectionStyle = .none
            let view = sp_getLineView()
            cell?.contentView.addSubview(view)
            view.snp.makeConstraints { (maker) in
                maker.left.right.bottom.equalTo((cell?.contentView)!).offset(0)
                maker.height.equalTo(sp_lineHeight)
            }
        }
        if indexPath.row < sp_getArrayCount(array: self.dataArray){
            let model = self.dataArray?[indexPath.row]
            cell?.textLabel?.text = sp_getString(string: model?.cat_name)
               cell?.textLabel?.textColor = SPColorForHexString(hex: SP_HexColor.color_666666.rawValue)
            if let m = self.selectorModel{
                if m.cat_id == model?.cat_id {
                    cell?.textLabel?.textColor = SPColorForHexString(hex: SP_HexColor.color_b31f3f.rawValue)
                }else{
                    
                }
            }
            
        }
        return cell!
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row < sp_getArrayCount(array: self.dataArray) {
             let model = self.dataArray?[indexPath.row]
            self.selectorModel = model
            
            guard let block = self.selectBlock else {
                return
            }
            block(model)
            tableView.reloadData()
        }
    }
}
