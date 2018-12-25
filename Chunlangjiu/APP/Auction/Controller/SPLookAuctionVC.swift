//
//  SPLookAuctionVC.swift
//  Chunlangjiu
//
//  Created by 黄树鹏 on 2018/12/25.
//  Copyright © 2018 Chunlang. All rights reserved.
//

import Foundation
import SnapKit
class SPLookAuctionVC: SPBaseVC {
    fileprivate var tableView : UITableView!
    fileprivate var dataArray : [SPAuctionPrice]?
    var auctionitem_id : String? 
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
        self.navigationItem.title = "出价记录"
        self.tableView = UITableView(frame: CGRect.zero, style: UITableViewStyle.plain)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.separatorStyle = .none
        self.tableView.rowHeight = 65
        self.tableView.backgroundColor = self.view.backgroundColor
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
extension SPLookAuctionVC : UITableViewDelegate,UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sp_getArrayCount(array: self.dataArray) > 0 ? 1 : 0
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sp_getArrayCount(array: self.dataArray)
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let lookAuctionPriceCellID = "lookAuctionPriceCellID"
        var cell : SPLookAuctionTableCell? = tableView.dequeueReusableCell(withIdentifier: lookAuctionPriceCellID) as? SPLookAuctionTableCell
        if cell == nil {
            cell = SPLookAuctionTableCell(style: UITableViewCellStyle.default, reuseIdentifier: lookAuctionPriceCellID)
        }
        if indexPath.row < sp_getArrayCount(array: self.dataArray) {
            cell?.model = self.dataArray?[indexPath.row]
        }
        
        return cell!
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
}
