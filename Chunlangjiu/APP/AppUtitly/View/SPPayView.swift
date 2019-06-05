//
//  SPPayView.swift
//  Chunlangjiu
//
//  Created by 黄树鹏 on 2018/7/25.
//  Copyright © 2018年 Chunlang. All rights reserved.
//

import Foundation
import UIKit
import SnapKit


typealias SPPaySelectComplete = (_ payModel : SPPayModel?)->Void

class SPPayView:  UIView{
    
    var balanceStatus : SPBalanceStatus?{
        didSet{
            self.tableView.reloadData()
        }
    }
    fileprivate lazy var contentView : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        return view
    }()
    fileprivate lazy var tableView : UITableView = {
        let view = UITableView(frame: CGRect.zero, style: UITableViewStyle.plain)
        view.delegate = self
        view.dataSource = self
        view.rowHeight = 44
        view.separatorStyle = .none
        return view
    }()
    fileprivate lazy var topLayer : CALayer = {
        let layer = CALayer()
        layer.backgroundColor = SPColorForHexString(hex: SP_HexColor.color_333333.rawValue).cgColor
        return layer
    }()
    fileprivate lazy var titleLabel : UILabel = {
        let label = UILabel()
        label.font = sp_getFontSize(size: 14)
        label.textColor = SPColorForHexString(hex: SP_HexColor.color_ffffff.rawValue)
        label.text = "选择支付方式"
        return label
    }()
    fileprivate lazy var closeBtn : UIButton = {
        let btn = UIButton(type: UIButtonType.custom)
        btn.setImage(UIImage(named: "public_close_white"), for: UIControlState.normal)
        btn.addTarget(self, action: #selector(sp_clickCloseAction), for: UIControlEvents.touchUpInside)
        return btn
    }()
    fileprivate let topLayerHeight : CGFloat = 40
    var payDataArray : [SPPayModel]?{
        didSet{
            self.tableHeight.update(offset: self.tableView.rowHeight *  CGFloat(sp_getArrayCount(array: self.payDataArray)))
            self.tableView.reloadData()
        }
    }
    fileprivate var tableHeight : Constraint!
    var selectPayModel : SPPayModel?
    var selectBlock : SPPaySelectComplete?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = SPColorForHexString(hex: SP_HexColor.color_000000.rawValue).withAlphaComponent(0.5)
        self.sp_setupUI()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    @objc fileprivate func sp_clickCloseAction(){
        self.removeFromSuperview()
    }
    
    /// 添加UI
    fileprivate func sp_setupUI(){
        self.addSubview(self.contentView)
        self.contentView.layer.addSublayer(self.topLayer)
        self.contentView.addSubview(self.titleLabel)
        self.contentView.addSubview(self.closeBtn)
        self.contentView.addSubview(self.tableView)
        self.sp_addConstraint()
    }
    /// 添加约束
    fileprivate func sp_addConstraint(){
        self.contentView.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.snp.left).offset(33)
            maker.right.equalTo(self.snp.right).offset(-33)
            maker.height.greaterThanOrEqualTo(0)
            maker.top.greaterThanOrEqualTo(sp_getstatusBarHeight())
            maker.bottom.lessThanOrEqualTo(-SP_TABBAR_HEIGHT)
            maker.centerY.equalTo(self.snp.centerY).offset(0)
        }
        self.titleLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.contentView.snp.left).offset(10)
            maker.right.equalTo(self.closeBtn.snp.left).offset(-10)
            maker.top.equalTo(self.contentView).offset(0)
            maker.height.equalTo(topLayerHeight)
        }
        self.closeBtn.snp.makeConstraints { (maker) in
            maker.right.equalTo(self.contentView).offset(-10)
            maker.width.height.equalTo(16)
            maker.centerY.equalTo(self.titleLabel.snp.centerY).offset(0)
        }
        self.tableView.snp.makeConstraints { (maker) in
            maker.left.right.equalTo(self.contentView).offset(0)
            maker.top.equalTo(self.titleLabel.snp.bottom).offset(0)
            self.tableHeight = maker.height.equalTo(0).constraint
            maker.bottom.equalTo(self.contentView.snp.bottom).offset(-47)
        }
    }
    override func layoutSubviews() {
        self.topLayer.frame = CGRect(x: 0, y: 0, width: self.frame.size.width - 66, height: topLayerHeight)
    }
    
    deinit {
        
    }
}
extension SPPayView : UITableViewDelegate,UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sp_getArrayCount(array: self.payDataArray)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let payCellID = "payCellID"
        var cell : SPPayTableCell? = tableView.dequeueReusableCell(withIdentifier: payCellID) as? SPPayTableCell
        if cell == nil {
            cell = SPPayTableCell(style: UITableViewCellStyle.default, reuseIdentifier: payCellID)
        }
        if indexPath.row < sp_getArrayCount(array: self.payDataArray) {
            let payModel = self.payDataArray?[indexPath.row]
            cell?.payModel = payModel
            cell?.payContentLabel.text = ""
            if let select = selectPayModel {
                if sp_getString(string: select.app_rpc_id) == sp_getString(string: payModel?.app_rpc_id) {
                    cell?.sp_isSelect(select: true)
                }else{
                    cell?.sp_isSelect(select: false)
                }
            }else{
                cell?.sp_isSelect(select: false)
            }
            if sp_getString(string: payModel?.app_rpc_id) == SPPayType.balance.rawValue{
                if let status = self.balanceStatus {
                    if let isPwd : Bool = status.password , isPwd == false{
                        cell?.payContentLabel.text = "(未设置支付密码，请先设置)"
                    }
                }
            }
            
        }
        return cell!
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row < sp_getArrayCount(array: self.payDataArray)  {
            let payModel = self.payDataArray?[indexPath.row]
            if sp_getString(string: payModel?.app_rpc_id) == SPPayType.balance.rawValue{
                if let status = self.balanceStatus {
                    if let isPwd : Bool = status.password , isPwd == false{
                        sp_showTextAlert(tips: "没有设置密码")
                        return
                    }
                }
            }
            
            self.selectPayModel = payModel
            tableView.reloadData()
            guard let block = self.selectBlock else {
                return
            }
            block(payModel)
        }
    }
}

