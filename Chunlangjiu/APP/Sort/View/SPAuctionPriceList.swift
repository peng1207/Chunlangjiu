//
//  SPAuctionPriceList.swift
//  Chunlangjiu
//
//  Created by 黄树鹏 on 2018/9/10.
//  Copyright © 2018年 Chunlang. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
class SPAuctionPriceList:  UIView{
    fileprivate lazy var hideView : UIView = {
        let view = UIView()
        let tap = UITapGestureRecognizer(target: self, action: #selector(sp_remove))
        view.addGestureRecognizer(tap)
        return view
    }()
    fileprivate lazy var contentView : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        view.sp_cornerRadius(cornerRadius: 5)
        return view
    }()
    fileprivate var tableView : UITableView!
    fileprivate var dataArray : [SPAuctionPrice]?
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.sp_setupUI()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    class func sp_show(list : [SPAuctionPrice]?){
     let view = SPAuctionPriceList()
        view.dataArray = list
        view.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        let appDelegate : AppDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window?.addSubview(view)
        view.snp.makeConstraints { (maker) in
            maker.left.right.top.bottom.equalTo(appDelegate.window!).offset(0)
        }
    }
    /// 添加UI
    fileprivate func sp_setupUI(){
        self.addSubview(self.hideView)
        self.addSubview(self.contentView)
        self.tableView = UITableView(frame: CGRect.zero, style: UITableViewStyle.plain)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.rowHeight = 44
        self.tableView.separatorStyle = .none
        self.contentView.addSubview(self.tableView)
        self.sp_addConstraint()
    }
    /// 添加约束
    fileprivate func sp_addConstraint(){
        self.hideView.snp.makeConstraints { (maker) in
            maker.left.right.top.bottom.equalTo(self).offset(0)
        }
        self.contentView.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.snp.left).offset(20)
            maker.right.equalTo(self.snp.right).offset(-20)
            maker.height.equalTo(260)
            maker.centerY.equalTo(self.snp.centerY).offset(0)
        }
        self.tableView.snp.makeConstraints { (maker) in
            maker.left.top.right.bottom.equalTo(self.contentView).offset(0)
        }
    }
    @objc fileprivate func sp_remove(){
        self.removeFromSuperview()
    }
    deinit {
        
    }
}
extension SPAuctionPriceList : UITableViewDelegate,UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return sp_getArrayCount(array: self.dataArray) > 0 ? 1 : 0
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sp_getArrayCount(array: self.dataArray)
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let auctionPriceListCellID = "auctionPriceListCellID"
        var cell : UITableViewCell? = tableView.dequeueReusableCell(withIdentifier: auctionPriceListCellID)
        if cell == nil{
            cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: auctionPriceListCellID)
            cell?.textLabel?.textColor = SPColorForHexString(hex: SP_HexColor.color_333333.rawValue)
            cell?.selectionStyle = .none
            let lineView = sp_getLineView()
            cell?.contentView.addSubview(lineView)
            lineView.snp.makeConstraints { (maker) in
                maker.left.right.bottom.equalTo((cell?.contentView)!).offset(0)
                maker.height.equalTo(sp_lineHeight)
            }
        }
        if indexPath.row < sp_getArrayCount(array: self.dataArray) {
            let model = self.dataArray?[indexPath.row]
            let mAtt = NSMutableAttributedString()
            mAtt.append(NSAttributedString(string: sp_getString(string: model?.mobile), attributes: [NSAttributedStringKey.font : sp_getFontSize(size: 14), NSAttributedStringKey.foregroundColor : SPColorForHexString(hex: SP_HexColor.color_333333.rawValue)]));
            mAtt.append(NSAttributedString(string: "(\(SP_CHINE_MONEY)\(sp_getString(string: model?.price)))", attributes: [NSAttributedStringKey.font : sp_getFontSize(size: 14),NSAttributedStringKey.foregroundColor : SPColorForHexString(hex: SP_HexColor.color_b31f3f.rawValue)]))
            cell?.textLabel?.attributedText = mAtt
        }
        return cell!
    }
}
