//
//  SPSortMainVC.swift
//  Chunlangjiu
//
//  Created by 黄树鹏 on 2018/7/4.
//  Copyright © 2018年 Chunlang. All rights reserved.
//

import Foundation
import SnapKit

/// 选择回调
typealias SPSortSelectComplete = (_ model: SPSortRootModel) -> Void
class SPSortMainVC: SPBaseVC ,UITableViewDelegate,UITableViewDataSource{
    fileprivate var tableView : UITableView!
    var dataArray : Array<SPSortRootModel>?{
        didSet{
            self.tableView.reloadData()
            self.sp_dealSelect()
        }
    }
    var selectIndexPath : IndexPath = IndexPath(row: 0, section: 0)
    var selectBlock : SPSortSelectComplete?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.sp_setupUI()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    override func sp_setupUI() {
        self.tableView = UITableView(frame: CGRect.zero, style: .plain)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.rowHeight = 44
        self.tableView.separatorStyle = .none
        self.tableView.showsVerticalScrollIndicator = false
        self.tableView.backgroundColor = self.view.backgroundColor;
        self.view.addSubview(self.tableView)
        self.sp_addConstraint()
    }
    /// 添加约束
    fileprivate func sp_addConstraint(){
        self.tableView.snp.makeConstraints { (maker) in
            maker.left.top.right.equalTo(self.view).offset(0)
            if #available(iOS 11.0, *) {
                maker.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(0)
            } else {
                // Fallback on earlier versions
                   maker.bottom.equalTo(self.view.snp.bottom).offset(0)
            };
        }
    }
    deinit {
        
    }
}

 extension SPSortMainVC{
     func numberOfSections(in tableView: UITableView) -> Int {
        return sp_getArrayCount(array: self.dataArray) > 0 ? 1 : 0
    }
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sp_getArrayCount(array: self.dataArray)
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let sortCellId = "sortCellId"
        var cell :SPSortMainTableCell? = tableView.dequeueReusableCell(withIdentifier:sortCellId) as? SPSortMainTableCell
        if cell == nil {
            cell = SPSortMainTableCell(style: .default, reuseIdentifier: sortCellId)
        }
        if indexPath.row < sp_getArrayCount(array: self.dataArray) {
            let model = self.dataArray![indexPath.row]
            cell?.titleLabel.text = sp_getString(string: model.cat_name)
        }
        if selectIndexPath.row == indexPath.row {
             cell?.labeIsSelect(select: true)
        }else{
             cell?.labeIsSelect(select: false)
        }
        return cell!
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectIndexPath = indexPath
        self.sp_dealSelect()
        self.tableView.reloadData()
    }
}
fileprivate extension SPSortMainVC {
    fileprivate func sp_dealSelect(){
        if selectIndexPath.row < sp_getArrayCount(array: self.dataArray), let block = selectBlock {
            block(self.dataArray![selectIndexPath.row])
        }
    }
    
}
