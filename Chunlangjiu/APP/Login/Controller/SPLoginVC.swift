//
//  SPLoginVC.swift
//  Chunlangjiu
//
//  Created by 黄树鹏 on 2019/4/18.
//  Copyright © 2019 Chunlang. All rights reserved.
//

import Foundation
import SnapKit
class SPLoginVC: SPBaseVC {
    fileprivate lazy var logoImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "login_logo")
        return imageView
    }()
    fileprivate lazy var phoneVC : SPPhoneLoginVC = {
        let vc = SPPhoneLoginVC()
        vc.clickBlock = { [weak self] in
             sp_hideKeyboard()
            sp_asyncAfter(time: 0.3, complete: {
                 self?.sp_pwdAnimation()
            })
           
        }
        self.addChildViewController(vc)
        return vc
    }()
    fileprivate lazy var pwdVC : SPPwdLoginVC = {
        let vc = SPPwdLoginVC()
        vc.view.isHidden = true
        vc.clickBlock = { [weak self] in
            sp_hideKeyboard()
            sp_asyncAfter(time: 0.3, complete: {
                self?.sp_phoneAnimation()
            })
        }
        self.addChildViewController(vc)
        return vc
    }()
    fileprivate lazy var tipLabel : UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.attributedText = NSAttributedString(string: "首次登录将自动注册", attributes: [NSAttributedStringKey.font : sp_getFontSize(size: 15),NSAttributedStringKey.underlineStyle:NSUnderlineStyle.styleSingle.rawValue,NSAttributedStringKey.foregroundColor : SPColorForHexString(hex: SP_HexColor.color_999999.rawValue)])
        return label
    }()
    fileprivate lazy var backBtn : UIButton = {
        let btn = UIButton(type: UIButtonType.custom)
        btn.setImage(UIImage(named: "public_leftBack"), for: UIControlState.normal)
        btn.addTarget(self, action: #selector(sp_clickBackAction), for: UIControlEvents.touchUpInside)
        return btn
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.sp_setupUI()
        sp_addNotification()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
          self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
         self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    /// 创建UI
    override func sp_setupUI() {
        self.view.addSubview(self.logoImageView)
        self.view.addSubview(self.phoneVC.view)
        self.view.addSubview(self.pwdVC.view)
        self.view.addSubview(self.tipLabel)
        self.view.addSubview(self.backBtn)
        self.sp_addConstraint()
    }
    /// 处理有没数据
    override func sp_dealNoData(){
        
    }
    /// 添加约束
    fileprivate func sp_addConstraint(){
        self.logoImageView.snp.makeConstraints { (maker) in
            maker.width.equalTo(85)
            maker.height.equalTo(47)
            maker.centerX.equalTo(self.view.snp.centerX).offset(0)
            maker.top.equalTo(sp_getstatusBarHeight() + 102)
        }
        self.phoneVC.view.snp.makeConstraints { (maker) in
            maker.left.right.equalTo(self.view).offset(0)
            maker.top.equalTo(self.logoImageView.snp.bottom).offset(68)
            maker.bottom.equalTo(self.tipLabel.snp.top).offset(-10)
        }
        self.pwdVC.view.snp.makeConstraints { (maker) in
            maker.width.top.bottom.equalTo(self.phoneVC.view).offset(0)
            maker.left.equalTo(self.phoneVC.view.snp.right).offset(0)
        }
        self.tipLabel.snp.makeConstraints { (maker) in
            maker.left.right.equalTo(self.view).offset(0)
            maker.height.greaterThanOrEqualTo(0)
            if #available(iOS 11.0, *) {
                maker.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(-50)
            } else {
                maker.bottom.equalTo(self.view.snp.bottom).offset(-50)
            }
        }
        self.backBtn.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.view).offset(10)
            maker.width.equalTo(30)
            maker.height.equalTo(30)
            maker.top.equalTo(self.view).offset(sp_getstatusBarHeight() +  9)
        }
    }
    
    fileprivate func sp_phoneAnimation(){
        self.phoneVC.view.isHidden = false
        UIView.animate(withDuration: 0.5, animations: {
           
            self.pwdVC.view.snp.remakeConstraints({ (maker) in
                maker.right.equalTo(self.view.snp.left).offset(0)
                maker.width.top.bottom.equalTo(self.phoneVC.view).offset(0)
            })
            self.phoneVC.view.snp.remakeConstraints({ (maker) in
                maker.top.equalTo(self.logoImageView.snp.bottom).offset(68)
                maker.bottom.equalTo(self.tipLabel.snp.top).offset(-10)
                maker.width.equalTo(self.view).offset(0)
                maker.left.equalTo(self.view.snp.left).offset(0)
            })
            self.phoneVC.view.layoutIfNeeded()
            self.pwdVC.view.layoutIfNeeded()
            self.view.layoutIfNeeded()
        }) { (finish) in
            self.pwdVC.view.isHidden = true
            self.pwdVC.view.snp.remakeConstraints({ (maker) in
                maker.left.equalTo(self.view.snp.right).offset(0)
                maker.width.top.bottom.equalTo(self.phoneVC.view).offset(0)
            })
        }
    }
    fileprivate func sp_pwdAnimation(){
        self.pwdVC.view.isHidden = false
        UIView.animate(withDuration: 0.5, animations: {
          
            self.phoneVC.view.snp.remakeConstraints({ (maker) in
                maker.top.equalTo(self.logoImageView.snp.bottom).offset(68)
                maker.bottom.equalTo(self.tipLabel.snp.top).offset(-10)
                maker.width.equalTo(self.view).offset(0)
                maker.right.equalTo(self.view.snp.left).offset(0)
            })
            self.pwdVC.view.snp.remakeConstraints({ (maker) in
                maker.left.equalTo(self.view.snp.left).offset(0)
                maker.width.top.bottom.equalTo(self.phoneVC.view).offset(0)
            })
            self.phoneVC.view.layoutIfNeeded()
            self.pwdVC.view.layoutIfNeeded()
             self.view.layoutIfNeeded()
        }) { (finish) in
            self.phoneVC.view.isHidden = true
            self.phoneVC.view.snp.remakeConstraints({ (maker) in
                maker.top.equalTo(self.logoImageView.snp.bottom).offset(68)
                maker.bottom.equalTo(self.tipLabel.snp.top).offset(-10)
                maker.width.equalTo(self.view).offset(0)
                maker.left.equalTo(self.view.snp.right).offset(0)
            })
        }
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
extension SPLoginVC{
    fileprivate func sp_addNotification(){
        NotificationCenter.default.addObserver(self, selector: #selector(sp_keyBoardWillShow(obj:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(sp_keyBoardWillHidden), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    @objc private func sp_keyBoardWillShow(obj : Notification){
        let height = sp_getKeyBoardheight(notification: obj)
        sp_log(message: "height : \(height)")
        self.phoneVC.view.snp.remakeConstraints { (maker) in
            maker.left.right.equalTo(self.view).offset(0)
            maker.top.equalTo(self.logoImageView.snp.bottom).offset(68)
//            maker.bottom.equalTo(self.tipLabel.snp.top).offset(-10)
            maker.bottom.equalTo(self.view).offset(-height)
        }
    }
    @objc private func sp_keyBoardWillHidden(){
        self.phoneVC.view.snp.remakeConstraints { (maker) in
            maker.left.right.equalTo(self.view).offset(0)
            maker.top.equalTo(self.logoImageView.snp.bottom).offset(68)
            maker.bottom.equalTo(self.tipLabel.snp.top).offset(-10)
        }
    }
}
