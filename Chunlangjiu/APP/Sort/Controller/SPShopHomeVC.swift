//
//  SPShopHomeVC.swift
//  Chunlangjiu
//
//  Created by 黄树鹏 on 2018/7/20.
//  Copyright © 2018年 Chunlang. All rights reserved.
//

import Foundation
import SnapKit
class SPShopHomeVC: SPBaseVC {
    
    fileprivate lazy var shopHomeView : SPShopHomeView = {
        let view = SPShopHomeView()
        view.backgroundColor = UIColor.white
        view.shopModel = shopModel
        return view
    }()
    fileprivate lazy var listBtn  : UIButton = {
        let btn = UIButton(type: UIButtonType.custom)
        btn.setImage(UIImage(named: "public_list"), for: UIControlState.normal)
        btn.setImage(UIImage(named: "public_abreast"), for: UIControlState.selected)
        btn.setTitleColor(SPColorForHexString(hex: SP_HexColor.color_ffffff.rawValue), for: UIControlState.normal)
        btn.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        btn.addTarget(self, action: #selector(clickListAction), for: UIControlEvents.touchUpInside)
        return btn
    }()
    fileprivate lazy var searchView : SPSearchView = {
        var view = SPSearchView(frame:  CGRect(x: 0, y: 0, width: sp_getScreenWidth() - 120, height: 30))
        view.searchBlock = {  [weak self](text) in
            self?.sp_dealSearch(text: text)
        }
        return view
    }()
    fileprivate var productVC : SPProductListVC!
    var shopModel : SPShopModel?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.sp_setupUI()
        self.sp_sendRequest()
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
        self.view.addSubview(self.shopHomeView)
        self.productVC = SPProductListVC()
        self.productVC.shopModel = self.shopModel
        self.view.addSubview(self.productVC.view)
        self.addChildViewController(self.productVC)
        self.navigationItem.titleView = self.searchView
        let listBtnItem = UIBarButtonItem(customView: self.listBtn )
        self.navigationItem.rightBarButtonItem = listBtnItem
        self.sp_addConstraint()
    }
    /// 添加约束
    fileprivate func sp_addConstraint(){
        self.shopHomeView.snp.makeConstraints { (maker) in
            maker.left.right.top.equalTo(self.view).offset(0)
            maker.height.greaterThanOrEqualTo(0)
        }
        self.productVC.view.snp.makeConstraints { (maker) in
            maker.left.right.equalTo(self.view).offset(0)
            maker.top.equalTo(self.shopHomeView.snp.bottom).offset(0)
            if #available(iOS 11.0, *) {
                maker.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(0)
            } else {
                maker.bottom.equalTo(self.view.snp.bottom).offset(0)
            }
        }
    }
    deinit {
        
    }
}
// MARK: - action
extension SPShopHomeVC {
    @objc fileprivate func clickListAction(){
        self.listBtn.isSelected = !self.listBtn.isSelected
        self.productVC.isH = self.listBtn.isSelected
    }
    /// 处理点击搜索
    ///
    /// - Parameter text: 搜索数据
    fileprivate func sp_dealSearch(text:String?){
        if sp_getString(string: text).count > 0 {
            self.productVC.keywords = text
            self.productVC.sp_searchRequest()
        }else{
            sp_showTextAlert(tips: "请输入关键字")
        }
    }
    /// 赋值
    fileprivate func sp_setupData(){
        self.shopHomeView.shopModel = self.shopModel
    }
}
extension SPShopHomeVC {
    fileprivate func sp_sendRequest(){
        var parm = [String:Any]()
        parm.updateValue(self.shopModel?.shop_id ?? 0, forKey: "shop_id")
        self.requestModel.parm = parm
        SPAppRequest.sp_getShop(requestModel: self.requestModel) {  [weak self](code , model, errorModel) in
            if code  == SP_Request_Code_Success {
                self?.shopModel = model
                self?.sp_setupData()
            }
        }
    }
    
}
