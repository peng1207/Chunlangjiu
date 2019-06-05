//
//  SPAddressVC.swift
//  Chunlangjiu
//
//  Created by 黄树鹏 on 2018/7/6.
//  Copyright © 2018年 Chunlang. All rights reserved.
//

import Foundation
import SnapKit

/// 地址选择的回调
typealias SPAdressSelectBlock = (_ model : SPAddressModel?) ->Void

class SPAddressVC: SPBaseVC {
    fileprivate var tableView : UITableView!
    fileprivate var dataArray : Array<SPAddressModel>?
    fileprivate lazy var addBtn : UIButton = {
        let btn = UIButton(type: UIButtonType.custom)
        btn.setTitle("添加地址", for: UIControlState.normal)
        btn.setTitleColor(SPColorForHexString(hex: SP_HexColor.color_666666.rawValue), for: UIControlState.normal)
        btn.backgroundColor = UIColor.white
        btn.titleLabel?.font = sp_getFontSize(size: 16)
        btn.frame = CGRect(x: 0, y: 0, width: sp_getScreenWidth(), height: 44)
        btn.addTarget(self, action: #selector(sp_clickAddAction), for: UIControlEvents.touchUpInside)
        btn.setImage(UIImage(named: "public_add_gray"), for: UIControlState.normal)
        return btn
    }()
    fileprivate lazy var noDataLabel : UILabel = {
        let label = UILabel()
        label.text = "您没有添加过地址，请添加一个吧!"
        label.textAlignment = NSTextAlignment.center
        label.font = sp_getFontSize(size: 14)
        label.textColor = SPColorForHexString(hex: SP_HexColor.color_333333.rawValue)
        label.frame = CGRect(x: 0, y: 0, width: sp_getScreenWidth(), height: 40)
        return label
    }()
    var addressModel : SPAddressModel?
    var selectBlock : SPAddressSelectBlock?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.sp_setupUI()
        self.dealNoData()
       
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
         sp_sendRequest()
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
        self.tableView.rowHeight = 84
        self.tableView.separatorStyle = .none
        self.tableView.delegate = self
        self.tableView.dataSource = self;
        self.tableView.backgroundColor = self.view.backgroundColor
        self.tableView.sp_headerRefesh { [weak self]()in
            self?.sp_sendRequest()
        }
        self.view.addSubview(self.tableView)
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
        
    }
}
//MARK: - 请求 数据处理
extension SPAddressVC {
    fileprivate func dealNoData(){
        if sp_getArrayCount(array: self.dataArray) > 0  {
            self.tableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: sp_getScreenWidth(), height: sp_lineHeight))
        }else{
            self.tableView.tableHeaderView = self.noDataLabel
        }
        self.tableView.tableFooterView = self.addBtn
    }
}
//MARK: - delegate
extension SPAddressVC:UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return sp_getArrayCount(array: self.dataArray)
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let addressCellID = "addressCellID"
        var cell : SPAddressTableCell? = tableView.dequeueReusableCell(withIdentifier: addressCellID) as? SPAddressTableCell
        if cell == nil {
            cell = SPAddressTableCell(style: UITableViewCellStyle.default, reuseIdentifier: addressCellID)
        }
        if indexPath.section < sp_getArrayCount(array: self.dataArray) {
            cell?.addressModel = (self.dataArray?[indexPath.section])
            if let selectModel = self.addressModel, let m = cell?.addressModel {
                if selectModel.addr_id == m.addr_id {
                    cell?.select = true
                }else{
                    cell?.select = false
                }
            }else{
                cell?.select = false
            }
        }
        cell?.editBlock = { [weak self](addressModel : SPAddressModel?) in
            self?.sp_clickEditAction(addressModel: addressModel)
        }
        return cell!
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 54
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let addressFooterID = "addressFooterID"
        var footerView : SPAddressFooterView? = tableView.dequeueReusableHeaderFooterView(withIdentifier: addressFooterID) as? SPAddressFooterView
        if footerView == nil{
            footerView = SPAddressFooterView(reuseIdentifier: addressFooterID)
        }
        if section < sp_getArrayCount(array: self.dataArray){
            footerView?.addressModel =  (self.dataArray?[section])
        }
        footerView?.deleteBlock = { [weak self](addressModel : SPAddressModel?) in
            self?.sp_clickDeleteAction(addressModel: addressModel)
        }
        footerView?.selectBlock = {  [weak self](addressModel : SPAddressModel?) in
            self?.sp_clickSelectAction(addressModel: addressModel)
        }
        return footerView
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section < sp_getArrayCount(array: self.dataArray) {
            self.sp_dealSelectComplete(model: (self.dataArray?[indexPath.section]))
           
        }
    }
}

