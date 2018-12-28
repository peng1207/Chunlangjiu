//
//  SPBankCardVC.swift
//  Chunlangjiu
//
//  Created by 黄树鹏 on 2018/12/11.
//  Copyright © 2018 Chunlang. All rights reserved.
//

import Foundation
import SnapKit
typealias SPSelectBandCardComplete = (_ model : SPBankCardModel?)->Void
class SPBankCardVC: SPBaseVC {
    
    fileprivate lazy var addBtn : UIButton = {
        let btn = UIButton(type: UIButtonType.custom)
        btn.setTitle("添加银行卡", for: UIControlState.normal)
        btn.setTitleColor(SPColorForHexString(hex: SP_HexColor.color_ffffff.rawValue), for: UIControlState.normal)
        btn.backgroundColor = SPColorForHexString(hex: SP_HexColor.color_b31f3f.rawValue)
        btn.sp_cornerRadius(cornerRadius: 5)
        btn.titleLabel?.font = sp_getFontSize(size: 15)
        btn.addTarget(self, action: #selector(sp_clickAdd), for: UIControlEvents.touchUpInside)
        return btn
    }()
    fileprivate var tableView : UITableView!
    fileprivate var dataArray : [SPBankCardModel]?
    var selectBlock : SPSelectBandCardComplete?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.sp_setupUI()
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
        self.navigationItem.title = "我的银行卡"
        self.tableView = UITableView(frame: CGRect.zero, style: UITableViewStyle.plain)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.separatorStyle = .none
        self.tableView.backgroundColor = self.view.backgroundColor
        self.view.addSubview(self.tableView)
        self.view.addSubview(self.addBtn)
        self.sp_addConstraint()
    }
    /// 处理有没数据
    override func sp_dealNoData(){
        
    }
    /// 添加约束
    fileprivate func sp_addConstraint(){
        self.tableView.snp.makeConstraints { (maker) in
            maker.left.right.top.equalTo(self.view).offset(0)
            maker.bottom.equalTo(self.addBtn.snp.top).offset(-10)
        }
        self.addBtn.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.view).offset(10)
            maker.right.equalTo(self.view).offset(-10)
            maker.height.equalTo(40)
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
extension SPBankCardVC {
    @objc fileprivate func sp_clickAdd(){
        let addVC = SPAddBankCardVC()
        self.navigationController?.pushViewController(addVC, animated: true)
    }
    
}
extension SPBankCardVC : UITableViewDelegate,UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sp_getArrayCount(array: self.dataArray) > 0 ? 1 : 0
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sp_getArrayCount(array: self.dataArray)
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let bankCardCellID = "bankCardCellID"
        var cell : SPBankCardTableCell? = tableView.dequeueReusableCell(withIdentifier: bankCardCellID) as? SPBankCardTableCell
        if cell == nil {
            cell = SPBankCardTableCell(style: UITableViewCellStyle.default, reuseIdentifier: bankCardCellID)
        }
        if indexPath.row < sp_getArrayCount(array: self.dataArray) {
            cell?.model = self.dataArray?[indexPath.row]
        }
        return cell!
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 160
        }
        return 155
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let block = self.selectBlock  else {
            return
        }
        if indexPath.row < sp_getArrayCount(array: self.dataArray) {
            block(self.dataArray?[indexPath.row])
        }
    }
    
}
