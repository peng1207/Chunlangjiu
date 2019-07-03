//
//  SPAppraisalReportVC.swift
//  Chunlangjiu
//
//  Created by 黄树鹏 on 2019/4/24.
//  Copyright © 2019 Chunlang. All rights reserved.
//

import Foundation
import SnapKit
class SPAppraisalReportVC: SPBaseVC {
    fileprivate lazy var scrollView : UIScrollView = {
        let view = UIScrollView()
        return view
    }()
    
    fileprivate lazy var appraisalBtn : UIButton = {
        let btn = UIButton(type: UIButtonType.custom)
        btn.setTitle(" 求鉴定>>", for: UIControlState.normal)
        btn.setTitleColor(SPColorForHexString(hex: SP_HexColor.color_b31f3f.rawValue), for: UIControlState.normal)
        btn.setImage(UIImage(named: "public_identification"), for: UIControlState.normal)
        btn.titleLabel?.font = sp_getFontSize(size: 15)
        btn.backgroundColor = SPColorForHexString(hex: SP_HexColor.color_ffffff.rawValue)
        btn.addTarget(self, action: #selector(sp_clickAppraisal), for: UIControlEvents.touchUpInside)
        return btn
    }()
    fileprivate lazy var btnView : SPAppraisalBtnView = {
        let view = SPAppraisalBtnView()
        view.backgroundColor = SPColorForHexString(hex: SP_HexColor.color_ffffff.rawValue)
        view.clickBlock = { [weak self] (index) in
            self?.sp_dealClick(index: index)
        }
        view.unidentifiedBtn.setTitle("鉴定中\n(00)", for: UIControlState.normal)
        return view
    }()
    fileprivate lazy var unidentifiedVC : SPAppraisalProductVC = {
        let vc = SPAppraisalProductVC()
        vc.status = SPAPPraisalProductStatus_False
        vc.user_status = "1"
        vc.countComplete = { [weak self](true_count,false_count)in
            self?.sp_dealCount(true_count: true_count, false_count: false_count)
        }
        self.addChildViewController(vc)
        return vc
    }()
    fileprivate lazy var identifiedVC : SPAppraisalProductVC = {
        let vc = SPAppraisalProductVC()
        vc.status = SPAPPraisalProductStatus_True
        vc.user_status = "1"
        vc.countComplete = { [weak self](true_count,false_count)in
            self?.sp_dealCount(true_count: true_count, false_count: false_count)
        }
        self.addChildViewController(vc)
        return vc
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.sp_setupUI()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        sp_dealClick(index: self.btnView.sp_getSelect())
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
        self.navigationItem.title = "鉴定报告"
        self.view.addSubview(self.appraisalBtn)
        self.view.addSubview(self.btnView)
        self.view.addSubview(self.scrollView)
        self.scrollView.addSubview(self.unidentifiedVC.view)
        self.scrollView.addSubview(self.identifiedVC.view)
        self.sp_addConstraint()
    }
    /// 处理有没数据
    override func sp_dealNoData(){
        
    }
    /// 添加约束
    fileprivate func sp_addConstraint(){
        self.appraisalBtn.snp.makeConstraints { (maker) in
            maker.left.top.right.equalTo(self.view).offset(0)
            maker.height.equalTo(40)
        }
        self.btnView.snp.makeConstraints { (maker) in
            maker.left.right.equalTo(self.view).offset(0)
            maker.height.equalTo(50)
            maker.top.equalTo(self.appraisalBtn.snp.bottom).offset(10)
        }
        self.scrollView.snp.makeConstraints { (maker) in
            maker.left.right.equalTo(self.view).offset(0)
            maker.top.equalTo(self.btnView.snp.bottom).offset(0)
            if #available(iOS 11.0, *) {
                maker.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(0)
            } else {
                maker.bottom.equalTo(self.view.snp.bottom).offset(0)
            }
        }
        self.unidentifiedVC.view.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.scrollView.snp.left).offset(0)
            maker.top.equalTo(self.scrollView).offset(0)
            maker.width.height.equalTo(self.scrollView).offset(0)
            maker.centerY.equalTo(self.scrollView.snp.centerY).offset(0)
        }
        self.identifiedVC.view.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.unidentifiedVC.view.snp.right).offset(0)
            maker.top.height.width.equalTo(self.unidentifiedVC.view).offset(0)
        }
    }
    deinit {
        
    }
}
extension SPAppraisalReportVC {
    
    @objc fileprivate func sp_clickAppraisal(){
        let vc = SPAppraisalChoiceVC()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    fileprivate func sp_dealClick(index :Int){
        self.scrollView.setContentOffset(CGPoint(x: CGFloat(index)  * self.scrollView.frame.size.width, y: 0), animated: false)
    }
    func sp_dealCount(true_count: String ,false_count : String){
        self.btnView.unidentifiedBtn.setTitle("鉴定中\n(\(sp_getString(string: false_count)))", for: UIControlState.normal)
        self.btnView.identifiedBtBtn.setTitle("已鉴定\n(\(sp_getString(string: true_count)))", for: UIControlState.normal)
    }
}
