//
//  SPFansListVC.swift
//  Chunlangjiu
//
//  Created by 黄树鹏 on 2018/12/14.
//  Copyright © 2018 Chunlang. All rights reserved.
//

import Foundation
import SnapKit
class SPFansListVC: SPBaseVC {
    fileprivate var tableView : UITableView!
    fileprivate lazy var headerView : SPFansListHeadView = {
        let view = SPFansListHeadView()
        view.backgroundColor = self.view.backgroundColor
        return view
    }()
    fileprivate lazy var shareBtn : UIButton = {
        let btn = UIButton(type: UIButtonType.custom)
        btn.setTitle("一键分享赢粉丝佣金", for: UIControlState.normal)
        btn.titleLabel?.font = sp_getFontSize(size: 15)
        btn.setTitleColor(SPColorForHexString(hex: SP_HexColor.color_ffffff.rawValue), for: UIControlState.normal)
        btn.backgroundColor = SPColorForHexString(hex: SP_HexColor.color_b31f3f.rawValue)
        btn.sp_cornerRadius(cornerRadius: 5)
        btn.addTarget(self, action: #selector(sp_share), for: UIControlEvents.touchUpInside)
        return btn
    }()
    fileprivate var dataArray : [SPFansListModel]?
    fileprivate var currentPage : Int = 1
    override func viewDidLoad() {
        super.viewDidLoad()
        self.sp_setupUI()
        self.tableView.sp_layoutHeaderView()
        sp_sendFansRequest()
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
        self.navigationItem.title = "粉丝列表"
        self.tableView = UITableView(frame: CGRect.zero, style: UITableViewStyle.grouped)
        self.tableView.delegate = self
         self.tableView.dataSource = self
        self.tableView.separatorStyle = .none
        self.tableView.tableHeaderView = self.headerView
        self.tableView.tableFooterView = UIView()
        self.tableView.backgroundColor = self.view.backgroundColor
        self.tableView.sp_headerRefesh { [weak self]in
            self?.currentPage = 1
            self?.sp_sendRequest()
            self?.sp_sendFansRequest()
        }
        self.tableView.sp_footerRefresh { [weak self]in
            if let page = self?.currentPage {
                self?.currentPage = page + 1
                 self?.sp_sendRequest()
            }
        }
        self.view.addSubview(self.tableView)
        self.view.addSubview(self.shareBtn)
        self.sp_addConstraint()
    }
    var shareUrl : String? 
    
    /// 处理有没数据
    override func sp_dealNoData(){
        self.tableView.reloadData()
        self.tableView.sp_stopFooterRefesh()
        self.tableView.sp_stopHeaderRefesh()
        if sp_getArrayCount(array: self.dataArray) > 0 {
            self.noData.isHidden = true
        }else{
            self.noData.isHidden = false
            self.noData.text = "您还没有粉丝哦，赶紧分享邀请"
            self.view.bringSubview(toFront: self.noData)
        }
    }
    /// 添加约束
    fileprivate func sp_addConstraint(){
        self.tableView.snp.makeConstraints { (maker) in
                maker.left.right.top.equalTo(self.view).offset(0)
            maker.bottom.equalTo(self.shareBtn.snp.top).offset(-10)
        }
        self.shareBtn.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.view).offset(10)
            maker.right.equalTo(self.view).offset(-10)
            maker.height.equalTo(45)
            if #available(iOS 11.0, *) {
                maker.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(-10)
            } else {
                  maker.bottom.equalTo(self.view.snp.bottom).offset(-10)
            }
        }
        
    }
    deinit {
        
    }
}
extension SPFansListVC : UITableViewDelegate,UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sp_getArrayCount(array: self.dataArray) > 0 ? 1 : 0
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sp_getArrayCount(array: self.dataArray)
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let fansListCellID = "fansListCellID"
        var cell : SPFansListTableCell? = tableView.dequeueReusableCell(withIdentifier: fansListCellID) as? SPFansListTableCell
        if  cell == nil{
            cell = SPFansListTableCell(style: UITableViewCellStyle.default, reuseIdentifier: fansListCellID)
        }
        if indexPath.row < sp_getArrayCount(array: self.dataArray) {
            cell?.model = self.dataArray?[indexPath.row]
        }
        return cell!
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let fansListHeadID = "fansListHeadID"
        var view : SPFansListSectionView? = tableView.dequeueReusableHeaderFooterView(withIdentifier: fansListHeadID) as? SPFansListSectionView
        if view == nil {
            view = SPFansListSectionView(reuseIdentifier: fansListHeadID)
        }
        return  view
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
}
extension SPFansListVC {
    @objc fileprivate func sp_share(){
        let shareDataModel = SPShareDataModel()
        shareDataModel.shareData = sp_getString(string: self.shareUrl).count > 0 ? sp_getString(string: self.shareUrl) :  SP_SHARE_URL
        shareDataModel.title = sp_getString(string: "给您推荐高端酒综合服务平台-醇狼")
        shareDataModel.descr = sp_getString(string: "")
        shareDataModel.currentViewController = self
        shareDataModel.thumbImage = sp_getAppIcon()
        shareDataModel.placeholderImage =  sp_getAppIcon()
        SPShareManager.sp_share(shareDataModel: shareDataModel) { (model, error) in
            
        }
    }
    
}
extension SPFansListVC {
    fileprivate func sp_sendRequest(){
        var parm = [String : Any]()
        parm.updateValue(self.currentPage, forKey: "page_no")
        self.requestModel.parm = parm
        SPFansRequest.sp_getFansList(requestModel: self.requestModel) { [weak self](code, list, errorMode, total) in
            self?.sp_dealRequestSuccess(code: code, list: list, errorModel: errorMode, total: total)
        }
    }
    fileprivate func sp_dealRequestSuccess(code: String,list : Any?,errorModel : SPRequestError?,total : Int){
        if code == SP_Request_Code_Success {
            if self.currentPage <= 1{
                self.dataArray?.removeAll()
            }
            if let array : [SPFansListModel] = self.dataArray , let l : [SPFansListModel] = list as? [SPFansListModel] {
                self.dataArray = array + l
            }else{
                self.dataArray = list as? [SPFansListModel]
            }
        }
        sp_dealNoData()
    }
    
    fileprivate func sp_sendFansRequest(){
        let parm = [String :Any]()
        let rModel = SPRequestModel()
        rModel.parm = parm
        SPFansRequest.sp_getFansNum(requestModel: rModel) { [weak self](code, msg, model, errorModel) in
            if code == SP_Request_Code_Success{
                self?.headerView.fansModel = model
            }
        }
    }
    
}

