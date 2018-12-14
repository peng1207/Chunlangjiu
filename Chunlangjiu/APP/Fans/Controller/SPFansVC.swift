//
//  SPFansVC.swift
//  Chunlangjiu
//
//  Created by 黄树鹏 on 2018/12/6.
//  Copyright © 2018 Chunlang. All rights reserved.
//

import Foundation
import SnapKit
class SPFansVC: SPBaseVC {
    
    fileprivate lazy var imageView : UIImageView = {
        return UIImageView()
    }()
    fileprivate lazy var codeLabel : UILabel = {
        let label = UILabel()
        label.font = sp_getFontSize(size: 15)
        label.textColor = SPColorForHexString(hex: SP_HexColor.color_333333.rawValue)
        label.textAlignment = .center
        return label
    }()
    fileprivate lazy var tipsLabel : UILabel = {
        let label = UILabel()
        label.font = sp_getFontSize(size: 15)
        label.textColor = SPColorForHexString(hex: SP_HexColor.color_999999.rawValue)
        label.textAlignment = .center
        return label
    }()
    fileprivate lazy var shareBtn : UIButton = {
        let btn = UIButton(type: UIButtonType.custom)
        btn.backgroundColor = SPColorForHexString(hex: SP_HexColor.color_b31f3f.rawValue)
        btn.setTitle("一键分享", for: UIControlState.normal)
        btn.sp_cornerRadius(cornerRadius: 5)
        return btn
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.sp_setupUI()
        sp_setupData()
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
        self.view.addSubview(self.imageView)
        self.view.addSubview(self.codeLabel)
        self.view.addSubview(self.tipsLabel)
        self.view.addSubview(self.shareBtn)
        self.sp_addConstraint()
    }
    /// 处理有没数据
    override func sp_dealNoData(){
        
    }
    /// 添加约束
    fileprivate func sp_addConstraint(){
        self.imageView.snp.makeConstraints { (maker) in
            maker.centerY.equalTo(self.view.snp.centerY).offset(-50)
            maker.left.equalTo(self.view).offset(50)
            maker.right.equalTo(self.view).offset(-50)
            maker.centerX.equalTo(self.view.snp.centerX).offset(0)
            maker.height.equalTo(self.imageView.snp.width).offset(0)
        }
        self.codeLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.view).offset(10)
            maker.right.equalTo(self.view).offset(-10)
            maker.top.equalTo(self.imageView.snp.bottom).offset(10)
            maker.height.greaterThanOrEqualTo(0)
        }
        self.tipsLabel.snp.makeConstraints { (maker) in
            maker.left.right.equalTo(self.codeLabel).offset(0)
            maker.top.equalTo(self.codeLabel.snp.bottom).offset(5)
            maker.height.greaterThanOrEqualTo(0)
        }
        self.shareBtn.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.view).offset(40)
            maker.right.equalTo(self.view).offset(-40)
            maker.height.equalTo(40)
            maker.top.equalTo(self.tipsLabel.snp.bottom).offset(10)
        }
    }
    deinit {
        
    }
}
extension SPFansVC {
    @objc fileprivate func sp_share(){
        
    }
    fileprivate func sp_setupData(){
        self.imageView.image = SPQRCodeUtil.sp_getClearImage(sourceImage: SPQRCodeUtil.sp_setQRCode(qrCode: "100"), center:  UIImage(named: "public_logo")!)
    }
    
}
