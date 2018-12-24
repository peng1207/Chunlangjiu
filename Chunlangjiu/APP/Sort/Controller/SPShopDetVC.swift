//
//  SPShopDetVC.swift
//  Chunlangjiu
//
//  Created by 黄树鹏 on 2018/12/23.
//  Copyright © 2018 Chunlang. All rights reserved.
//

import Foundation
import SnapKit
class SPShopDetVC: SPBaseVC {
    
    fileprivate lazy var scrollView : UIScrollView = {
        let view = UIScrollView()
        return view
    }()
    
    fileprivate lazy var headerView : SPShopHomeView = {
        let view = SPShopHomeView()
        view.backgroundColor = SPColorForHexString(hex: SP_HexColor.color_ffffff.rawValue)
        return view
    }()
    fileprivate lazy var addressView : SPShopAddressView = {
        let view = SPShopAddressView()
        view.backgroundColor = SPColorForHexString(hex: SP_HexColor.color_ffffff.rawValue)
        return view
    }()
    fileprivate lazy var infoView : SPShopInfoView = {
        let view = SPShopInfoView()
        view.backgroundColor = SPColorForHexString(hex: SP_HexColor.color_ffffff.rawValue)
        return view
    }()
    fileprivate lazy var lookBtn : UIButton = {
        let btn = UIButton(type: UIButtonType.custom)
        btn.setTitle("去看看店铺商品 >", for: UIControlState.normal)
        btn.setTitleColor(SPColorForHexString(hex: SP_HexColor.color_b31f3f.rawValue), for: UIControlState.normal)
        btn.backgroundColor = SPColorForHexString(hex: SP_HexColor.color_ffffff.rawValue)
        btn.titleLabel?.font = sp_getFontSize(size: 15)
        btn.addTarget(self, action: #selector(sp_clickLook), for: UIControlEvents.touchUpInside)
        return btn
    }()
    var shopModel : SPShopModel?
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
    /// 赋值
    fileprivate func sp_setupData(){
        self.headerView.shopModel = self.shopModel
        self.addressView.addressLabel.text = sp_getString(string: self.shopModel?.shop_addr)
        self.infoView.infoLabel.text = sp_getString(string: self.shopModel?.shop_descript)
    }
    /// 创建UI
    override func sp_setupUI() {
        self.view.addSubview(self.scrollView)
        self.scrollView.addSubview(self.headerView)
        self.scrollView.addSubview(self.addressView)
        self.scrollView.addSubview(self.infoView)
        self.scrollView.addSubview(self.lookBtn)
        self.sp_addConstraint()
    }
    /// 处理有没数据
    override func sp_dealNoData(){
        
    }
    /// 添加约束
    fileprivate func sp_addConstraint(){
        self.scrollView.snp.makeConstraints { (maker) in
            maker.left.right.top.equalTo(self.view).offset(0)
            if #available(iOS 11.0, *) {
                maker.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(0)
            } else {
                 maker.bottom.equalTo(self.view.snp.bottom).offset(0)
            }
        }
        self.headerView.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.scrollView).offset(5)
            maker.right.equalTo(self.scrollView).offset(-5)
            maker.top.equalTo(self.scrollView.snp.top).offset(5)
            maker.centerX.equalTo(self.scrollView).offset(0)
            maker.height.equalTo(100)
        }
        self.addressView.snp.makeConstraints { (maker) in
            maker.left.right.equalTo(self.headerView).offset(0)
            maker.top.equalTo(self.headerView.snp.bottom).offset(5)
            maker.height.greaterThanOrEqualTo(0)
        }
        self.infoView.snp.makeConstraints { (maker) in
            maker.left.right.equalTo(self.headerView).offset(0)
            maker.top.equalTo(self.addressView.snp.bottom).offset(5)
            maker.height.greaterThanOrEqualTo(0)
        }
        self.lookBtn.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.scrollView).offset(5)
            maker.right.equalTo(self.scrollView).offset(-5)
            maker.height.equalTo(50)
            maker.top.equalTo(self.infoView.snp.bottom).offset(5)
            maker.bottom.equalTo(self.scrollView.snp.bottom).offset(-5)
        }
    }
    deinit {
        
    }
}
extension SPShopDetVC {
    @objc fileprivate func sp_clickLook(){
        let productVC = SPProductListVC()
        productVC.shopModel = shopModel
        self.navigationController?.pushViewController(productVC, animated: true)
    }
}
