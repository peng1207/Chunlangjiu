//
//  SPAppraisalResultVC.swift
//  Chunlangjiu
//
//  Created by 黄树鹏 on 2019/4/13.
//  Copyright © 2019 Chunlang. All rights reserved.
//
// 鉴定结果
import Foundation
import SnapKit
class SPAppraisalResultVC: SPBaseVC {
    fileprivate lazy var scrollView : UIScrollView = {
        let view = UIScrollView()
        return view
    }()
    fileprivate lazy var infoView : SPAppraisalResultInfoView = {
        let view = SPAppraisalResultInfoView()
        view.backgroundColor = UIColor.white
        return view
    }()
    fileprivate lazy var priceView : SPAppraisalResultPriceView = {
        let view = SPAppraisalResultPriceView()
        view.backgroundColor = UIColor.white
        return view
    }()
    fileprivate lazy var detView : SPAppraisalResultDetView = {
        let view = SPAppraisalResultDetView()
        view.backgroundColor = UIColor.white
        return view
    }()
    fileprivate lazy var productView : SPAppraisalResultProductView = {
        let view = SPAppraisalResultProductView()
        view.backgroundColor = UIColor.white
        view.clickBlock = { [weak self] (index)in
            self?.sp_clickImg(index: index)
        }
        return view
    }()
    fileprivate lazy var tipsLabel : UILabel = {
        let label = UILabel()
        label.font = sp_getFontSize(size: 12)
        label.textColor = SPColorForHexString(hex: SP_HexColor.color_666666.rawValue)
        label.textAlignment = .center
        label.text = "此次评估仅供参考。"
        return label
    }()
    fileprivate lazy var submitBtn : UIButton = {
        let btn = UIButton(type: UIButtonType.custom)
        btn.setTitle("快速变现", for: UIControlState.normal)
        
        btn.setTitleColor(SPColorForHexString(hex: SP_HexColor.color_ffffff.rawValue), for: UIControlState.normal)
        btn.backgroundColor = SPColorForHexString(hex: SP_HexColor.color_b31f3f.rawValue)
        btn.titleLabel?.font = sp_getFontSize(size: 18)
        btn.isHidden = true
        btn.addTarget(self, action: #selector(sp_clickSubmit), for: UIControlEvents.touchUpInside)
        return btn
    }()
    fileprivate var detModel : SPAppraisalProductModel?
    fileprivate var submitHeight : Constraint!
    fileprivate var productTop : Constraint!
    var mySelf : Bool = false
    var chateau_id : Int?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.sp_setupUI()
        sp_sendReqeust()
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
        self.productView.model = self.detModel
        self.detView.model = self.detModel
        self.priceView.priceLabel.text = sp_getString(string: self.detModel?.price)
        self.infoView.model = self.detModel
        if sp_getString(string: self.detModel?.status) == SPAPPraisalProductStatus_True , self.mySelf == true {
            self.submitBtn.isHidden = false
            self.submitHeight.update(offset: 50)
            if sp_getString(string: self.detModel?.sell) == "true"{
                sp_dealSubmitBtn(open: false)
            }else{
                sp_dealSubmitBtn(open: true)
            }
        
        }else{
            self.submitBtn.isHidden = true
            self.submitHeight.update(offset: 0)
        }
        
        if sp_getString(string: self.detModel?.status) == SPAPPraisalProductStatus_True {
            self.navigationItem.title = "鉴定结果"
            self.priceView.isHidden = false
            self.detView.isHidden = false
            self.tipsLabel.isHidden = false
            self.infoView.isHidden = false
            self.infoView.snp.remakeConstraints { (maker) in
                maker.width.equalTo(self.scrollView).offset(0)
                maker.centerX.equalTo(self.scrollView.snp.centerX).offset(0)
                maker.left.right.equalTo(self.scrollView).offset(0)
                maker.top.equalTo(self.scrollView).offset(0)
                maker.height.equalTo(175)
            }
            self.priceView.snp.remakeConstraints { (maker) in
                maker.left.right.equalTo(self.infoView).offset(0)
                maker.top.equalTo(self.infoView.snp.bottom).offset(10)
                maker.height.equalTo(120)
            }
            self.detView.snp.remakeConstraints { (maker) in
                maker.left.right.equalTo(self.infoView).offset(0)
                maker.top.equalTo(self.priceView.snp.bottom).offset(10)
                maker.height.greaterThanOrEqualTo(0)
            }
            self.productTop.update(offset: 10)
        }else{
            if self.mySelf == true{
                self.navigationItem.title = "鉴定中"
            }else{
                 self.navigationItem.title = "待鉴定"
            }
            self.infoView.isHidden = true
            self.tipsLabel.isHidden = true
            self.priceView.isHidden = true
            self.detView.isHidden = true
            self.productTop.update(offset: 0)
            self.infoView.snp.remakeConstraints { (maker) in
                maker.width.equalTo(self.scrollView).offset(0)
                maker.centerX.equalTo(self.scrollView.snp.centerX).offset(0)
                maker.left.right.equalTo(self.scrollView).offset(0)
                maker.top.equalTo(self.scrollView).offset(0)
                maker.height.equalTo(0)
            }
            self.priceView.snp.remakeConstraints { (maker) in
                maker.left.right.equalTo(self.infoView).offset(0)
                maker.top.equalTo(self.infoView.snp.bottom).offset(0)
                maker.height.equalTo(0)
            }
            self.detView.snp.remakeConstraints { (maker) in
                maker.left.right.equalTo(self.infoView).offset(0)
                maker.top.equalTo(self.priceView.snp.bottom).offset(0)
                maker.height.equalTo(0)
            }
        }
    }
    fileprivate func sp_dealSubmitBtn(open : Bool){
        if open {
//              self.submitBtn.isEnabled = true
                self.submitBtn.setTitle("快速变现（\(SP_CHINE_MONEY)\(sp_getString(string: self.detModel?.price))）", for: UIControlState.normal)
            self.submitBtn.backgroundColor = SPColorForHexString(hex: SP_HexColor.color_b31f3f.rawValue)
        }else{
//            self.submitBtn.isEnabled = false
            self.submitBtn.setTitle("已提交变现申请（\(SP_CHINE_MONEY)\(sp_getString(string: self.detModel?.price))）", for: UIControlState.normal)
            self.submitBtn.backgroundColor = SPColorForHexString(hex: SP_HexColor.color_999999.rawValue)
        }
      
    }
    /// 创建UI
    override func sp_setupUI() {
        self.navigationItem.title = "鉴定结果"
        self.view.addSubview(self.scrollView)
        self.scrollView.addSubview(self.infoView)
        self.scrollView.addSubview(self.priceView)
        self.scrollView.addSubview(self.detView)
        self.scrollView.addSubview(self.productView)
        self.scrollView.addSubview(self.tipsLabel)
        self.scrollView.addSubview(self.submitBtn)
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
        self.infoView.snp.makeConstraints { (maker) in
            maker.width.equalTo(self.scrollView).offset(0)
            maker.centerX.equalTo(self.scrollView.snp.centerX).offset(0)
            maker.left.right.equalTo(self.scrollView).offset(0)
            maker.top.equalTo(self.scrollView).offset(0)
            maker.height.equalTo(175)
        }
        self.priceView.snp.makeConstraints { (maker) in
            maker.left.right.equalTo(self.infoView).offset(0)
            maker.top.equalTo(self.infoView.snp.bottom).offset(0)
            maker.height.equalTo(0)
        }
        self.detView.snp.makeConstraints { (maker) in
            maker.left.right.equalTo(self.infoView).offset(0)
            maker.top.equalTo(self.priceView.snp.bottom).offset(0)
            maker.height.equalTo(0)
        }
        self.productView.snp.makeConstraints { (maker) in
            maker.left.right.equalTo(self.detView).offset(0)
           self.productTop = maker.top.equalTo(self.detView.snp.bottom).offset(10).constraint
            maker.height.greaterThanOrEqualTo(0)
        }
        self.tipsLabel.snp.makeConstraints { (maker) in
            maker.width.equalTo(self.scrollView).offset(20)
            maker.centerX.equalTo(self.scrollView.snp.centerX).offset(0)
            maker.top.equalTo(self.productView.snp.bottom).offset(20)
            maker.height.greaterThanOrEqualTo(0)
        }
        self.submitBtn.snp.makeConstraints { (maker) in
            maker.width.equalTo(self.scrollView).offset(0)
            self.submitHeight = maker.height.equalTo(0).constraint
            maker.top.equalTo(self.tipsLabel.snp.bottom).offset(29)
            maker.centerX.equalTo(self.scrollView.snp.centerX).offset(0)
            maker.bottom.equalTo(self.scrollView.snp.bottom).offset(0)
        }
    }
    deinit {
        
    }
}
extension SPAppraisalResultVC {
    
