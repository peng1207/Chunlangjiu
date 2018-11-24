//
//  SPOrderVC.swift
//  Chunlangjiu
//
//  Created by 黄树鹏 on 2018/8/29.
//  Copyright © 2018年 Chunlang. All rights reserved.
//

import Foundation
import SnapKit
class SPOrderVC: SPBaseVC {
    fileprivate lazy var toolView : SPOrderTool = {
        let view = SPOrderTool()
        view.backgroundColor = UIColor.white
        view.selectBlock = { [weak self](index) in
            self?.sp_dealTool(select: index)
        }
        return view
    }()
    fileprivate lazy var scrollView : UIScrollView = {
        let view = UIScrollView()
        view.isPagingEnabled = true
        view.showsHorizontalScrollIndicator = false
        view.bounces = false
        return view
    }()
    fileprivate var dataArray  : [SPOrderToolModel]?
    var orderType : SPOrderType = .defaultType
    var orderState : SPOrderStatus = .all
    fileprivate var isFristCome : Bool = true
    override func viewDidLoad() {
        super.viewDidLoad()
        sp_getTitle()
        self.sp_setupUI()
        sp_setupData()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if self.isFristCome == false {
            sp_dealTool(select: self.toolView.sp_getSelect())
        }
        self.isFristCome = false
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
        var isExist = false
        var index = 0
        if self.navigationController != nil {
            for tempVC in (self.navigationController?.viewControllers)!{
                if tempVC is SPConfirmOrderVC {
                    isExist = true
                    break
                }
                index = index + 1
            }
            if isExist {
                if index - 1 < sp_getArrayCount(array: self.navigationController?.viewControllers) , index - 1 >= 0 {
                    self.navigationController?.popToViewController((self.navigationController?.viewControllers[index - 1])!, animated: true)
                }else{
                    self.navigationController?.popToRootViewController(animated: true)
                }
                return
            }
        }
        super.sp_clickBackAction()
        
    }
    /// 赋值
    fileprivate func sp_setupData(){
        self.dataArray = sp_getOrderStat(to: self.orderType)
        sp_setupSubView()
        if sp_getArrayCount(array: self.dataArray) > 0  {
            var index = 0
            for model in self.dataArray! {
                if model.status == self.orderState {
                    break
                }
                index = index + 1
            }
            sp_asyncAfter(time: 0.3) {
                 self.toolView.sp_clickWhich(index: index)
            }
        }
        self.toolView.dataArray = self.dataArray
        
    }
    /// 创建UI
    override func sp_setupUI() {
        self.view.addSubview(self.toolView)
        self.view.addSubview(self.scrollView)
        self.sp_addConstraint()
    }
    /// 添加约束
    fileprivate func sp_addConstraint(){
        self.toolView.snp.makeConstraints { (maker) in
            maker.left.right.top.equalTo(self.view).offset(0)
            maker.height.equalTo(44)
        }
        self.scrollView.snp.makeConstraints { (maker) in
            maker.left.right.equalTo(self.view).offset(0)
            maker.top.equalTo(self.toolView.snp.bottom).offset(0)
            if #available(iOS 11.0, *) {
                maker.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(0)
            } else {
                 maker.bottom.equalTo(self.view.snp.bottom).offset(0)
            }
        }
    }
    fileprivate func sp_setupSubView(){
        if sp_getArrayCount(array: self.dataArray) <= 0 {
            return
        }
        var tmpView : UIView?
        var index = 0
        for toolModel in self.dataArray! {
            let orderListVC = SPOrderListVC()
            orderListVC.toolModel = toolModel
            self.addChildViewController(orderListVC)
            self.scrollView.addSubview(orderListVC.view)
            orderListVC.view.snp.makeConstraints { (maker) in
                
                if let v = tmpView{
                    maker.left.equalTo(v.snp.right).offset(0)
                }else{
                    maker.left.equalTo(self.scrollView.snp.left).offset(0)
                }
                
                maker.width.equalTo(self.scrollView.snp.width).offset(0)
                maker.height.equalTo(self.scrollView.snp.height).offset(0)
                maker.top.equalTo(self.scrollView.snp.top).offset(0)
                maker.centerY.equalTo(self.scrollView.snp.centerY).offset(0)
//                if index == sp_getArrayCount(array: self.dataArray) - 1 {
//                    maker.right.equalTo(self.scrollView.snp.right).offset(0)
//                }
            }
            tmpView = orderListVC.view
            index = index + 1
        }
    }
    
    deinit {
        
    }
}
extension SPOrderVC :  UIScrollViewDelegate{
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let page = scrollView.contentOffset.y / scrollView.frame.size.width
        self.toolView.sp_clickWhich(index: Int(page))
    }
}
// MARK: - action data
extension SPOrderVC {
    fileprivate func sp_getTitle(){
        switch self.orderType {
        case .defaultType,.shopType:
            self.navigationItem.title = "订单管理"
        case .auctionType:
            self.navigationItem.title = "竞拍订单管理"
        case .afterSaleType,.shopSaleType:
            self.navigationItem.title = "售后订单"
//        default:
//            self.navigationItem.title = "订单管理"
        }
    }
    fileprivate func sp_dealTool(select index :Int){
        if  index < sp_getArrayCount(array: self.dataArray) {
            self.scrollView.setContentOffset(CGPoint(x: self.scrollView.frame.size.width * CGFloat(index), y: 0), animated: true)
        }
    }
}
