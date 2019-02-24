//
//  SPCanceReasonView.swift
//  Chunlangjiu
//
//  Created by 黄树鹏 on 2018/9/2.
//  Copyright © 2018年 Chunlang. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
typealias SPCanceReasonComplete = (_ select : String)-> Void
class SPCanceReasonView:  UIView{
    fileprivate lazy var contentView : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        return view
    }()
    fileprivate var tableView : UITableView!
    fileprivate lazy var canceBtn : UIButton = {
        let btn = UIButton(type: UIButtonType.custom)
        btn.setTitle("取消", for: UIControlState.normal)
        btn.setTitleColor(SPColorForHexString(hex: SP_HexColor.color_666666.rawValue), for: UIControlState.normal)
        btn.titleLabel?.font = sp_getFontSize(size: 18)
        btn.addTarget(self, action: #selector(sp_clickCance), for: UIControlEvents.touchUpInside)
        btn.sp_border(color: SPColorForHexString(hex: SP_HexColor.color_666666.rawValue), width: sp_lineHeight)
        btn.sp_cornerRadius(cornerRadius: 20)
        return btn
    }()
    fileprivate lazy var doneBtn : UIButton = {
        let btn = UIButton(type: UIButtonType.custom)
        btn.setTitle("确定", for: UIControlState.normal)
        btn.setTitleColor(SPColorForHexString(hex: SP_HexColor.color_b31f3f.rawValue), for: UIControlState.normal)
       
        btn.addTarget(self, action: #selector(sp_clickDone), for: UIControlEvents.touchUpInside)
        btn.sp_border(color: SPColorForHexString(hex: SP_HexColor.color_b31f3f.rawValue), width: sp_lineHeight)
        btn.sp_cornerRadius(cornerRadius: 20)
        return btn
    }()
    fileprivate var listData : [String]?
    fileprivate var selectString : String?
    fileprivate var selectBlock : SPCanceReasonComplete?
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        self.sp_setupUI()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    class func sp_show(list:[String]?,complete : SPCanceReasonComplete?){
        let view = SPCanceReasonView()
        view.listData = list
        view.selectBlock = complete
        let appdelegate : AppDelegate = UIApplication.shared.delegate as! AppDelegate
        appdelegate.window?.addSubview(view)
        view.snp.makeConstraints { (maker) in
            maker.left.right.top.bottom.equalTo(appdelegate.window!).offset(0)
        }
    }
    
    /// 添加UI
    fileprivate func sp_setupUI(){
        self.addSubview(self.contentView)
        self.tableView = UITableView(frame: CGRect.zero, style: UITableViewStyle.plain)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.rowHeight = 44
        self.tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: sp_lineHeight))
        self.contentView.addSubview(self.tableView)
        self.contentView.addSubview(self.canceBtn)
        self.contentView.addSubview(self.doneBtn)
        self.sp_addConstraint()
    }
    /// 添加约束
    fileprivate func sp_addConstraint(){
        self.contentView.snp.makeConstraints { (maker) in
            maker.left.equalTo(self).offset(20)
            maker.right.equalTo(self).offset(-20)
            maker.top.equalTo(self).offset(80)
            if #available(iOS 11.0, *) {
                maker.bottom.equalTo(self.safeAreaLayoutGuide.snp.bottom).offset(-80)
            } else {
                maker.bottom.equalTo(self.snp.bottom).offset(-80)
            }
           
        }
        self.tableView.snp.makeConstraints { (maker) in
            maker.left.right.top.equalTo(self.contentView).offset(0)
            maker.bottom.equalTo(self.canceBtn.snp.top).offset(-5)
        }
        self.canceBtn.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.contentView).offset(10)
            maker.bottom.equalTo(self.contentView).offset(-10)
            maker.height.equalTo(40)
            maker.width.equalTo(self.doneBtn.snp.width).offset(0)
        }
        self.doneBtn.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.canceBtn.snp.right).offset(10)
            maker.right.equalTo(self.contentView).offset(-10)
            maker.bottom.equalTo(self.canceBtn.snp.bottom).offset(0)
            maker.height.equalTo(self.canceBtn.snp.height).offset(0)
        }
    }
    deinit {
        self.tableView.delegate = nil
        self.tableView.dataSource = nil
    }
}
extension SPCanceReasonView : UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return sp_getArrayCount(array: self.listData) > 0 ? 1 : 0
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sp_getArrayCount(array: self.listData)
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let canceReasonCellID = "canceReasonCellID"
        var cell : UITableViewCell? = tableView.dequeueReusableCell(withIdentifier: canceReasonCellID)
        if  cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: canceReasonCellID)
            cell?.selectionStyle = .none
        }
        if indexPath.row < sp_getArrayCount(array: self.listData) {
            let string  = self.listData?[indexPath.row]
            cell?.textLabel?.text = sp_getString(string: string)
            if sp_getString(string: string) == sp_getString(string: self.selectString){
                cell?.textLabel?.textColor = SPColorForHexString(hex: SP_HexColor.color_b31f3f.rawValue)
            }else{
                cell?.textLabel?.textColor = SPColorForHexString(hex: SP_HexColor.color_333333.rawValue)
            }
        }
        return cell!
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row < sp_getArrayCount(array: self.listData) {
            selectString = self.listData?[indexPath.row]
            tableView.reloadData()
        }
    }
}
extension SPCanceReasonView{
    @objc fileprivate func sp_clickCance(){
        self.removeFromSuperview()
    }
    @objc fileprivate func sp_clickDone(){
        if sp_getString(string: self.selectString).count == 0 {
            sp_showTextAlert(tips: "请选择取消原因")
        }
        
        guard let block = self.selectBlock else {
            return
        }
        block(sp_getString(string: self.selectString))
        sp_clickCance()
    }
}

