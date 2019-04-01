//
//  SPUpdateView.swift
//  Chunlangjiu
//
//  Created by chengzong liang on 2018/11/1.
//  Copyright © 2018年 Chunlang. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

class SPUpdateView : UIView {
    fileprivate lazy var contentView : UIView = {
        let view = UIView()
 
        return view
    }()
    fileprivate lazy var topImgView : UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "public_update")?.resizableImage(withCapInsets: UIEdgeInsetsMake(130, 0, 42, 0), resizingMode: UIImageResizingMode.stretch)
        return view
    }()
    fileprivate lazy var scrollViewContentView : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        view.layer.shadowColor = SPColorForHexString(hex: SP_HexColor.color_999999.rawValue).cgColor
        view.layer.shadowOpacity = 1
        view.layer.shadowOffset = CGSize(width: 0, height: 0)
        view.layer.shadowRadius = 5
        view.layer.cornerRadius = 6
        return view
    }()
    fileprivate lazy var scrollView : UIScrollView = {
        let view = UIScrollView()
        view.showsVerticalScrollIndicator = false
        view.sp_cornerRadius(cornerRadius: 6)
        return view
    }()
 
    fileprivate lazy var messageLabel : UILabel = {
        let label = UILabel()
        label.font = sp_getFontSize(size: 10)
        label.textColor = SPColorForHexString(hex: SP_HexColor.color_666666.rawValue)
        label.numberOfLines = 0
        return label
    }()
    fileprivate lazy var canceBtn : UIButton = {
        let btn = UIButton(type: UIButtonType.custom)
        btn.setImage(UIImage(named: "public_close_cor"), for: UIControlState.normal)
        btn.addTarget(self, action: #selector(sp_cance), for: UIControlEvents.touchUpInside)
        btn.sp_cornerRadius(cornerRadius: 5)
        return btn
    }()
    fileprivate lazy var doneBtn : UIButton = {
        let btn = UIButton(type: UIButtonType.custom)
        btn.setTitle("立即更新", for: UIControlState.normal)
        btn.setTitleColor(SPColorForHexString(hex: SP_HexColor.color_ffffff.rawValue), for: UIControlState.normal)
        btn.backgroundColor = SPColorForHexString(hex: SP_HexColor.color_b31f3f.rawValue)
        btn.titleLabel?.font = sp_getFontSize(size: 12)
        btn.addTarget(self, action: #selector(sp_done), for: UIControlEvents.touchUpInside)
          btn.sp_cornerRadius(cornerRadius: 14)
        return btn
    }()
    fileprivate var model : SPUpdateModel?{
        didSet{
            self.sp_setupUI()
            self.sp_setupData()
        }
    }
    fileprivate var height : Constraint!
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    /// 检查是否需要更新
    ///
    /// - Parameter model: 获取到的数据
    /// - Returns: 是否更新
    class func sp_checkUpdate(model :SPUpdateModel?)->Bool{
        var isUpdate = false
        guard let m = model else {
            return isUpdate
        }
        
        let infoDic : [String : Any]?  = Bundle.main.infoDictionary
        if let dic = infoDic {
            let versionCode = dic["versionCode"]
            if  sp_getString(string: versionCode).compare(sp_getString(string: m.versions)) ==   ComparisonResult.orderedAscending {
                isUpdate = true
            }
        }
        
        return isUpdate
    }
    
    class func sp_show(model:SPUpdateModel?){
        if sp_checkUpdate(model: model) {
            let view = SPUpdateView()
            view.backgroundColor = UIColor.black.withAlphaComponent(0.3)
            view.model = model
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.window?.addSubview(view)
            view.snp.makeConstraints { (maker) in
                maker.left.right.top.equalTo(appDelegate.window!).offset(0)
                if #available(iOS 11.0, *) {
                    maker.bottom.equalTo((appDelegate.window?.safeAreaLayoutGuide.snp.bottom)!).offset(0)
                } else {
                    // Fallback on earlier versions
                      maker.bottom.equalTo((appDelegate.window?.snp.bottom)!).offset(0)
                }
              
            }
        }
    }
    
    fileprivate func sp_setupData(){
        let att = NSMutableAttributedString()
    
        att.append(NSAttributedString(string: sp_getString(string: self.model?.message), attributes: [NSAttributedStringKey.font : sp_getFontSize(size: 10),NSAttributedStringKey.foregroundColor : SPColorForHexString(hex: SP_HexColor.color_666666.rawValue)]))
        let par = NSMutableParagraphStyle()
        par.lineSpacing = 5
        att.addAttributes([NSAttributedStringKey.paragraphStyle : par], range: NSRange(location: 0, length: att.length))
        self.messageLabel.attributedText = att
        self.canceBtn.isHidden = sp_isForce() ? true : false
        let frame =  self.messageLabel.textRect(forBounds: CGRect(x: 0, y: 0, width: 140, height: 100000), limitedToNumberOfLines: 0)
        self.height.update(offset: frame.size.height + 44.0)
    }
    /// 添加UI
    fileprivate func sp_setupUI(){
        self.addSubview(self.contentView)
        self.contentView.addSubview(self.topImgView)
       
        self.contentView.addSubview(self.scrollViewContentView)
        self.contentView.addSubview(self.scrollView)
        self.scrollView.addSubview(self.messageLabel)
        self.addSubview(self.canceBtn)
        self.contentView.addSubview(self.doneBtn)
        self.sp_addConstraint()
    }
    /// 添加约束
    fileprivate func sp_addConstraint(){
        self.contentView.snp.makeConstraints { (maker) in
            maker.width.equalTo(216)
            maker.centerX.equalTo(self.snp.centerX).offset(0)
            maker.top.greaterThanOrEqualTo(self).offset(sp_getstatusBarHeight() + 40 )
            maker.centerY.equalTo(self).offset(0)
            maker.bottom.lessThanOrEqualTo(self.snp.bottom).offset(-SP_TABBAR_HEIGHT - 30)
            maker.height.greaterThanOrEqualTo(0)
        }
        
        self.topImgView.snp.makeConstraints { (maker) in
            maker.left.right.equalTo(self.contentView).offset(0)
 
            maker.top.equalTo(self.contentView).offset(0)
            maker.bottom.equalTo(self.doneBtn.snp.bottom).offset(20)
        }
 
        self.scrollViewContentView.snp.makeConstraints { (maker) in
            maker.left.right.top.equalTo(self.scrollView).offset(0)
            maker.height.equalTo(self.scrollView).offset(0)
        }
        self.scrollView.snp.makeConstraints { (maker) in
           maker.left.equalTo(self.contentView).offset(18)
            maker.right.equalTo(self.contentView).offset(-18)
           self.height = maker.height.equalTo(10).constraint
            maker.top.equalTo(self.contentView.snp.top).offset(86)
        }
       
        self.canceBtn.snp.makeConstraints { (maker) in
            maker.centerX.equalTo(self.snp.centerX).offset(0)
            maker.top.equalTo(self.contentView.snp.bottom).offset(18)
            maker.width.equalTo(30)
            maker.height.equalTo(30)
        }
        self.doneBtn.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.contentView).offset(18)
            maker.right.equalTo(self.contentView).offset(-18)
            maker.top.equalTo(self.scrollView.snp.bottom).offset(55)
            maker.height.equalTo(28)
            maker.bottom.equalTo(self.contentView.snp.bottom).offset(-20)
        }
        self.messageLabel.snp.makeConstraints { (maker) in
            maker.width.equalTo(self.scrollView.snp.width).offset(-40)
            maker.top.equalTo(self.scrollView).offset(23)
            maker.height.greaterThanOrEqualTo(0)
            maker.centerX.equalTo(self.scrollView.snp.centerX).offset(0)
            maker.bottom.equalTo(self.scrollView.snp.bottom).offset(-21)
        }
    }
    override func layoutSubviews() {
        super.layoutSubviews()
//        self.scrollViewContentView.layer.shadowPath = UIBezierPath(rect: self.scrollViewContentView.bounds).cgPath
    }
    deinit {
        
    }
 
}
extension SPUpdateView{
    @objc fileprivate func sp_cance(){
        self.removeFromSuperview()
    }
    @objc fileprivate func sp_done(){
        
        if let m = self.model {
            let url = URL(string: sp_getString(string: m.url))
            if let u = url{
                UIApplication.shared.openURL(u)
            }
            if let isFor = Bool(sp_getString(string: m.coerciveness)) , isFor ==  true{
                exit(0)
            }else{
                sp_cance()
            }
        }else{
            sp_cance()
        }
        
    }
    /// 是否强制升级
    ///
    /// - Returns: 是否
    fileprivate func sp_isForce()->Bool{
        var force = false
        if let m = self.model {
            if let isFor = Bool(sp_getString(string: m.coerciveness)) , isFor ==  true{
                force = true
            }
        }
        return force
    }
    
    
    
}