extension SPAddressVC {
    fileprivate func sp_dealSelectComplete(model:SPAddressModel?,needPop : Bool = true){
        self.addressModel = model
        guard let block = self.selectBlock else{
            return
        }
        block(model)
        if needPop {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    /// 点击添加事件
    @objc fileprivate func sp_clickAddAction(){
        let addVC = SPAddAdressVC()
        addVC.title = "添加地址"
        self.navigationController?.pushViewController(addVC, animated: true)
    }
    fileprivate func sp_clickEditAction(addressModel : SPAddressModel?){
        guard let model = addressModel else {
            return
        }
        let editVC = SPAddAdressVC()
        editVC.addressModel = model
        editVC.title = "编辑地址"
        self.navigationController?.pushViewController(editVC, animated: true)
    }
    fileprivate func sp_clickDeleteAction(addressModel : SPAddressModel?){
        guard let model : SPAddressModel = addressModel else {
            return
        }
        sp_showAlertClick(vc: self, title: "提示", msg: "是否删除该地址?", cance: "取消", done: "删除", canceComplete: {
            
        }) { [weak self]() in
            self?.sp_sendDeleteRequest(model: model)
        }
    }
    fileprivate func sp_clickSelectAction(addressModel : SPAddressModel?){
        guard let model = addressModel else {
            return
        }
       
        self.sp_sendDefaultRequest(model: model)
    }
    /// 获取地址列表数据
    fileprivate func sp_sendRequest(){
        SPAppRequest.sp_getAddressList(requestModel: self.requestModel) { (code, list, errorModel, totalPage) in
            self.sp_dealRequest(code: code, list: list, errorModel: errorModel, totalPage: totalPage)
        }
    }
    fileprivate func sp_dealRequest(code:String,list:[Any]?,errorModel:SPRequestError?,totalPage:Int){
        if code == SP_Request_Code_Success {
            self.dataArray = list as? Array<SPAddressModel>
            if sp_getArrayCount(array: self.dataArray) > 0 ,let selectModel = self.addressModel{
                var isExist = false
                for addModel in self.dataArray!{
                    if addModel.addr_id == selectModel.addr_id {
                        self.addressModel = addModel
                        isExist = true
                        break
                    }
                }
                if isExist == false {
                    self.sp_dealSelectComplete(model: nil,needPop: false)
                }
            }
            
            
        }
        self.tableView.sp_stopHeaderRefesh()
        self.dealNoData()
        self.tableView.reloadData()
    }
    /// 发送删除请求
    ///
    /// - Parameter model: 删除的数据
    fileprivate func sp_sendDeleteRequest(model : SPAddressModel){
        sp_showAnimation(view: self.view, title: "删除中")
        let deleteRequest = SPRequestModel()
        var parm = [String:Any]()
        parm.updateValue(sp_getString(string: model.addr_id), forKey: "addr_id")
        deleteRequest.parm = parm
        SPAppRequest.sp_getDeleteAddress(requestModel: deleteRequest) { [weak self](code, msg, errorModel) in
            sp_hideAnimation(view: self?.view)
            if code == SP_Request_Code_Success {
                // 删除成功
                self?.sp_sendRequest()
                sp_showTextAlert(tips: "删除成功")
                if let selectModel = self?.addressModel {
                    if selectModel.addr_id == model.addr_id {
                        self?.sp_dealSelectComplete(model: nil,needPop: false)
                    }
                }
                
            }else{
                // 删除失败
                sp_showTextAlert(tips: msg)
            }
        }
        
    }
    /// 发送设置默认的请求
    ///
    /// - Parameter model: 设置默认的数据
    fileprivate func sp_sendDefaultRequest(model:SPAddressModel){
         sp_showAnimation(view: self.view, title: "")
        let defaultRequest = SPRequestModel()
        var parm = [String:Any]()
        parm.updateValue(sp_getString(string: model.addr_id), forKey: "addr_id")
        defaultRequest.parm = parm
        SPAppRequest.sp_getDefaultAddress(requestModel: defaultRequest) { [weak self](code, msg, errorModel) in
            sp_hideAnimation(view: self?.view)
            if code  == SP_Request_Code_Success {
                // 删除成功
                self?.sp_sendRequest()
            }else{
                // 删除失败
            }
        }
    }
}
