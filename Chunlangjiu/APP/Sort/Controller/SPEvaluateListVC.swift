//
//  SPEvaluateListVC.swift
//  Chunlangjiu
//
//  Created by 黄树鹏 on 2018/7/9.
//  Copyright © 2018年 Chunlang. All rights reserved.
//

import Foundation
import SnapKit

typealias SPEvaluateGetDataComplet = (_ list : [SPEvaluateModel]?,_ total : Int)->Void

class SPEvaluateListVC: SPBaseVC {
    fileprivate var tableView : UITableView!
    fileprivate var dataArray : Array<SPEvaluateModel>?
    fileprivate var currentPage = 1
    var skuID : Int!
    var getDataBlock : SPEvaluateGetDataComplet?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.sp_setupUI()
        self.sp_sendRequest()
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
        self.navigationItem.title = "评价列表"
        self.tableView = UITableView(frame: CGRect.zero, style: UITableViewStyle.plain)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.backgroundColor = self.view.backgroundColor
        self.tableView.separatorStyle = .none
        
        self.tableView.estimatedRowHeight = 90
        self.tableView.estimatedSectionHeaderHeight = 0
        self.tableView.estimatedSectionFooterHeight = 0
        self.tableView.tableFooterView = UIView()
         self.tableView.tableHeaderView = UIView()
        self.tableView.rowHeight = UITableViewAutomaticDimension
        if #available(iOS 11.0, *) {
            self.tableView.contentInsetAdjustmentBehavior = .never
        } else {
            // Fallback on earlier versions
        }
        self.tableView.sp_headerRefesh { [weak self]()in
            self?.currentPage = 1
            self?.sp_sendRequest()
        }
        self.tableView.sp_footerRefresh { [weak self]()in
            if let page = self?.currentPage {
                self?.currentPage = page + 1
                self?.sp_sendRequest()
            }
          
        }
        self.view.addSubview(self.tableView)
        self.sp_addConstraint()
    }
    override func sp_dealNoData() {
        self.tableView.sp_stopHeaderRefesh()
        sp_asyncAfter(time: 1) {
           
            self.tableView.sp_stopFooterRefesh()
        }
        if sp_getArrayCount(array: self.dataArray) > 0  {
            self.noData.isHidden = true
        }else{
            self.noData.isHidden = false
            self.noData.text = "还没有相关评价哦!"
            self.view.bringSubview(toFront: self.noData)
        }
    }
    /// 添加约束
    fileprivate func sp_addConstraint(){
        self.tableView.snp.makeConstraints { (maker) in
            maker.left.top.right.equalTo(self.view).offset(0)
            if #available(iOS 11.0, *) {
                maker.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(0)
            } else {
                  maker.bottom.equalTo(self.view.snp.bottom).offset(0)
            }
         
        }
    }
    deinit {
        self.tableView.delegate = nil
        self.tableView.dataSource = nil
        self.tableView.sp_removeAllRefesh()
    }
}
extension SPEvaluateListVC : UITableViewDataSource,UITableViewDelegate{
    func numberOfSections(in tableView: UITableView) -> Int {
        return sp_getArrayCount(array: self.dataArray) > 0 ? 1 : 0
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sp_getArrayCount(array: self.dataArray)
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let evaluateCellID = "evaluateCellID"
        var cell : SPEvaluateTableCell? = tableView.dequeueReusableCell(withIdentifier: evaluateCellID) as? SPEvaluateTableCell
        if cell == nil {
            cell = SPEvaluateTableCell(style: UITableViewCellStyle.default, reuseIdentifier: evaluateCellID)
        }
        if indexPath.row < sp_getArrayCount(array: self.dataArray) {
            cell?.evaluateModel = self.dataArray?[indexPath.row]
        }
        return cell!
    }
   
}
extension SPEvaluateListVC {
    func sp_sendRequest(){
        var parm = [String : Any]()
        if let i = skuID {
            parm.updateValue(i, forKey: "item_id")
        }else{
            return
        }
        parm.updateValue(0, forKey: "rate_type")
        parm.updateValue(self.currentPage, forKey: "page_no")
        parm.updateValue(10, forKey: "page_size")
        self.requestModel.parm = parm
        SPAppRequest.sp_getEvaluate(requestModel: self.requestModel) {  [weak self](errorCode, list, errorModel, totalPage) in
            self?.sp_dealRequest(errorCode: errorCode, list: list, errorModel: errorModel, totalPage: totalPage)
        }
    }
    fileprivate func sp_dealRequest(errorCode:String,list:[Any]?,errorModel:SPRequestError?,totalPage :Int){
        if errorCode == SP_Request_Code_Success {
            if self.currentPage == 1 {
                self.dataArray?.removeAll()
            }
            if let array : Array<SPEvaluateModel> = self.dataArray,let l : [SPEvaluateModel] = list as? Array<SPEvaluateModel>{
                self.dataArray = array + l
            }else{
                self.dataArray = list as? Array<SPEvaluateModel>
            }
            if self.currentPage == 1 {
                sp_dealComplete(total: totalPage)
            }
            self.tableView.reloadData()
        
        }else{
            self.currentPage = self.currentPage - 1
            if self.currentPage < 1 {
                self.currentPage = 1
            }
        }
        sp_dealNoData()
    }
    
    fileprivate func sp_dealComplete(total : Int){
        guard let block = self.getDataBlock else {
            return
        }
        block(self.dataArray,total)
    }
    
}
