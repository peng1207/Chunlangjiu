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
        label.text = "扫一扫，推荐好友一起"
        return label
    }()
    fileprivate lazy var shareBtn : UIButton = {
        let btn = UIButton(type: UIButtonType.custom)
        btn.backgroundColor = SPColorForHexString(hex: SP_HexColor.color_b31f3f.rawValue)
        btn.setTitle("一键分享", for: UIControlState.normal)
        btn.sp_cornerRadius(cornerRadius: 5)
        btn.addTarget(self, action: #selector(sp_share), for: UIControlEvents.touchUpInside)
        return btn
    }()
    fileprivate lazy var listBtn : UIButton = {
        let btn = UIButton(type: UIButtonType.custom)
        btn.frame = CGRect(x: 0, y: 0, width: 60, height: 30)
        btn.setTitle("粉丝列表", for: UIControlState.normal)
        btn.titleLabel?.font = sp_getFontSize(size: 15)
        btn.setTitleColor(SPColorForHexString(hex: SP_HexColor.color_ffffff.rawValue), for: UIControlState.normal)
        btn.addTarget(self, action: #selector(sp_clickList), for: UIControlEvents.touchUpInside)
        return btn
    }()
    fileprivate lazy var copyBtn : UIButton = {
        let btn = UIButton(type: UIButtonType.custom)
        btn.setTitle("复制", for: UIControlState.normal)
        btn.setTitleColor(SPColorForHexString(hex: SP_HexColor.color_ffffff.rawValue), for: UIControlState.normal)
        btn.backgroundColor = SPColorForHexString(hex: SP_HexColor.color_ff9600.rawValue)
        btn.titleLabel?.font = sp_getFontSize(size: 12)
         btn.sp_cornerRadius(cornerRadius: 10)
        btn.addTarget(self, action: #selector(sp_clickCopy), for: UIControlEvents.touchUpInside)
        btn.isHidden = true
        return btn
    }()
    fileprivate var invitationCode : String?{
        didSet{
            self.codeLabel.text = "我的推荐码:\(  sp_getString(string: invitationCode))"
            if sp_getString(string: self.invitationCode).count > 0 {
                self.copyBtn.isHidden = false
            }else{
                self.copyBtn.isHidden = true
            }
        }
    }
    fileprivate var qrUrl : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.sp_setupUI()
        sp_setupData()
        sp_sendRequest()
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
        self.navigationItem.title = "我的推荐"
        self.view.addSubview(self.imageView)
        self.view.addSubview(self.codeLabel)
        self.view.addSubview(self.copyBtn)
        self.view.addSubview(self.tipsLabel)
        self.view.addSubview(self.shareBtn)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: self.listBtn)
        self.sp_addConstraint()
    }
    /// 处理有没数据
    override func sp_dealNoData(){
        
    }
    /// 添加约束
    fileprivate func sp_addConstraint(){
        self.imageView.snp.makeConstraints { (maker) in
            maker.top.equalTo(self.view).offset(100)
            maker.size.equalTo(CGSize(width: 225, height: 225))
            maker.centerX.equalTo(self.view.snp.centerX).offset(0)
            maker.height.equalTo(self.imageView.snp.width).offset(0)
        }
        self.codeLabel.snp.makeConstraints { (maker) in
            maker.width.greaterThanOrEqualTo(0)
            maker.centerX.equalTo(self.view.snp.centerX).offset(-30)
            maker.top.equalTo(self.imageView.snp.bottom).offset(15)
            maker.height.greaterThanOrEqualTo(0)
        }
        self.copyBtn.snp.makeConstraints { (maker) in
            maker.width.equalTo(50)
            maker.height.equalTo(20)
            maker.left.equalTo(self.codeLabel.snp.right).offset(5)
            maker.centerY.equalTo(self.codeLabel.snp.centerY).offset(0)
        }
        self.tipsLabel.snp.makeConstraints { (maker) in
            maker.left.right.equalTo(self.codeLabel).offset(0)
            maker.top.equalTo(self.codeLabel.snp.bottom).offset(10)
            maker.height.greaterThanOrEqualTo(0)
        }
        self.shareBtn.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.view).offset(38)
            maker.right.equalTo(self.view).offset(-38)
            maker.height.equalTo(40)
            maker.top.equalTo(self.tipsLabel.snp.bottom).offset(20)
        }
    }
    deinit {
        
    }
}
extension SPFansVC {
    @objc fileprivate func sp_share(){
        let shareDataModel = SPShareDataModel()
        shareDataModel.shareData = sp_getString(string: self.qrUrl).count > 0 ? sp_getString(string: self.qrUrl) : SP_SHARE_URL
        shareDataModel.title = sp_getString(string: "给您推荐高端酒综合服务平台-醇狼")
        shareDataModel.descr = sp_getString(string: "")
        shareDataModel.currentViewController = self
        shareDataModel.thumbImage = sp_getAppIcon()
        shareDataModel.placeholderImage =  sp_getAppIcon()
        SPShareManager.sp_share(shareDataModel: shareDataModel) { (model, error) in
            
        }
    }
    @objc fileprivate func sp_clickCopy(){
        sp_copy(text: sp_getString(string: self.invitationCode))
    }
    fileprivate func sp_setupData(){
        self.imageView.image = SPQRCodeUtil.sp_getClearImage(sourceImage: SPQRCodeUtil.sp_setQRCode(qrCode: "100"), center:   sp_getAppIcon())
    }
    @objc fileprivate func sp_clickList(){
        let listVC = SPFansListVC()
        listVC.shareUrl = self.qrUrl
        self.navigationController?.pushViewController(listVC, animated: true)
    }
}
extension SPFansVC {
    fileprivate func sp_sendRequest(){
        sp_showAnimation(view: self.view, title: nil)
        let parm = [String : Any]()
        self.requestModel.parm = parm
        SPFansRequest.sp_getInvitationCode(requestModel: self.requestModel) { [weak self](code, msg, invitationCode, url, errorModel) in
            sp_hideAnimation(view: self?.view)
            if code == SP_Request_Code_Success {
                self?.invitationCode = invitationCode
                self?.qrUrl = url
                self?.sp_setupData()
            }
        }
        
    }
}
