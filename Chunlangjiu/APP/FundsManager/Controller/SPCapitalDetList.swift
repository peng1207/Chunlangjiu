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
    fileprivate var currentPage : Int = 1
    var type : String?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.sp_setupUI()
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
    /// 创建UI
    override func sp_setupUI() {
        self.tableView = UITableView(frame: CGRect.zero, style: UITableViewStyle.grouped)
        self.tableView.separatorStyle = .none
        self.tableView.backgroundColor = self.view.backgroundColor
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.sp_headerRefesh { [weak self] in
            self?.currentPage = 1
            self?.sp_sendRequest()
        }
        self.tableView.sp_footerRefresh { [weak self] in
            if let page = self?.currentPage {
                self?.currentPage = page + 1
                self?.sp_sendRequest()
            }
        }
        self.view.addSubview(self.tableView)
        self.sp_addConstraint()
    }
    /// 处理有没数据
    override func sp_dealNoData(){
        if sp_getArrayCount(array: self.dataArray) > 0 {
            self.noData.isHidden = true
        }else{
            self.noData.isHidden = false
            self.noData.text = "您还没交易过哦"
             self.view.bringSubview(toFront: self.noData)
        }

        self.tableView.sp_stopFooterRefesh()
        self.tableView.sp_stopHeaderRefesh()
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
            detVC.model = self.dataArray?[indexPath.section]
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
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
       return nil
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    
}
extension SPCapitalDetList {
    
    fileprivate func sp_sendRequest(){
        var parm = [String : Any]()
        parm.updateValue(self.currentPage, forKey: "page_no")
        parm.updateValue(sp_getString(string: self.type), forKey: "type")
        self.requestModel.parm = parm
        SPFundsRequest.sp_getCapitalDetList(requestModel: self.requestModel) { [weak self](code, list, errorModel,total) in
            self?.sp_dealSuccess(code: code, list: list, errorModel: errorModel, total: total)
        }
    }
    fileprivate func sp_dealSuccess(code : String,list : [Any]?,errorModel : SPRequestError?,total:Int){
        if code == SP_Request_Code_Success {
            if self.currentPage <= 1 {
                self.dataArray?.removeAll()
            }
            if let array : [SPCapitalDetModel] = self.dataArray, let l : [SPCapitalDetModel] = list as? [SPCapitalDetModel]{
                self.dataArray = array + l
            }else{
                self.dataArray = list as? [SPCapitalDetModel]
            }
            self.tableView.reloadData()
        }else{
            if self.currentPage > 1 {
                self.currentPage = self.currentPage - 1
            }
        }
        self.sp_dealNoData()
    }
}
