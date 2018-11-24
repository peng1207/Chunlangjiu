//
//  SPWineryScoreView.swift
//  Chunlangjiu
//
//  Created by 黄树鹏 on 2018/7/28.
//  Copyright © 2018年 Chunlang. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
class SPWineryScoreView:  UIView{
    fileprivate lazy var headerView : SPWineryScoreHeaderView = {
        let view  = SPWineryScoreHeaderView()
        return view
    }()
    fileprivate lazy var tableView : UITableView = {
        let view = UITableView(frame: CGRect.zero, style: UITableViewStyle.plain)
        view.rowHeight = 44
        view.separatorStyle = UITableViewCellSeparatorStyle.none
        view.delegate = self
        view.dataSource = self
        return view
    }()
     var dataArray : [SPWinderGrade]?{
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
        self.addSubview(self.headerView)
        self.addSubview(self.tableView)
        self.sp_addConstraint()
    }
    /// 添加约束
    fileprivate func sp_addConstraint(){
        self.headerView.snp.makeConstraints { (maker) in
            maker.left.right.top.equalTo(self).offset(0)
            maker.height.equalTo(44)
        }
        self.tableView.snp.makeConstraints { (maker) in
            maker.left.right.bottom.equalTo(self).offset(0)
            maker.top.equalTo(self.headerView.snp.bottom).offset(0)
        }
    }
    deinit {
        self.tableView.delegate = nil
        self.tableView.dataSource = nil
    }
}
// MARK: - deleagte
extension SPWineryScoreView : UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return sp_getArrayCount(array: self.dataArray) > 0 ? 1 : 0
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sp_getArrayCount(array: self.dataArray)
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let wineryScoreCellID = "wineryScoreCellID"
        var cell : SPWineryScoreTableCell? = tableView.dequeueReusableCell(withIdentifier: wineryScoreCellID) as? SPWineryScoreTableCell
        if  cell == nil {
            cell = SPWineryScoreTableCell(style: UITableViewCellStyle.default, reuseIdentifier: wineryScoreCellID)
        }
        if indexPath.row < sp_getArrayCount(array: self.dataArray) {
            let model = self.dataArray?[indexPath.row]
            cell?.model = model
        }
        
        return cell!
    }
}
