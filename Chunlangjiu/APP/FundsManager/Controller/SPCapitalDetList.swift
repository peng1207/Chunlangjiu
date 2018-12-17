//
//  SPCapitalDetList.swift
//  Chunlangjiu
//
//  Created by 黄树鹏 on 2018/12/14.
//  Copyright © 2018 Chunlang. All rights reserved.
//

import Foundation
import SnapKit
class SPCapitalDetList: SPBaseVC {
    fileprivate var tableView : UITableView!
    fileprivate var dataArray : [SPCapitalDetModel]?
    
    
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
    /// 创建UI
    override func sp_setupUI() {
        self.tableView = UITableView(frame: CGRect.zero, style: UITableViewStyle.grouped)
        self.tableView.separatorStyle = .none
        self.tableView.backgroundColor = self.view.backgroundColor
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.sp_headerRefesh {
            
        }
        self.tableView.sp_footerRefresh {
            
        }
        self.view.addSubview(self.tableView)
        self.sp_addConstraint()
    }
    /// 处理有没数据
    override func sp_dealNoData(){
        
    }
    /// 添加约束
    fileprivate func sp_addConstraint(){
        self.tableView.snp.makeConstraints { (maker) in
            maker.left.right.top.equalTo(self.view).offset(0)
            if #available(iOS 11.0, *) {
                maker.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(0)
            } else {
                maker.bottom.equalTo(self.view.snp.bottom).offset(0)
            }
           
        }
    }
    deinit {
        
    }
}
extension SPCapitalDetList : UITableViewDelegate,UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sp_getArrayCount(array: self.dataArray)
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let capitalDetListCellID = "capitalDetListCellID"
        var cell : SPCapitalDetListTableCell? = tableView.dequeueReusableCell(withIdentifier: capitalDetListCellID) as? SPCapitalDetListTableCell
        if cell == nil {
            cell = SPCapitalDetListTableCell(style: UITableViewCellStyle.default, reuseIdentifier: capitalDetListCellID)
        }
        if indexPath.section < sp_getArrayCount(array: self.dataArray) {
            cell?.model = self.dataArray?[indexPath.section]
        }
        return cell!
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section < sp_getArrayCount(array: self.dataArray) {
            let detVC = SPCapitalDetDetVC()
            self.navigationController?.pushViewController(detVC, animated: true)
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return  10
        }
        return 5
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    
}
