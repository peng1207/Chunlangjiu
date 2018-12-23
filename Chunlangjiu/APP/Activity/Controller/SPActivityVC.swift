//
//  SPActivityVC.swift
//  Chunlangjiu
//
//  Created by 黄树鹏 on 2018/12/6.
//  Copyright © 2018 Chunlang. All rights reserved.
//

import Foundation
import SnapKit
class SPActivityVC: SPBaseVC {
    
    fileprivate var tableView : UITableView!
    fileprivate var dataArray : [SPActivityModel]?
    fileprivate lazy var headerView : SPActivityHeaderView = {
        let view = SPActivityHeaderView()
        view.frame = CGRect(x: 0, y: 0, width: sp_getScreenWidth(), height: sp_getScreenWidth() * 0.835)
        return view
    }()
    fileprivate lazy var footerView : SPActivityFooterView = {
        let view = SPActivityFooterView()
        view.frame = CGRect(x: 0, y: 0, width: sp_getScreenWidth(), height: sp_getScreenWidth() * 0.533 + 41.0)
        return view
    }()
     fileprivate var pushVC : Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()
        self.sp_setupUI()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: self.pushVC ? true : false)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
         self.pushVC = false
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    /// 创建UI
    override func sp_setupUI() {
        self.tableView = UITableView(frame: CGRect.zero, style: UITableViewStyle.grouped)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.separatorStyle = .none
        self.tableView.backgroundColor = self.view.backgroundColor
        self.tableView.tableHeaderView = self.headerView
        self.tableView.tableFooterView = self.footerView
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
extension SPActivityVC : UITableViewDelegate,UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sp_getArrayCount(array: self.dataArray)
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section < sp_getArrayCount(array: self.dataArray) {
            let model = self.dataArray?[section]
            return sp_getArrayCount(array: model?.list)
        }
        return 0
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var model : SPActivityModel?
        var productModel : SPProductModel?
        if indexPath.section < sp_getArrayCount(array: self.dataArray) {
            model = self.dataArray?[indexPath.section]
            if indexPath.row < sp_getArrayCount(array: model?.list){
                productModel = model?.list?[indexPath.row]
            }
        }
        if let p = productModel, p.isAuction {
            let activityAuctionCellID = "activityAuctionCellID"
            var cell : SPAuctionTableCell? = tableView.dequeueReusableCell(withIdentifier: activityAuctionCellID) as? SPAuctionTableCell
            if cell == nil {
                cell = SPAuctionTableCell(style: UITableViewCellStyle.default, reuseIdentifier: activityAuctionCellID)
            }
            cell?.auctionView.productModel = p
            return cell!
        }else{
            let activityCellID = "activityCellID"
            var cell : SPProductTableCell? = tableView.dequeueReusableCell(withIdentifier: activityCellID) as? SPProductTableCell
            if cell == nil {
                cell = SPProductTableCell(style: UITableViewCellStyle.default, reuseIdentifier: activityCellID)
            }
            cell?.productView.productModel = productModel
            return cell!
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var model : SPActivityModel?
        var productModel : SPProductModel?
        if indexPath.section < sp_getArrayCount(array: self.dataArray) {
            model = self.dataArray?[indexPath.section]
            if indexPath.row < sp_getArrayCount(array: model?.list){
                productModel = model?.list?[indexPath.row]
            }
        }
        if let p = productModel, p.isAuction {
            return indexPath.row == 0 ? 175 : 180
        }else{
            return indexPath.row == 0 ? 150 : 155
        }
        
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 67
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let activitySectionHeaderID = "activitySectionHeaderID"
        var headerView : SPActivitySectionView? = tableView.dequeueReusableHeaderFooterView(withIdentifier: activitySectionHeaderID) as? SPActivitySectionView
        if headerView == nil {
            headerView = SPActivitySectionView(reuseIdentifier: activitySectionHeaderID)
        }
        if section < sp_getArrayCount(array: self.dataArray) {
            let model = self.dataArray?[section]
            headerView?.titleLabel.text = sp_getString(string:model?.title)
        }
        return headerView
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var model : SPActivityModel?
        var productModel : SPProductModel?
        if indexPath.section < sp_getArrayCount(array: self.dataArray) {
            model = self.dataArray?[indexPath.section]
            if indexPath.row < sp_getArrayCount(array: model?.list){
                productModel = model?.list?[indexPath.row]
            }
        }
        if let p = productModel {
            let detVC = SPProductDetaileVC()
            detVC.productModel = p
            self.navigationController?.pushViewController(detVC, animated: true)
            self.pushVC = true
        }
        
    }
    
}