import UIKit
import SnapKit
class SPPayTableCell: UITableViewCell {
    
    fileprivate lazy var payImageView : UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    fileprivate lazy var payLabel : UILabel = {
        let label = UILabel()
        label.font = sp_getFontSize(size: 16)
        label.textColor = SPColorForHexString(hex: SP_HexColor.color_333333.rawValue)
        return label
    }()
    lazy var payContentLabel : UILabel = {
        let label = UILabel()
        label.font = sp_getFontSize(size: 14)
        label.textColor = SPColorForHexString(hex: SP_HexColor.color_999999.rawValue)
        return label
    }()
    fileprivate lazy var selectImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "public_select_green")
        return imageView
    }()
    fileprivate lazy var lineView : UIView = {
        return sp_getLineView()
    }()
    var payModel : SPPayModel?{
        didSet{
            self.sp_setupData()
        }
    }
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = UITableViewCellSelectionStyle.none
        self.sp_setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    /// 赋值
    fileprivate func sp_setupData(){
        self.payLabel.text = sp_getString(string: self.payModel?.app_display_name)
        sp_setPayImageName()
    }
    func sp_isSelect(select:Bool){
        self.selectImageView.isHidden = select ? false : true
    }
    fileprivate func sp_setPayImageName(){
        switch sp_getString(string: self.payModel?.app_rpc_id) {
        case SPPayType.wxPay.rawValue ,SPPayType.wxPing.rawValue :
            self.payImageView.image = UIImage(named: "public_pay_wx")
        case SPPayType.aliPay.rawValue , SPPayType.alipayPing.rawValue:
            self.payImageView.image = UIImage(named: "public_pay_ailpy")
        case SPPayType.aliPay.rawValue:
            self.payImageView.image = UIImage(named: "public_pay_transfer")
        case SPPayType.upacpPing.rawValue:
            self.payImageView.image = UIImage(named: "upacpPing")
        default:
            self.payImageView.image = UIImage(named: "public_pay_balance")
        }
        
    }
    
    /// 添加UI
    fileprivate func sp_setupUI(){
        self.contentView.addSubview(self.payImageView)
        self.contentView.addSubview(self.payLabel)
        self.contentView.addSubview(self.payContentLabel)
        self.contentView.addSubview(self.selectImageView)
        self.contentView.addSubview(self.lineView)
        self.sp_addConstraint()
    }
    /// 添加约束
    fileprivate func sp_addConstraint(){
        self.payImageView.snp.makeConstraints { (maker) in
            maker.left.equalTo(10)
            maker.width.equalTo(18)
            maker.height.equalTo(18)
            maker.centerY.equalTo(self.contentView.snp.centerY).offset(0)
        }
        self.payLabel.setContentHuggingPriority(UILayoutPriority.defaultHigh, for: UILayoutConstraintAxis.horizontal)
        self.payLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.payImageView.snp.right).offset(10)
            maker.top.bottom.equalTo(self.contentView).offset(0)
            maker.width.greaterThanOrEqualTo(0)
        }
        self.payContentLabel.setContentHuggingPriority(UILayoutPriority.defaultHigh, for: UILayoutConstraintAxis.horizontal)
        self.payContentLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.payLabel.snp.right).offset(4)
            maker.top.bottom.equalTo(self.contentView).offset(0)
            maker.right.equalTo(self.selectImageView.snp.right).offset(-8)
        }
        self.selectImageView.snp.makeConstraints { (maker) in
           maker.right.equalTo(self.contentView.snp.right).offset(-20)
            maker.width.equalTo(16)
            maker.height.equalTo(16)
            maker.centerY.equalTo(self.contentView.snp.centerY).offset(0)
        }
        self.lineView.snp.makeConstraints { (maker) in
            maker.left.right.bottom.equalTo(self.contentView).offset(0)
            maker.height.equalTo(sp_lineHeight)
        }
    }
    deinit {
        
    }
}
