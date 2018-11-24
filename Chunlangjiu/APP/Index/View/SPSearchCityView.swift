//
//  SPSearchCityView.swift
//  Chunlangjiu
//
//  Created by 黄树鹏 on 2018/8/12.
//  Copyright © 2018年 Chunlang. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
class SPSearchCityView:  UIView{
    fileprivate var tableView : UITableView!
    var selectBlock : SPCitySelectBlock?
    var dataArray : [SPAreaModel]?{
        didSet{
            self.tableView.reloadData()
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.sp_setupUI()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    /// 添加UI
    fileprivate func sp_setupUI(){
        self.tableView = UITableView(frame: CGRect.zero, style: UITableViewStyle.plain)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.rowHeight = 56
        self.addSubview(self.tableView)
        
        self.sp_addConstraint()
    }
    /// 添加约束
    fileprivate func sp_addConstraint(){
        self.tableView.snp.makeConstraints { (maker) in
            maker.left.right.top.bottom.equalTo(self).offset(0)
        }
    }
    deinit {
        
    }
}
extension SPSearchCityView : UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return sp_getArrayCount(array: self.dataArray) > 0 ? 1 : 0
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sp_getArrayCount(array: self.dataArray)
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let searchCityCellID = "searchCityCellID"
        var cell : UITableViewCell? = tableView.dequeueReusableCell(withIdentifier: searchCityCellID)
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: searchCityCellID)
            cell?.textLabel?.textColor = SPColorForHexString(hex: SP_HexColor.color_333333.rawValue)
        }
        if indexPath.row < sp_getArrayCount(array: self.dataArray) {
            let areaModel = self.dataArray![indexPath.row]
            cell?.textLabel?.text = sp_getString(string: areaModel.value)
        }
        return cell!
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row < sp_getArrayCount(array: self.dataArray) {
            let areaModel = self.dataArray![indexPath.row]
            guard let block = self.selectBlock else {
                return
            }
            block(areaModel)
        }
    }
}
