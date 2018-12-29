//
//  SPRechargeVC.swift
//  Chunlangjiu
//
//  Created by 黄树鹏 on 2018/12/15.
//  Copyright © 2018 Chunlang. All rights reserved.
//

import Foundation
import SnapKit
class SPRechargeVC: SPBaseVC {
    fileprivate lazy var headerView : SPRechargeHeaderView = {
        let view = SPRechargeHeaderView()
        return view
    }()
    fileprivate lazy var footerView : SPRechargeFooterView = {
        let view = SPRechargeFooterView()
        return view
    }()
    fileprivate var tableView : UITableView!
    fileprivate var dataArray : [SPPayModel]?
    fileprivate var selectPay : SPPayModel?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.sp_setupUI()
        self.tableView.sp_layoutHeaderView()
        self.tableView.sp_layoutFooterView()
        sp_setupData()
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
    /// 赋值
    fileprivate func sp_setupData(){
        var data = [SPPayModel]()
        if SPThridManager.sp_isInstallWX() {
             let wxModel = SPPayModel()
            wxModel.app_display_name = "微信"
            wxModel.app_rpc_id = SPPayType.wxPay.rawValue
            data.append(wxModel)
        }
       
        let aliPayModel = SPPayModel()
        aliPayModel.app_display_name = "支付宝"
        aliPayModel.app_rpc_id = SPPayType.aliPay.rawValue
        data.append(aliPayModel)
        self.dataArray = data
        self.tableView.reloadData()
    }
    /// 创建UI
    override func sp_setupUI() {
        
        self.tableView = UITableView(frame: CGRect.zero, style: UITableViewStyle.plain)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.separatorStyle = .none
        self.tableView.backgroundColor = self.view.backgroundColor
        self.tableView.tableFooterView = self.footerView
        self.tableView.tableHeaderView = self.headerView
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
extension SPRechargeVC : UITableViewDelegate,UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sp_getArrayCount(array: self.dataArray) > 0 ? 1 : 0
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sp_getArrayCount(array: self.dataArray)
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let rechargeCellID = "rechargeCellID"
        var cell : SPRechargeTableCell? = tableView.dequeueReusableCell(withIdentifier: rechargeCellID) as? SPRechargeTableCell
        if cell == nil {
            cell = SPRechargeTableCell(style: UITableViewCellStyle.default, reuseIdentifier: rechargeCellID)
        }
        if indexPath.row < sp_getArrayCount(array: self.dataArray) {
            cell?.model = self.dataArray?[indexPath.row]
            if let pay = self.selectPay , let model = cell?.model{
                if sp_getString(string: pay.app_rpc_id) == sp_getString(string:  model.app_rpc_id) {
                    cell?.sp_isSelect(select: true)
                }else{
                    cell?.sp_isSelect(select: false)
                }
            }else{
                 cell?.sp_isSelect(select: false)
            }
            cell?.clickBlock = { [weak self] (model) in
                self?.selectPay = model
                self?.tableView.reloadData()
            }
        }
        return cell!
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row < sp_getArrayCount(array: self.dataArray) {
            self.selectPay = self.dataArray?[indexPath.row]
            tableView.reloadData()
        }
    }
    
}
