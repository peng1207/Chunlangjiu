//
//  SPConfrimOrderVC.swift
//  Chunlangjiu
//
//  Created by 黄树鹏 on 2018/7/6.
//  Copyright © 2018年 Chunlang. All rights reserved.
//
//fileprivate var tableView : UITableView!

import Foundation
import SnapKit
class SPConfirmOrderVC: SPBaseVC {
    fileprivate var tableView : UITableView!
    fileprivate lazy var addressView : SPConfrimAddressView = {
        let view = SPConfrimAddressView()
        return view
    }()
    fileprivate lazy var footerView : SPConfrimFooterView = {
        let view = SPConfrimFooterView()
        return view
    }()
    fileprivate lazy var bottomView : SPConfrimBtnView = {
        let view = SPConfrimBtnView()
        return view
    }()
    var confirmOrder : SPConfirmOrderModel?
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
        self.tableView = UITableView(frame: CGRect.zero, style: UITableViewStyle.plain)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.separatorStyle = .none
        self.tableView.backgroundColor = self.view.backgroundColor
        self.tableView.rowHeight = SPConfrimTableCell_Product_Width * SP_PRODUCT_SCALE + 1.0
        self.tableView.tableFooterView = self.footerView
        self.tableView.tableHeaderView = self.addressView
        self.tableView.estimatedSectionFooterHeight = 100
        self.tableView.sectionFooterHeight = UITableViewAutomaticDimension
        self.view.addSubview(self.tableView)
        self.view.addSubview(self.bottomView)
        self.sp_addConstraint()
    }
    /// 添加约束
    fileprivate func sp_addConstraint(){
        self.tableView.snp.makeConstraints { (maker) in
            maker.left.top.right.equalTo(self.view).offset(0)
            maker.bottom.equalTo(self.bottomView.snp.top).offset(0)
        }
        self.bottomView.snp.makeConstraints { (maker) in
            maker.left.right.equalTo(self.view).offset(0)
            maker.height.equalTo(49)
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
extension SPConfirmOrderVC:UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        if let model = self.confirmOrder {
             return sp_getArrayCount(array: model.dataArray)
        }
        return 0
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let model = self.confirmOrder {
            if section < sp_getArrayCount(array: model.dataArray){
                let shopModel = model.dataArray?[section];
                return sp_getArrayCount(array: shopModel?.productArray)
            }
        }
        return 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let confrimOrderCellID = "confrimOrderCellID"
        var cell : SPConfrimTableCell? = tableView.dequeueReusableCell(withIdentifier: confrimOrderCellID) as?  SPConfrimTableCell
        if cell == nil {
            cell = SPConfrimTableCell(style: UITableViewCellStyle.default, reuseIdentifier: confrimOrderCellID)
        }
        
        return cell!
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let confirmOrderHeaderID = "confirmOrderHeaderID"
        var headerView : SPConfrimSectionHeadView? = tableView.dequeueReusableHeaderFooterView(withIdentifier: confirmOrderHeaderID) as? SPConfrimSectionHeadView
        if headerView == nil {
            headerView = SPConfrimSectionHeadView(reuseIdentifier: confirmOrderHeaderID)
        }
        return headerView!
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let confirmOrderFooterID = "confirmOrderFooterID"
        var footerView : SPConfrimSectionFootView? = tableView.dequeueReusableHeaderFooterView(withIdentifier: confirmOrderFooterID) as? SPConfrimSectionFootView
        if footerView == nil {
            footerView = SPConfrimSectionFootView(reuseIdentifier: confirmOrderFooterID)
        }
        return footerView!
    }
}
