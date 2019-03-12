//
//  SPDetView.swift
//  Chunlangjiu
//
//  Created by 黄树鹏 on 2018/12/21.
//  Copyright © 2018 Chunlang. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
class SPDetView:  UIView{
    fileprivate lazy var titleLabel : UILabel = {
        let label = UILabel()
        label.font = sp_getFontSize(size: 15)
        label.textColor = SPColorForHexString(hex: SP_HexColor.color_000000.rawValue)
        label.textAlignment = .center
        label.text = "详情"
        return label
    }()
    fileprivate var tableView : UITableView!
    var productModel : SPProductModel?{
        didSet{
            self.sp_setupData()
        }
    }
    fileprivate var dataArray : [[String : Any]]?
    fileprivate var heightConstraint : Constraint!
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.sp_setupUI()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    /// 赋值
    fileprivate func sp_setupData(){
        if let isAuction = productModel?.isAuction, isAuction {
            self.titleLabel.text = "拍品详情"
        }else {
             self.titleLabel.text = "详情"
        }
        
        
        var array = [[String :Any]]()
        array.append(["title":"商品名称","value":sp_getString(string: self.productModel?.title)])
       
        let jsonArray : [[String : Any]]? = sp_stringValueArr(sp_getString(string: self.productModel?.parameter)) as? [[String : Any]]
        if sp_getArrayCount(array: jsonArray) > 0 , let list : [[String : Any]] = jsonArray {
            for data in list {
                let value = sp_getString(string: data["value"])
                if sp_getString(string: value).count > 0 {
                    array.append(data)
                }
            }
        }
        self.dataArray = array
        self.heightConstraint.update(offset: sp_getArrayCount(array: self.dataArray) * 30)
        self.tableView.reloadData()
    }
    /// 添加UI
    fileprivate func sp_setupUI(){
        self.addSubview(self.titleLabel)
        self.tableView = UITableView(frame: CGRect.zero, style: UITableViewStyle.plain)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.separatorStyle = .none
        self.tableView.rowHeight = 30
        self.tableView.sp_border(color: SPColorForHexString(hex: SP_HexColor.color_666666.rawValue), width: sp_lineHeight)
        self.addSubview(self.tableView)
        self.sp_addConstraint()
    }
    /// 添加约束
    fileprivate func sp_addConstraint(){
        self.titleLabel.snp.makeConstraints { (maker) in
            maker.left.right.top.equalTo(self).offset(0)
            maker.height.equalTo(40)
        }
        self.tableView.snp.makeConstraints { (maker) in
            maker.left.equalTo(self).offset(19)
            maker.right.equalTo(self).offset(-12)
            maker.top.equalTo(self.titleLabel.snp.bottom).offset(20)
            self.heightConstraint = maker.height.equalTo(30).constraint
            maker.bottom.equalTo(self.snp.bottom).offset(-10)
        }
    }
    deinit {
        
    }
}

extension SPDetView : UITableViewDelegate,UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sp_getArrayCount(array: self.dataArray) > 0 ? 1 : 0
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sp_getArrayCount(array: self.dataArray)
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let detViewCellID = "detViewCellID"
        var cell : SPDetViewTableCell? = tableView.dequeueReusableCell(withIdentifier: detViewCellID) as? SPDetViewTableCell
        if cell == nil {
            cell = SPDetViewTableCell(style: UITableViewCellStyle.default, reuseIdentifier: detViewCellID)
        }
        if indexPath.row < sp_getArrayCount(array: self.dataArray) {
            let dic : [String : Any]? = self.dataArray?[indexPath.row]
            if let d = dic {
                var title = sp_getString(string: d["title"])
                if title.count == 2 {
                    
//                    title.insert("  ", at: title.startIndex)
                    var insertStr = "\(sp_getString(string: title))"
                    //在指定位置插入
//                     insertStr.insert(" ", at:  insertStr.index(after: insertStr.index(insertStr.startIndex, offsetBy: 0)))
                    insertStr.insert(contentsOf: "       ", at: insertStr.index(after: insertStr.index(insertStr.startIndex, offsetBy: 0)))
                    title = insertStr
                }
                cell?.titleLabel.text = "\(title):"
                
                cell?.contentLabel.text = sp_getString(string: d["value"])
            }
            cell?.lineView.isHidden = sp_getArrayCount(array: self.dataArray) - 1 == indexPath.row ? true : false
        }
        return cell!
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}

import UIKit
import SnapKit
class SPDetViewTableCell: UITableViewCell {
    lazy var titleLabel : UILabel = {
        let label = UILabel()
        label.font = sp_getFontSize(size: 12)
        label.textColor = SPColorForHexString(hex: SP_HexColor.color_333333.rawValue)
        label.textAlignment = .center
        return label
    }()
     lazy var contentLabel : UILabel = {
        let label = UILabel()
        label.font = sp_getFontSize(size: 12)
        label.textColor = SPColorForHexString(hex: SP_HexColor.color_333333.rawValue)
        label.textAlignment = .left
        return label
    }()
     lazy var lineView : UIView = {
        let view = sp_getLineView()
        view.backgroundColor = SPColorForHexString(hex: SP_HexColor.color_666666.rawValue)
        return view
    }()
    fileprivate lazy var vlineView : UIView = {
        let view = sp_getLineView()
        view.backgroundColor = SPColorForHexString(hex: SP_HexColor.color_666666.rawValue)
        return view
    }()
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.sp_setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    /// 添加UI
    fileprivate func sp_setupUI(){
        self.contentView.addSubview(self.titleLabel)
        self.contentView.addSubview(self.contentLabel)
        self.contentView.addSubview(self.vlineView)
        self.contentView.addSubview(self.lineView)
        self.sp_addConstraint()
    }
    /// 添加约束
    fileprivate func sp_addConstraint(){
        self.titleLabel.snp.makeConstraints { (maker) in
            maker.left.top.bottom.equalTo(self.contentView).offset(0)
            maker.width.equalTo(76)
        }
        self.vlineView.snp.makeConstraints { (maker) in
            maker.top.bottom.equalTo(self.contentView).offset(0)
            maker.left.equalTo(self.titleLabel.snp.right).offset(2)
            maker.width.equalTo(sp_lineHeight)
        }
        self.contentLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.vlineView.snp.right).offset(5)
            maker.top.bottom.equalTo(self.contentView).offset(0)
            maker.right.equalTo(self.contentView.snp.right).offset(-5)
        }
        self.lineView.snp.makeConstraints { (maker) in
            maker.left.right.bottom.equalTo(self.contentView).offset(0)
            maker.height.equalTo(sp_lineHeight)
        }
    }
    deinit {
        
    }
}
