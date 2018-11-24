//
//  SPWinerySearchVC.swift
//  Chunlangjiu
//
//  Created by 黄树鹏 on 2018/7/8.
//  Copyright © 2018年 Chunlang. All rights reserved.
//

import Foundation
import SnapKit
class SPWineryListVC: SPBaseVC {
    
    fileprivate lazy var headerView : SPWineryListHeaderView = {
        let view = SPWineryListHeaderView()
        view.frame = CGRect(x: 0, y: 0, width: sp_getScreenWidth(), height: 44)
        return view
    }()
    fileprivate var tableView : UITableView!
    fileprivate lazy var searchView : SPSearchView = {
        let view = SPSearchView(frame: CGRect(x: 0, y: 0, width: sp_getScreenWidth() - 120, height: 30))
        return view
    }()
    fileprivate lazy var searchBtn : UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "public_search_white"), for: UIControlState.normal)
        btn.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        btn.addTarget(self, action: #selector(sp_clickSearchAction), for: UIControlEvents.touchUpInside)
        return btn
    }()
    var sortModel : SPWinerSortModel?
    fileprivate var dataArray : [SPWinerModel]?
    fileprivate var currentPage = 1
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = sp_getString(string: sortModel?.chateaucat_name)
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
    override func sp_dealNoData() {
        if sp_getArrayCount(array: self.dataArray) > 0 {
            self.noData.isHidden = true
        }else{
            self.noData.isHidden = false
            self.noData.text = "没有找到相关酒庄"
           self.view.bringSubview(toFront: self.noData)
        }
    }
    /// 创建UI
    override func sp_setupUI() {
    self.tableView = UITableView(frame: CGRect.zero, style: UITableViewStyle.grouped)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.separatorStyle = .none
        self.tableView.rowHeight = 44
//        self.tableView.backgroundColor = UIColor.white
        self.tableView.sectionFooterHeight = 0
        self.tableView.sectionHeaderHeight = 0
//        self.tableView.tableHeaderView = self.headerView
        self.view.addSubview(self.tableView)
//        self.navigationItem.titleView = self.searchView
//        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: self.searchBtn)
        self.sp_addConstraint()
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
    }
}
extension SPWineryListVC : UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return sp_getArrayCount(array: self.dataArray) > 0 ? 1 : 0
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sp_getArrayCount(array: self.dataArray)
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let wineryListCellID = "wineryListCellID"
        var cell : SPWineryListTableCell? = tableView.dequeueReusableCell(withIdentifier: wineryListCellID) as? SPWineryListTableCell
        if cell == nil {
            cell = SPWineryListTableCell(style: UITableViewCellStyle.default, reuseIdentifier: wineryListCellID)
        }
        if indexPath.row < sp_getArrayCount(array: self.dataArray) {
            cell?.wineryModel = self.dataArray?[indexPath.row]
        }
        return cell!
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let wineryListHeaderID = "wineryListHeaderID"
        var view : SPWineryListSectionHeaderView? = tableView.dequeueReusableHeaderFooterView(withIdentifier: wineryListHeaderID) as?  SPWineryListSectionHeaderView
        if view == nil {
            view = SPWineryListSectionHeaderView(reuseIdentifier: wineryListHeaderID)
            view?.contentView.backgroundColor = UIColor.white
        }
        view?.titleLabel.text = sp_getString(string: self.sortModel?.chateaucat_name)
        return view
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row < sp_getArrayCount(array: self.dataArray){
            let detaileVC = SPWineryDetaileVC()
            detaileVC.wineryModel = self.dataArray?[indexPath.row]
            self.navigationController?.pushViewController(detaileVC, animated: true)
        }
    }
}
extension SPWineryListVC {
    @objc fileprivate func sp_clickSearchAction(){
        
    }
    fileprivate func sp_sendRequest(){
        sp_showAnimation(view: self.view, title: nil)
        var parm = [String:Any]()
        parm.updateValue(self.sortModel?.chateaucat_id ?? 0 , forKey: "chateaucat_id")
        parm.updateValue(10, forKey: "page_size")
        parm.updateValue(self.currentPage, forKey: "page_no")
        self.requestModel.parm = parm
        SPAppRequest.sp_getWinerList(requestModel: self.requestModel) { [weak self](code , list, errorModel, total) in
            self?.sp_dealRequest(code: code, list: list, errorModel: errorModel, total: total)
        }
    }
    fileprivate func sp_dealRequest(code:String,list : [Any]?,errorModel : SPRequestError?,total: Int) {
        sp_hideAnimation(view: self.view)
        if code == SP_Request_Code_Success {
            if self.currentPage == 1 {
                self.dataArray?.removeAll()
            }
            if let array :  Array<SPWinerModel> = self.dataArray ,let l : [SPWinerModel] = list as? [SPWinerModel]{
                self.dataArray = array + l
            }else{
                self.dataArray = list as? Array<SPWinerModel>
            }
        }
        self.tableView.reloadData()
//        self.tableView.sp_stopFooterRefesh()
//        self.tableView.sp_stopHeaderRefesh()
        sp_dealNoData()
    }
}
