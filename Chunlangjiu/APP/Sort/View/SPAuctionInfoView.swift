//
//  SPAuctionInfoView.swift
//  Chunlangjiu
//
//  Created by 黄树鹏 on 2018/12/29.
//  Copyright © 2018 Chunlang. All rights reserved.
//
// 拍卖说明
import Foundation
import UIKit
import SnapKit
class SPAuctionInfoView:  UIView{
    fileprivate lazy var titleLabel : UILabel = {
        let label = UILabel()
        label.font = sp_getFontSize(size: 15)
        label.textColor = SPColorForHexString(hex: SP_HexColor.color_333333.rawValue)
        label.textAlignment = .center
        label.text = "拍卖说明"
        return label
    }()
    fileprivate lazy var joinView : UIView = {
        let view = sp_setupView(img: UIImage(named: "public_auction_join"), title: "参与出价")
        return view
    }()
    fileprivate lazy var maxView : UIView = {
        let view = sp_setupView(img: UIImage(named: "public_auction_max"), title: "价高者得")
        return view
    }()
    fileprivate lazy var payView : UIView = {
        let view = sp_setupView(img: UIImage(named: "public_auction_pay"), title: "支付货款")
        return view
    }()
    fileprivate lazy var getView : UIView = {
        let view = sp_setupView(img: UIImage(named: "public_auction_get"), title: "获得拍品")
        return view
    }()
    fileprivate lazy var joinImgView : UIImageView = {
        let view = sp_setupNext()
        return view
    }()
    fileprivate lazy var maxImgView : UIImageView = {
        let view = sp_setupNext()
        return view
    }()
    fileprivate lazy var payImgView : UIImageView = {
        let view = sp_setupNext()
        return view
    }()
    fileprivate func sp_setupView(img:UIImage?,title:String?)->UIView{
        let view = UIView()
        let imgView = UIImageView(image: img)
        view.addSubview(imgView)
        let label = UILabel()
        label.font = sp_getFontSize(size: 13)
        label.textColor = SPColorForHexString(hex: SP_HexColor.color_333333.rawValue)
        label.textAlignment = .center
        label.text = sp_getString(string: title)
        view.addSubview(label)
        imgView.snp.makeConstraints { (maker) in
            maker.width.equalTo(34)
            maker.height.equalTo(34)
            maker.top.equalTo(view).offset(19)
            maker.centerX.equalTo(view).offset(0)
        }
        label.snp.makeConstraints { (maker) in
            maker.left.right.equalTo(view).offset(0)
            maker.height.greaterThanOrEqualTo(0)
            maker.top.equalTo(imgView.snp.bottom).offset(10)
        }
        return view
    }
    fileprivate lazy var lineView : UIView = {
        return sp_getLineView()
    }()
    fileprivate func sp_setupNext()->UIImageView{
        let imgView = UIImageView()
        imgView.image = UIImage(named: "public_next")
        return imgView
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.sp_setupUI()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    /// 添加UI
    fileprivate func sp_setupUI(){
        self.addSubview(self.titleLabel)
        self.addSubview(self.lineView)
        self.addSubview(self.joinView)
        self.addSubview(self.joinImgView)
        self.addSubview(self.maxView)
        self.addSubview(self.maxImgView)
        self.addSubview(self.payView)
        self.addSubview(self.payImgView)
        self.addSubview(self.getView)
        
        self.sp_addConstraint()
    }
    /// 添加约束
    fileprivate func sp_addConstraint(){
        self.titleLabel.snp.makeConstraints { (maker) in
            maker.left.right.top.equalTo(self).offset(0)
            maker.height.equalTo(40)
        }
        self.lineView.snp.makeConstraints { (maker) in
            maker.left.right.equalTo(self).offset(0)
            maker.height.equalTo(sp_lineHeight)
            maker.top.equalTo(self.titleLabel.snp.bottom).offset(0)
        }
        self.joinView.snp.makeConstraints { (maker) in
            maker.left.equalTo(self).offset(14)
            maker.top.equalTo(self.lineView.snp.bottom).offset(0)
            maker.bottom.equalTo(self).offset(0)
            maker.width.equalTo(self.maxView).offset(0)
        }
        self.joinImgView.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.joinView.snp.right).offset(12)
            maker.width.equalTo(19)
            maker.height.equalTo(12)
            maker.centerY.equalTo(self.snp.centerY).offset(0)
        }
        self.maxView.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.joinImgView.snp.right).offset(12)
            maker.top.bottom.equalTo(self.joinView).offset(0)
            maker.width.equalTo(self.payView).offset(0)
        }
        self.maxImgView.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.maxView.snp.right).offset(12)
            maker.width.height.centerY.equalTo(self.joinImgView).offset(0)
        }
        self.payView.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.maxImgView.snp.right).offset(12)
            maker.top.bottom.equalTo(self.maxView).offset(0)
            maker.width.equalTo(self.getView).offset(0)
        }
        self.payImgView.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.payView.snp.right).offset(12)
            maker.centerY.height.width.equalTo(self.maxImgView).offset(0)
        }
        self.getView.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.payImgView.snp.right).offset(12)
            maker.right.equalTo(self.snp.right).offset(-13)
            maker.top.bottom.equalTo(self.maxView).offset(0)
        }
    }
    deinit {
        
    }
}
