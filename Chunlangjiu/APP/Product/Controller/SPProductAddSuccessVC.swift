//
//  SPProductAddSuccessVC.swift
//  Chunlangjiu
//
//  Created by 黄树鹏 on 2018/7/22.
//  Copyright © 2018年 Chunlang. All rights reserved.
//

import Foundation
import SnapKit
class SPProductAddSuccessVC: SPBaseVC {
    
    fileprivate lazy var scrollView : UIScrollView = UIScrollView()
    fileprivate lazy var contentView : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        return view
    }()
    fileprivate lazy var selectImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "public_select_green")
        return imageView
    }()
    fileprivate lazy var successTipsLabel : UILabel = {
        let label = UILabel()
        label.text = "商品发布成功"
        label.font = sp_getFontSize(size: 16)
        label.textColor = SPColorForHexString(hex: SP_HexColor.color_333333.rawValue)
        label.textAlignment = NSTextAlignment.center
        return label
    }()
    fileprivate lazy var managerBtn : UIButton = {
        let btn = UIButton(type: UIButtonType.custom)
        btn.setTitle("商品管理", for: UIControlState.normal)
        btn.setTitleColor(SPColorForHexString(hex: SP_HexColor.color_333333.rawValue), for: UIControlState.normal)
        btn.titleLabel?.font = sp_getFontSize(size: 16)
        btn.sp_border(color: SPColorForHexString(hex: SP_HexColor.color_eeeeee.rawValue), width: sp_lineHeight)
        btn.addTarget(self, action: #selector(sp_product), for: UIControlEvents.touchUpInside)
      
        return btn
    }()
    fileprivate lazy var examineBtn : UIButton = {
        let btn = UIButton(type: UIButtonType.custom)
        btn.setTitle("审核商品管理", for: UIControlState.normal)
        btn.setTitleColor(SPColorForHexString(hex: SP_HexColor.color_333333.rawValue), for: UIControlState.normal)
        btn.titleLabel?.font = sp_getFontSize(size: 16)
        btn.sp_border(color: SPColorForHexString(hex: SP_HexColor.color_eeeeee.rawValue), width: sp_lineHeight)
        btn.addTarget(self, action: #selector(sp_review), for: UIControlEvents.touchUpInside)
        return btn
    }()
    fileprivate lazy var tipsLabel : UILabel = {
        let label = UILabel()
        label.font = sp_getFontSize(size: 12)
        label.textColor = SPColorForHexString(hex: SP_HexColor.color_999999.rawValue)
        label.text = "商品发布说明：\n      您的发布需要进行审核，请前往审核商品管理查看商品的审核状态，如审核成功，商品将自动进入仓库商品，您可以前往仓库商品对商品进行上架或设为竞拍等操作。"
        label.numberOfLines = 0
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "商品添加"
        self.sp_setupUI()
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
    override func sp_clickBackAction() {
        self.navigationController?.popToRootViewController(animated: true)
    }
    /// 创建UI
    override func sp_setupUI() {
        self.view.addSubview(self.scrollView)
        self.scrollView.addSubview(self.contentView)
        self.contentView.addSubview(self.selectImageView)
        self.contentView.addSubview(self.successTipsLabel)
        self.contentView.addSubview(self.managerBtn)
        self.contentView.addSubview(self.examineBtn)
        self.scrollView.addSubview(self.tipsLabel)
        self.sp_addConstraint()
    }
    /// 添加约束
    fileprivate func sp_addConstraint(){
        self.scrollView.snp.makeConstraints { (maker) in
            maker.left.top.right.equalTo(self.view).offset(0)
            if #available(iOS 11.0, *) {
                maker.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(0)
            } else {
                // Fallback on earlier versions
                 maker.bottom.equalTo(self.view.snp.bottom).offset(0)
            }
        }
        self.contentView.snp.makeConstraints { (maker) in
            maker.left.right.top.equalTo(self.scrollView).offset(0)
            maker.centerX.equalTo(self.scrollView.snp.centerX).offset(0)
            maker.height.greaterThanOrEqualTo(0)
        }
        self.selectImageView.snp.makeConstraints { (maker) in
            maker.width.equalTo(40)
            maker.height.equalTo(40)
            maker.centerX.equalTo(self.contentView.snp.centerX).offset(0)
            maker.top.equalTo(self.contentView.snp.top).offset(51)
        }
        self.successTipsLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.contentView).offset(10)
            maker.right.equalTo(self.contentView.snp.right).offset(-10)
            maker.top.equalTo(self.selectImageView.snp.bottom).offset(15)
            maker.height.greaterThanOrEqualTo(0)
        }
        self.managerBtn.snp.makeConstraints { (maker) in
            maker.width.equalTo(120)
            maker.top.equalTo(self.successTipsLabel.snp.bottom).offset(30)
            maker.height.equalTo(30)
            maker.right.equalTo(self.contentView.snp.centerX).offset(-10)
        }
        self.examineBtn.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.contentView.snp.centerX).offset(10)
            maker.top.equalTo(self.managerBtn.snp.top).offset(0)
            maker.height.equalTo(self.managerBtn.snp.height).offset(0)
            maker.width.equalTo(self.managerBtn.snp.width).offset(0)
            maker.bottom.equalTo(self.contentView.snp.bottom).offset(-30)
        }
        self.tipsLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.scrollView.snp.left).offset(10)
        maker.right.equalTo(self.scrollView.snp.right).offset(-10)
            maker.top.equalTo(self.contentView.snp.bottom).offset(17)
            maker.height.greaterThanOrEqualTo(0)
            maker.bottom.equalTo(self.scrollView.snp.bottom).offset(0)
        }
    }
    deinit {
        
    }
}
extension SPProductAddSuccessVC{
    @objc fileprivate func sp_review(){
//        let webVC = SPWebVC()
//        webVC.url = URL(string: "\(SP_GET_PEND_WEB_UEL)?apitoken=\(sp_getString(string: SPAPPManager.instance().userModel?.accessToken))")
//        webVC.title = "审核商品管理"
//        self.navigationController?.pushViewController(webVC, animated: true)
        sp_pushReviewVC()
    }
    @objc fileprivate func sp_product(){
//        let webVC = SPWebVC()
//        webVC.url = URL(string: "\(SP_GET_ITECEMTER_URL)?apitoken=\(sp_getString(string: SPAPPManager.instance().userModel?.accessToken))")
//        webVC.title = "商品管理"
//        self.navigationController?.pushViewController(webVC, animated: true)
        sp_pushManagerVC()
    }
    /// 跳到商品管理
    fileprivate func sp_pushManagerVC(){
         var managerVC : SPProductManagerVC?
        if sp_getArrayCount(array: self.navigationController?.viewControllers) > 0 {
            for vc in (self.navigationController?.viewControllers)! {
                if vc.isKind(of: SPProductManagerVC.classForCoder()){
                    managerVC = vc as? SPProductManagerVC
                    break
                }
            }
        }
        if let vc = managerVC {
             self.navigationController?.popToViewController(vc, animated: true)
        }else{
            managerVC = SPProductManagerVC()
            self.navigationController?.pushViewController(managerVC!, animated: true)
        }
        
    }
    /// 跳到审核商品管理
    fileprivate func sp_pushReviewVC(){
        var managerVC : SPReviewProductVC?
        if sp_getArrayCount(array: self.navigationController?.viewControllers) > 0 {
            for vc in (self.navigationController?.viewControllers)! {
                if vc.isKind(of: SPReviewProductVC.classForCoder()){
                    managerVC = vc as? SPReviewProductVC
                    break
                }
            }
        }
        if let vc = managerVC {
            vc.sp_refesh()
            self.navigationController?.popToViewController(vc, animated: true)
        }else{
            managerVC = SPReviewProductVC()
            self.navigationController?.pushViewController(managerVC!, animated: true)
        }
    }
    
}
