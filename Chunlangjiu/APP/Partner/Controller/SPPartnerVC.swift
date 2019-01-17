//
//  SPPartnerVC.swift
//  Chunlangjiu
//
//  Created by 黄树鹏 on 2018/12/16.
//  Copyright © 2018 Chunlang. All rights reserved.
//

import Foundation
import SnapKit
class SPPartnerVC: SPBaseVC {
    fileprivate var tableView : UITableView!
    fileprivate var dataArray : [SPPartnerModel]?
    fileprivate var currentPage : Int = 1
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
        self.navigationItem.title = "城市合伙人服务中心"
        self.tableView = UITableView(frame: CGRect.zero, style: UITableViewStyle.plain)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.separatorStyle = .none
        self.tableView.backgroundColor = self.view.backgroundColor
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
        if sp_getArrayCount(array: self.dataArray) > 0  {
            self.noData.isHidden = true
        }else{
            self.noData.isHidden = false
            self.noData.text = "附近还没有城市合伙人哦"
            self.view.bringSubview(toFront: self.noData)
        }
        self.tableView.sp_stopFooterRefesh()
        self.tableView.sp_stopHeaderRefesh()
        self.tableView.reloadData()
    }
    /// 添加约束
    fileprivate func sp_addConstraint(){
        self.tableView.snp.makeConstraints { (maker) in
            maker.left.right.top.equalTo(self.view).offset(0)
            if #available(iOS 11.0, *) {
                maker.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(0)
            } else {
                // Fallback on earlier versions
            }
            maker.bottom.equalTo(self.view.snp.bottom).offset(0)
        }
    }
    deinit {
        
    }
}
extension SPPartnerVC : UITableViewDelegate,UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sp_getArrayCount(array: self.dataArray) > 0 ? 1 : 0
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sp_getArrayCount(array: self.dataArray)
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let partnerCellID = "partnerCellID"
        var cell : SPPartnerTableCell? = tableView.dequeueReusableCell(withIdentifier: partnerCellID) as? SPPartnerTableCell
        if cell == nil {
            cell = SPPartnerTableCell(style: UITableViewCellStyle.default, reuseIdentifier: partnerCellID)
            cell?.contentView.backgroundColor = self.view.backgroundColor
        }
        if indexPath.row < sp_getArrayCount(array: self.dataArray){
            cell?.model = self.dataArray?[indexPath.row]
            cell?.clickShopBlock = { [weak self] (model )in
                self?.sp_clickShop(model: model)
            }
        }
        return cell!
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0  {
            return  120
        }
        return 115
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
}
extension SPPartnerVC {
    fileprivate func sp_sendRequest(){
        var parm = [String : Any]()
        parm.updateValue(self.currentPage, forKey: "page_no")
        self.requestModel.parm = parm
        SPPartnerRequest.sp_getPartnerList(requestModel: self.requestModel) { [weak self](code, list, errorModel, total) in
            self?.sp_dealSuccess(code: code, list: list, errorModel: errorModel, total: total)
        }
    }
    fileprivate func sp_dealSuccess(code : String,list : Any? ,errorModel : SPRequestError?,total : Int){
        if code == SP_Request_Code_Success {
            if self.currentPage <= 1 {
                self.dataArray?.removeAll()
                if let array : [SPPartnerModel] = self.dataArray , let l : [SPPartnerModel] = list as? [SPPartnerModel] {
                    self.dataArray = array + l
                }else{
                    self.dataArray = list as? [SPPartnerModel]
                }
            }
        }
        sp_dealNoData()
       
    }
}
extension SPPartnerVC {
    fileprivate func sp_clickShop(model : SPPartnerModel?){
        if let pModel = model {
            let shopModel = SPShopModel()
            shopModel.shop_id = pModel.shop_id
            shopModel.shopname = pModel.shopname
            shopModel.shop_logo = pModel.shop_logo
            shopModel.shop_addr = pModel.shop_addr
            let shopVC = SPShopHomeVC()
            shopVC.shopModel = shopModel
            self.navigationController?.pushViewController(shopVC, animated: true)
        }
    }
    
}
