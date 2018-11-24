//
//  SPShowRule.swift
//  Chunlangjiu
//
//  Created by 黄树鹏 on 2018/10/22.
//  Copyright © 2018年 Chunlang. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
class SPShowRule:  UIView{
    fileprivate lazy var titleLabel : UILabel = {
        let label = UILabel()
        label.font = sp_getFontSize(size: 14)
        label.textColor = SPColorForHexString(hex: SP_HexColor.color_666666.rawValue)
        label.text = "说明"
        label.textAlignment = .center
        return label
    }()
    fileprivate lazy var lineView : UIView = {
        return sp_getLineView()
    }()
    fileprivate lazy var contentLabel : UILabel = {
        let label = UILabel()
        label.font = sp_getFontSize(size: 14)
        label.textColor = SPColorForHexString(hex: SP_HexColor.color_333333.rawValue)
        label.numberOfLines = 0
        return label
    }()
    fileprivate lazy var contentView : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        return view
    }()
    fileprivate lazy var hideView : UIView = {
        let view = UIView()
        let tap = UITapGestureRecognizer(target: self, action: #selector(sp_remove))
        view.addGestureRecognizer(tap)
        return view
    }()
    fileprivate lazy var deleteBtn : UIButton = {
        let btn = UIButton(type: UIButtonType.custom)
        btn.setImage(UIImage(named: "public_delete_black"), for: UIControlState.normal)
        btn.addTarget(self, action: #selector(sp_remove), for: UIControlEvents.touchUpInside)
        return btn
    }()
    fileprivate lazy var scrollView : UIScrollView = {
        let view = UIScrollView()
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.sp_setupUI()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    class func sp_show(content : String?){
        let appdelete = UIApplication.shared.delegate as! AppDelegate
        let view = SPShowRule()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        view.contentLabel.text = sp_getString(string: content)
        appdelete.window?.addSubview(view)
        
        UIView.animate(withDuration: 0.3) {
            view.snp.makeConstraints({ (maker) in
                maker.left.right.top.equalTo(appdelete.window!).offset(0)
                if #available(iOS 11.0, *) {
                    maker.bottom.equalTo((appdelete.window?.safeAreaLayoutGuide.snp.bottom)!).offset(0)
                } else {
                     maker.bottom.equalTo((appdelete.window?.snp.bottom)!).offset(0)
                    // Fallback on earlier versions
                }
               
            })
        }
        
        
    }
    /// 添加UI
    fileprivate func sp_setupUI(){
        self.addSubview(self.hideView)
        self.addSubview(self.contentView)
        self.contentView.addSubview(self.titleLabel)
        self.contentView.addSubview(self.deleteBtn)
        self.contentView.addSubview(self.lineView)
        self.contentView.addSubview(self.scrollView)
        self.scrollView.addSubview(self.contentLabel)
        self.sp_addConstraint()
    }
    /// 添加约束
    fileprivate func sp_addConstraint(){
        self.hideView.snp.makeConstraints { (maker) in
            maker.left.top.bottom.right.equalTo(self).offset(0)
        }
        self.contentView.snp.makeConstraints { (maker) in
            maker.left.right.equalTo(self).offset(0)
            maker.top.equalTo(self).offset(150)
            if #available(iOS 11.0, *) {
                maker.bottom.equalTo(self.safeAreaLayoutGuide.snp.bottom).offset(0)
            } else {
                // Fallback on earlier versions
                 maker.bottom.equalTo(self.snp.bottom).offset(0)
            }
           
        }
        self.titleLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.contentView.snp.left).offset(10)
            maker.right.equalTo(self.contentView.snp.right).offset(-10)
            maker.height.equalTo(40)
            maker.top.equalTo(self.contentView).offset(0)
        }
        self.deleteBtn.snp.makeConstraints { (maker) in
            maker.width.height.equalTo(30)
            maker.centerY.equalTo(self.titleLabel.snp.centerY).offset(0)
            maker.right.equalTo(self.contentView.snp.right).offset(-10)
        }
        self.lineView.snp.makeConstraints { (maker) in
            maker.left.right.equalTo(self.contentView).offset(0)
            maker.top.equalTo(self.titleLabel.snp.bottom).offset(0)
            maker.height.equalTo(sp_heightOfScale(height: 2))
        }
        self.scrollView.snp.makeConstraints { (maker) in
            maker.left.right.bottom.equalTo(self.contentView).offset(0)
            maker.top.equalTo(self.lineView.snp.bottom).offset(0)
        }
        self.contentLabel.snp.makeConstraints { (maker) in
            maker.top.equalTo(self.scrollView).offset(5)
            
            maker.width.equalTo(self.scrollView).offset(-20)
            maker.height.greaterThanOrEqualTo(0)
            maker.centerX.equalTo(self.scrollView.snp.centerX).offset(0)
            maker.bottom.equalTo(self.scrollView).offset(-10)
        }
    }
    deinit {
        
    }
}
extension SPShowRule {
    @objc fileprivate func sp_remove(){
        self.removeFromSuperview()
    }
    
}
