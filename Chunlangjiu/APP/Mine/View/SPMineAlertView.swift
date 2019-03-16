//
//  SPMineAlertView.swift
//  Chunlangjiu
//
//  Created by 黄树鹏 on 2019/3/13.
//  Copyright © 2019 Chunlang. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
class SPMineAlertView:  UIView{
    
    fileprivate lazy var hiddenView : UIView = {
        let view = UIView()
        
        return view
    }()
    fileprivate lazy var contentView : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        view.sp_cornerRadius(cornerRadius: 5)
        return view
    }()
    
    fileprivate lazy var imgView : UIImageView = {
        let view = UIImageView()
        return view
    }()
    fileprivate lazy var titleLabel : UILabel = {
        let label = UILabel()
        label.font = sp_getFontSize(size: 12)
        label.textColor = SPColorForHexString(hex: SP_HexColor.color_333333.rawValue)
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    fileprivate lazy var contentLabel : UILabel = {
        let label = UILabel()
        label.font = sp_getFontSize(size: 10)
        label.textColor = SPColorForHexString(hex: SP_HexColor.color_333333.rawValue)
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    fileprivate lazy var doneBtn : UIButton = {
        let btn = UIButton(type: UIButtonType.custom)
        btn.setTitleColor(SPColorForHexString(hex: SP_HexColor.color_ffffff.rawValue), for: UIControlState.normal)
        btn.backgroundColor = SPColorForHexString(hex: SP_HexColor.color_b31f3f.rawValue)
        btn.titleLabel?.font = sp_getFontSize(size: 12)
        btn.sp_cornerRadius(cornerRadius: 5)
        btn.addTarget(self, action: #selector(sp_clickDone), for: UIControlEvents.touchUpInside)
        return btn
    }()
    fileprivate var complete : SPBtnClickBlock?
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.sp_setupUI()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    class func sp_showView(title:String,content:String,btnTitle:String,isSuccess:Bool,complete:SPBtnClickBlock?){
        let view = SPMineAlertView()
        view.titleLabel.text = title
        view.complete = complete
        view.backgroundColor = SPColorForHexString(hex: SP_HexColor.color_000000.rawValue).withAlphaComponent(0.3)
        let att = NSMutableAttributedString(string: sp_getString(string: content))
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 4.0
        paragraphStyle.alignment = .center
        att.addAttributes([NSAttributedStringKey.paragraphStyle : paragraphStyle], range: NSRange(location: 0, length: att.length))
        view.contentLabel.attributedText = att
        view.doneBtn.setTitle(sp_getString(string: btnTitle), for: UIControlState.normal)
        if isSuccess {
            view.imgView.image = UIImage(named: "public_bond_success")
        }else{
            view.imgView.image = UIImage(named: "public_revoke")
        }
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window?.addSubview(view)
        view.snp.makeConstraints { (maker) in
            maker.left.right.top.bottom.equalTo(appDelegate.window!).offset(0)
        }
        
    }
    /// 添加UI
    fileprivate func sp_setupUI(){
        self.addSubview(self.hiddenView)
        self.addSubview(self.contentView)
        self.contentView.addSubview(self.imgView)
        self.contentView.addSubview(self.titleLabel)
        self.contentView.addSubview(self.contentLabel)
        self.contentView.addSubview(self.doneBtn)
        let tap = UITapGestureRecognizer(target: self, action: #selector(sp_clickRemove))
        self.hiddenView.addGestureRecognizer(tap)
        self.sp_addConstraint()
    }
    /// 添加约束
    fileprivate func sp_addConstraint(){
        self.hiddenView.snp.makeConstraints { (maker) in
            maker.left.right.bottom.top.equalTo(self).offset(0)
        }
        self.contentView.snp.makeConstraints { (maker) in
            maker.left.equalTo(self).offset(10)
            maker.right.equalTo(self).offset(-10)
            maker.height.greaterThanOrEqualTo(0)
            maker.centerY.equalTo(self.snp.centerY).offset(0)
        }
        self.imgView.snp.makeConstraints { (maker) in
            maker.width.height.equalTo(34)
            maker.centerX.equalTo(self.contentView).offset(0)
            maker.top.equalTo(self.contentView).offset(20)
        }
        self.titleLabel.snp.makeConstraints { (maker) in
            maker.width.greaterThanOrEqualTo(0)
            maker.centerX.equalTo(self.contentView.snp.centerX).offset(0)
            maker.top.equalTo(self.imgView.snp.bottom).offset(20)
            maker.height.greaterThanOrEqualTo(0)
        }
        self.contentLabel.snp.makeConstraints { (maker) in
            maker.width.greaterThanOrEqualTo(0)
            maker.left.greaterThanOrEqualTo(self.contentView).offset(10)
            maker.right.lessThanOrEqualTo(self.contentView).offset(-10)
            maker.centerX.equalTo(self.contentView.snp.centerX).offset(0)
            maker.height.greaterThanOrEqualTo(0)
            maker.top.equalTo(self.titleLabel.snp.bottom).offset(22)
        }
        self.doneBtn.snp.makeConstraints { (maker) in
            maker.centerX.equalTo(self.contentView.snp.centerX).offset(0)
            maker.top.equalTo(self.contentLabel.snp.bottom).offset(23)
            maker.width.equalTo(80)
            maker.height.equalTo(25)
            maker.bottom.equalTo(self.contentView.snp.bottom).offset(-25)
        }
    }
    deinit {
        
    }
}
extension SPMineAlertView {
    @objc fileprivate func sp_clickDone(){
        guard let block = self.complete else {
            sp_clickRemove()
            return
        }
        block()
        sp_clickRemove()
    }
    @objc fileprivate func sp_clickRemove(){
        self.removeFromSuperview()
    }
}
