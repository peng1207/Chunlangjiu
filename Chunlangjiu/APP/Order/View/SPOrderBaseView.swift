//
//  SPOrderBaseView.swift
//  Chunlangjiu
//
//  Created by chengzong liang on 2018/8/30.
//  Copyright © 2018年 Chunlang. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
class SPOrderBaseView:  UIView{
    fileprivate lazy var codeView : SPOrderContentView = {
        let view = SPOrderContentView()
        view.backgroundColor = UIColor.white
        view.titleLabel.text = "订单编号："
        return view
    }()
    fileprivate lazy var copyBtn : UIButton = {
        let btn = UIButton(type: UIButtonType.custom)
        btn.setTitle("复制", for: UIControlState.normal)
        btn.titleLabel?.font = sp_getFontSize(size: 12)
        btn.setTitleColor(UIColor.white, for: UIControlState.normal)
        btn.backgroundColor = SPColorForHexString(hex: SP_HexColor.color_ff9600.rawValue)
        btn.sp_cornerRadius(cornerRadius: 10)
        btn.addTarget(self, action: #selector(sp_clickCopyAction), for: UIControlEvents.touchUpInside)
        return btn
    }()
    fileprivate lazy var orderTimeView : SPOrderContentView = {
        let view = SPOrderContentView()
        view.backgroundColor = UIColor.white
        view.titleLabel.text = "下单时间："
        return view
    }()
    fileprivate lazy var auctionView : SPOrderContentView = {
        let view = SPOrderContentView()
        view.backgroundColor = UIColor.white
        view.titleLabel.text = "中标时间："
        view.isHidden = true
        return view
    }()
    fileprivate var auctionTop : Constraint!
    var detaileModel : SPOrderDetaileModel?{
        didSet{
            self.sp_setupData()
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.sp_setupUI()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    /// 赋值
    fileprivate func sp_setupData(){
        self.codeView.contentLabel.text = sp_getString(string: self.detaileModel?.tid)
        self.orderTimeView.contentLabel.text = sp_getString(string: self.detaileModel?.created_time)
        if sp_getString(string: detaileModel?.type) == SP_AUCTION {
            if sp_getString(string: detaileModel?.status) == SP_AUCTION_2{
                self.auctionView.titleLabel.text = "中标时间："
                self.auctionTop.update(offset: 26)
                self.auctionView.contentLabel.text = sp_getString(string: detaileModel?.modified_time)
                self.auctionView.isHidden = false
            }else if sp_getString(string: detaileModel?.status) == SP_AUCTION_3{
                self.auctionView.titleLabel.text = "竞拍结束："
                 self.auctionTop.update(offset: 26)
                 self.auctionView.contentLabel.text = sp_getString(string: detaileModel?.modified_time)
                 self.auctionView.isHidden = false
            }else{
                self.auctionTop.update(offset: 0)
                self.auctionView.contentLabel.text = ""
                 self.auctionView.isHidden = true
            }
        }else{
             self.auctionTop.update(offset: 0)
             self.auctionView.contentLabel.text = ""
             self.auctionView.isHidden = true
        }
    }
    /// 添加UI
    fileprivate func sp_setupUI(){
        self.addSubview(self.codeView)
        self.addSubview(self.copyBtn)
        self.addSubview(self.orderTimeView)
        self.addSubview(self.auctionView)
        self.sp_addConstraint()
    }
    /// 添加约束
    fileprivate func sp_addConstraint(){
        self.codeView.snp.makeConstraints { (maker) in
            maker.left.right.equalTo(self).offset(0)
            maker.top.equalTo(self).offset(13)
           maker.height.greaterThanOrEqualTo(0)
        }
        self.copyBtn.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.codeView.contentLabel.snp.right).offset(5)
            maker.centerY.equalTo(self.codeView.snp.centerY).offset(0)
            maker.width.equalTo(50)
            maker.height.equalTo(21)
        }
        self.orderTimeView.snp.makeConstraints { (maker) in
            maker.left.right.equalTo(self.codeView).offset(0)
            maker.top.equalTo(self.codeView.snp.bottom).offset(26)
            maker.height.greaterThanOrEqualTo(0)
        }
        self.auctionView.snp.makeConstraints { (maker) in
            maker.left.right.equalTo(self).offset(0)
            maker.height.greaterThanOrEqualTo(0)
            self.auctionTop = maker.top.equalTo(self.orderTimeView.snp.bottom).offset(0).constraint
             maker.bottom.equalTo(self).offset(-10)
        }
    }
    deinit {
        
    }
}
extension SPOrderBaseView {
    
    @objc fileprivate func sp_clickCopyAction(){
        //就这两句话就实现了
        let paste = UIPasteboard.general
        paste.string = sp_getString(string: self.detaileModel?.tid)
        sp_showTextAlert(tips: "复制成功")
    }
    
}