    @objc fileprivate func sp_clickSubmit(){
        if sp_getString(string: self.detModel?.sell) == SPAPPraisalProductStatus_True  {
            sp_pushLiquidationVC()
        }else{
             sp_sendSellRequest()
        }
      
    }
    fileprivate func sp_pushLiquidationVC(){
        let vc = SPLiquidationVC()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    fileprivate func sp_clickImg(index : Int){
        let lookPictureVC = SPLookPictureVC()
        lookPictureVC.dataArray = self.detModel?.sp_getImgList()
        lookPictureVC.selectIndex = index
        self.present(lookPictureVC, animated: true, completion: nil)
    }
}
extension SPAppraisalResultVC {
    fileprivate func sp_sendReqeust(){
        var parm = [String : Any]()
        if let id = self.chateau_id {
             parm.updateValue(id, forKey: "chateau_id")
        }
       
        self.requestModel.parm = parm
        sp_showAnimation(view: self.view, title: nil)
        SPAppraisalRequest.sp_getAppraisalDet(requestModel: self.requestModel) { [weak self](code, model, errorModel) in
            sp_hideAnimation(view: self?.view)
            if code == SP_Request_Code_Success{
                self?.detModel = model
                self?.sp_setupData()
            }
        }
    }
    fileprivate func sp_sendSellRequest(){
        var parm = [String : Any]()
        if let id = self.chateau_id {
            parm.updateValue(id, forKey: "chateau_id")
        }
        let model = SPRequestModel()
        model.parm = parm
        sp_showAnimation(view: self.view, title: nil)
        SPAppraisalRequest.sp_getAppraisalSell(requestModel: model) { [weak self](code, msg, errorModel) in
            sp_hideAnimation(view: self?.view)
            if code == SP_Request_Code_Success{
                sp_showTextAlert(tips: "变现申请提交成功")
                 self?.sp_dealSubmitBtn(open: false)
                self?.detModel?.sell = SPAPPraisalProductStatus_True
                sp_asyncAfter(time: 2, complete: {
                    self?.sp_pushLiquidationVC()
                   
                })
            }else{
                sp_showTextAlert(tips: sp_getString(string: msg).count > 0 ? sp_getString(string: msg) : "提交快速变现失败")
            }
        }
    }
}
