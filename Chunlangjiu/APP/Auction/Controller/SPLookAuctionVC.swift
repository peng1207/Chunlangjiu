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
        if sp_getArrayCount(array: self.dataArray) > 0 {
            self.noData.isHidden = true
        }else{
            self.noData.isHidden = false
            self.noData.text = "还没有人出价哦,赶紧去出价～"
            self.view.bringSubview(toFront: self.noData)
        }
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
            if indexPath.row == 0 {
                cell?.statusLabel.text = "领先"
                cell?.statusLabel.textColor = SPColorForHexString(hex: SP_HexColor.color_b31f3f.rawValue)
            }else{
                cell?.statusLabel.text = "落后"
                cell?.statusLabel.textColor = SPColorForHexString(hex: SP_HexColor.color_666666.rawValue)
            }
        }
        
        return cell!
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
}
extension SPLookAuctionVC{
    fileprivate func sp_sendRequest(){
        let request = SPRequestModel()
        var parm = [String : Any]()
        parm.updateValue(sp_getString(string: auctionitem_id), forKey: "auctionitem_id")
        
        request.parm = parm
        
        SPAppRequest.sp_getAuctionPriceList(requestModel: request) { [weak self](code , list, errorModel, total) in
            
            if code == SP_Request_Code_Success {
                self?.sp_dealRequest(list: list)
            }else{
                self?.sp_dealNoData()
            }
        }
    }
    fileprivate func sp_dealRequest(list:Any?){
        if self.currentPage == 1 {
            self.dataArray?.removeAll()
        }
        if let array :  Array<SPAuctionPrice> = self.dataArray ,let l : [SPAuctionPrice] = list as? [SPAuctionPrice]{
            self.dataArray = array + l
            if self.currentPage > 1 && sp_getArrayCount(array: l) <= 0 {
                self.currentPage = self.currentPage - 1
                if self.currentPage < 1 {
                    self.currentPage = 1
                }
            }
        }else{
            self.dataArray = list as? Array<SPAuctionPrice>
        }
        sp_mainQueue {
            self.tableView.reloadData()
        }
        self.sp_dealNoData()
    }
    
}
