//
//  SPCapitalDetDetVC.swift
//  Chunlangjiu
//
//  Created by 黄树鹏 on 2018/12/14.
//  Copyright © 2018 Chunlang. All rights reserved.
//

import Foundation
import SnapKit
class SPCapitalDetDetVC: SPBaseVC {
    fileprivate var tableView : UITableView!
    fileprivate lazy var headerView : SPCapitalDetDetHeaderView = {
        let view = SPCapitalDetDetHeaderView()
        return view
    }()
    fileprivate var dataArray : [SPCapitalDetDetModel] = [SPCapitalDetDetModel]()
    var model : SPCapitalDetModel?
    fileprivate var detModel : SPCapitalDetContentModel?
    var tyep : String?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.sp_setupUI()
        self.tableView.sp_layoutHeaderView()
        sp_showAnimation(view: self.view, title: "加载中...")
        sp_sendRequest()
        
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
        self.headerView.priceLabel.text = "\(sp_getString(string: SP_CHINE_MONEY))\(sp_getString(string: self.detModel?.fee))"
//        if sp_getString(string: self.detModel?.type) == SP_FUNDS_BILL_TYPE_DEFAULT || sp_getString(string: self.detModel?.type) == SP_FUNDS_BILL_TYPE_REFUND || sp_getString(string: self.detModel?.type).count == 0 {
//             self.dataArray.append(SPCapitalDetDetModel.sp_init(title: "商品名称", content: sp_getString(string: self.model?.message)))
//        }
        if sp_getString(string: self.detModel?.type) == SP_FUNDS_BILL_TYPE_RECHARGE || sp_getString(string: self.detModel?.type) == SP_FUNDS_BILL_TYPE_CASH {
              self.dataArray.append(SPCapitalDetDetModel.sp_init(title: "交易状态", content: sp_getString(string: self.detModel?.status)))
        }
       
        self.dataArray.append(SPCapitalDetDetModel.sp_init(title: "交易类型", content: sp_getString(string: self.detModel?.memo)))
        
        if sp_getString(string: self.detModel?.type) == SP_FUNDS_BILL_TYPE_RECHARGE{
            
            self.dataArray.append(SPCapitalDetDetModel.sp_init(title: "付款方式", content: sp_getString(string: self.detModel?.pay_name)))
        }
        if sp_getString(string: self.detModel?.type) == SP_FUNDS_BILL_TYPE_CASH {
             self.dataArray.append(SPCapitalDetDetModel.sp_init(title: "提现银行", content: sp_getString(string: self.detModel?.bank_name)))
        }
        
        self.dataArray.append(SPCapitalDetDetModel.sp_init(title: "订单编号", content: sp_getString(string: self.detModel?.id)))
        if sp_getString(string: self.detModel?.type) == SP_FUNDS_BILL_TYPE_CASH{
            self.dataArray.append(SPCapitalDetDetModel.sp_init(title: "申请时间", content: sp_getString(string: self.detModel?.showTime)))
             self.dataArray.append(SPCapitalDetDetModel.sp_init(title: "到帐时间", content: "一般2-3个工作日，具体到账时间以银行为准"))
        }else{
              self.dataArray.append(SPCapitalDetDetModel.sp_init(title: "创建时间", content: sp_getString(string: self.detModel?.showTime)))
        }
      
        // 充值
        self.tableView.reloadData()
        
    }
    /// 创建UI
    override func sp_setupUI() {
        self.navigationItem.title = "账单详情"
        self.tableView = UITableView(frame: CGRect.zero, style: UITableViewStyle.plain)
        self.tableView.separatorStyle = .none
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.tableHeaderView = self.headerView
        self.tableView.estimatedRowHeight = 50
        self.tableView.rowHeight = UITableViewAutomaticDimension
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
extension SPCapitalDetDetVC: UITableViewDelegate,UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sp_getArrayCount(array: self.dataArray) > 0 ? 1 : 0
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sp_getArrayCount(array: self.dataArray)
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let capitalDetDetCellID = "capitalDetDetCellID"
        var cell : SPCapitalDetDetTableCell? = tableView.dequeueReusableCell(withIdentifier: capitalDetDetCellID) as? SPCapitalDetDetTableCell
        if cell == nil {
            cell = SPCapitalDetDetTableCell(style: UITableViewCellStyle.default, reuseIdentifier: capitalDetDetCellID)
        }
        if indexPath.row < sp_getArrayCount(array: self.dataArray) {
            cell?.model = self.dataArray[indexPath.row]
        }
        return cell!
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
}
extension SPCapitalDetDetVC {
    
    fileprivate func sp_sendRequest(){
        if sp_getString(string: self.tyep) == SP_FUNDS_BILL_TYPE_FROZEN {
            sp_sendFreezeRequest()
        }else{
            var parm = [String : Any]()
            if let id = self.model?.log_id {
                parm.updateValue(id, forKey: "log_id")
            }
            self.requestModel.parm = parm
            SPFundsRequest.sp_getCapitalDetDet(requestModel: self.requestModel) { [weak self](code ,detModel, errorModel) in
                sp_hideAnimation(view: self?.view)
                if code == SP_Request_Code_Success {
                    self?.detModel = detModel
                    self?.sp_setupData()
                }else{
                    
                }
            }
        }
        
      
    }
    /// 发送冻结金额的请求
    fileprivate func sp_sendFreezeRequest(){
        var parm = [String : Any]()
        if let id = self.model?.log_id {
            parm.updateValue(id, forKey: "log_id")
        }
        self.requestModel.parm = parm
        SPFundsRequest.sp_getFreezeDet(requestModel: self.requestModel) { [weak self](code, detModel, errorModel) in
            sp_hideAnimation(view: self?.view)
            if code == SP_Request_Code_Success {
                self?.detModel = detModel
                self?.sp_setupData()
            }else{
                
            }
        }
    }
}
