//
//  SPWineryPictureView.swift
//  Chunlangjiu
//
//  Created by 黄树鹏 on 2018/7/28.
//  Copyright © 2018年 Chunlang. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
class SPWineryPictureView:  UIView{
    
    fileprivate lazy var tableView : UITableView = {
        let view = UITableView(frame: CGRect.zero, style: UITableViewStyle.plain)
        view.separatorStyle = UITableViewCellSeparatorStyle.none
        view.delegate = self
        view.dataSource = self
        view.estimatedRowHeight = 100
        view.rowHeight = UITableViewAutomaticDimension
        return view
    }()
    var dataArray : [String]?{
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
        self.addSubview(self.tableView)
        self.sp_addConstraint()
    }
    /// 添加约束
    fileprivate func sp_addConstraint(){
        self.tableView.snp.makeConstraints { (maker) in
            maker.left.right.bottom.top.equalTo(self).offset(0)
        }
    }
    deinit {
        
    }
}
extension SPWineryPictureView : UITableViewDelegate,UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return sp_getArrayCount(array: self.dataArray) > 0 ? 1 : 0
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sp_getArrayCount(array: self.dataArray)
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let wineryPictureCellID = "wineryPictureCellID"
        var cell : SPWineryPictureTableCell? = tableView.dequeueReusableCell(withIdentifier: wineryPictureCellID) as? SPWineryPictureTableCell
        if  cell == nil {
            cell = SPWineryPictureTableCell(style: UITableViewCellStyle.default, reuseIdentifier: wineryPictureCellID)
        }
        if indexPath.row < sp_getArrayCount(array: self.dataArray) {
            cell?.iconImageView.sp_cache(string: sp_getString(string: self.dataArray?[indexPath.row]), plImage: sp_getLogoImg())
        }
        return cell!
    }
}
