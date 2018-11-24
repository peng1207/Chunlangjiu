//
//  SPShopAlcoholView.swift
//  Chunlangjiu
//
//  Created by chengzong liang on 2018/9/4.
//  Copyright © 2018年 Chunlang. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
typealias SPShopAlcoholComplete = (_ model : SPAlcoholDegree?)->Void
class SPShopAlcoholView : UIView{
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
    fileprivate lazy var lineView : UIView = {
        return sp_getLineView()
    }()
    fileprivate var tableView : UITableView!
    var dataArray : [SPAlcoholDegree]?{
        didSet{
            self.tableView.reloadData()
        }
    }
    var selectBrandID : Int = 0 {
        didSet{
            self.tableView.reloadData()
        }
    }
    var selectBlock : SPShopAlcoholComplete?
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
        self.tableView = UITableView(frame: CGRect.zero, style: UITableViewStyle.plain)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.rowHeight = 44
        self.tableView.separatorStyle = .none
        self.contentView.addSubview(self.tableView)
        self.contentView.addSubview(self.lineView)
        self.sp_addConstraint()
    }
    /// 添加约束
    fileprivate func sp_addConstraint(){
        self.hideView.snp.makeConstraints { (maker ) in
            maker.left.right.top.bottom.equalTo(self).offset(0)
        }
        self.contentView.snp.makeConstraints { (maker) in
            maker.left.top.right.equalTo(self).offset(0)
           maker.bottom.equalTo(self.snp.bottom).offset(-50)
        }
        self.tableView.snp.makeConstraints { (maker) in
            maker.left.right.top.bottom.equalTo(self.contentView).offset(0)
        }
        self.lineView.snp.makeConstraints { (maker) in
            maker.left.right.top.equalTo(self.contentView).offset(0)
            maker.height.equalTo(sp_lineHeight)
        }
    }
    deinit {
        
    }
}
extension SPShopAlcoholView : UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return sp_getArrayCount(array: self.dataArray) > 0 ? 1 : 0
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sp_getArrayCount(array: self.dataArray)
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let shopBrandCellID = "ShopAlcoholCellID"
        var cell : UITableViewCell? = tableView.dequeueReusableCell(withIdentifier: shopBrandCellID)
        if cell ==  nil {
            cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: shopBrandCellID)
            cell?.selectionStyle = .none
            let view = sp_getLineView()
            cell?.contentView.addSubview(view)
            view.snp.makeConstraints { (maker) in
                maker.left.right.bottom.equalTo((cell?.contentView)!).offset(0)
                maker.height.equalTo(sp_lineHeight)
            }
        }
        if indexPath.row < sp_getArrayCount(array: self.dataArray) {
            let model = self.dataArray?[indexPath.row];
            cell?.textLabel?.text = sp_getString(string: model?.alcohol_name)
            if model?.alcohol_id == selectBrandID {
                cell?.textLabel?.textColor = SPColorForHexString(hex: SP_HexColor.color_b31f3f.rawValue)
            }else{
                cell?.textLabel?.textColor = SPColorForHexString(hex: SP_HexColor.color_333333.rawValue)
            }
        }
        return cell!
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row < sp_getArrayCount(array: self.dataArray) {
            guard let block = self.selectBlock else {
                return
            }
            block(self.dataArray?[indexPath.row])
            sp_hideView()
        }
    }
}
extension SPShopAlcoholView {
    @objc fileprivate func sp_hideView(){
        self.isHidden = true
    }
    
}
