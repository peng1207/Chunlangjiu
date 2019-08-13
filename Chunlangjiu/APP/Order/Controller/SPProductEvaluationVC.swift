//
//  SPProductEvaluationVC.swift
//  Chunlangjiu
//
//  Created by 黄树鹏 on 2018/8/31.
//  Copyright © 2018年 Chunlang. All rights reserved.
//

import Foundation
import SnapKit
class SPProductEvaluationVC: SPBaseVC {
    
    fileprivate var tableView : UITableView!
    fileprivate lazy var footerView : UIView = {
        let view = UIView()
        view.frame = CGRect(x: 0, y: 0, width: sp_getScreenWidth(), height: 100)
        return view
    }()
    fileprivate lazy var evaluatView : SPOrderEvaluationView = {
        let view = SPOrderEvaluationView()
        view.backgroundColor = UIColor.white
        return view
    }()
    fileprivate lazy var textView : SPTextView = {
        let view = SPTextView()
        view.placeholderLabel.text = "请输入您对此商品的评价..."
        view.placeholderLabel.font = sp_getFontSize(size: 14)
        view.backgroundColor = UIColor.white
        return view
    }()
    var successBlock : SPBtnClickBlock?
    fileprivate lazy var numLabel : UILabel = {
        let label = UILabel()
        label.text = "500字"
        label.font = sp_getFontSize(size: 13)
        label.textAlignment = .right
        label.backgroundColor = UIColor.white
        label.textColor = SPColorForHexString(hex: SP_HexColor.color_666666.rawValue)
        label.preferredMaxLayoutWidth = sp_getScreenWidth()
        return label
    }()
    fileprivate lazy var addView : SPOrderAddView = {
        let view = SPOrderAddView()
        view.viewController = self
        view.complete = {
        }
        return view
    }()
    fileprivate lazy var anonymousBtn : UIButton = {
        let btn = UIButton(type: UIButtonType.custom)
        btn.setTitle(" 匿名评价", for: UIControlState.normal)
        btn.setImage(UIImage(named: "public_default"), for: UIControlState.normal)
        btn.setImage(UIImage(named: "public_select_red"), for: UIControlState.selected)
        btn.addTarget(self, action: #selector(sp_clickAnonymous), for: UIControlEvents.touchUpInside)
        btn.titleLabel?.font = sp_getFontSize(size: 14)
        btn.setTitleColor(SPColorForHexString(hex: SP_HexColor.color_333333.rawValue), for: UIControlState.normal)
        return btn
        
    }()
    fileprivate lazy var submitBtn : UIButton = {
        let btn = UIButton(type: UIButtonType.custom)
        btn.backgroundColor = SPColorForHexString(hex: SP_HexColor.color_b31f3f.rawValue)
        btn.setTitle("提交评价", for: UIControlState.normal)
        btn.titleLabel?.font = sp_getFontSize(size: 18)
        btn.setTitleColor(UIColor.white, for: UIControlState.normal)
        btn.addTarget(self, action: #selector(sp_clickSubmit), for: UIControlEvents.touchUpInside)
        return btn
    }()
    var orderModel : SPOrderModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "商品评价"
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
        self.tableView.sp_layoutFooterView()
    }
    /// 创建UI
    override func sp_setupUI() {
        self.tableView = UITableView(frame: CGRect.zero, style: UITableViewStyle.grouped)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.separatorStyle = .none
        self.tableView.rowHeight = 70
        self.tableView.estimatedSectionFooterHeight = 100
        self.tableView.sectionFooterHeight = UITableViewAutomaticDimension
//        self.tableView.tableFooterView = self.footerView
        self.view.addSubview(self.tableView)
        self.view.addSubview(self.submitBtn)
        self.footerView.addSubview(self.evaluatView)
        self.footerView.addSubview(self.textView)
        self.footerView.addSubview(self.numLabel)
        self.footerView.addSubview(self.addView)
         self.footerView.addSubview(self.anonymousBtn)
        self.sp_addConstraint()
    }
    /// 添加约束
    fileprivate func sp_addConstraint(){
 
        self.tableView.snp.makeConstraints { (maker) in
            maker.left.right.top.equalToSuperview()
            maker.bottom.equalTo(self.submitBtn.snp.top).offset(0)
        }
        self.submitBtn.snp.makeConstraints { (maker) in
            maker.left.right.equalTo(self.view).offset(0)
            maker.height.equalTo(49)
            if #available(iOS 11.0, *) {
                maker.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(0)
            } else {
                maker.bottom.equalTo(self.view.snp.bottom).offset(0)
            }
        }

//        self.footerView.snp.makeConstraints { (make) in
//            make.top.equalToSuperview()
//            make.left.right.equalTo(view) // 确定的宽度，高度由子视图决定
//        }

        self.evaluatView.snp.makeConstraints { (maker) in
            maker.left.top.equalTo(self.footerView).offset(0)
//            maker.width.equalTo(self.footerView.snp.width).offset(0)
            maker.right.equalTo(self.footerView).offset(0)
            maker.height.equalTo(63)
        }
        self.textView.snp.makeConstraints { (maker) in
            maker.left.right.equalTo(self.evaluatView).offset(0)
            maker.top.equalTo(self.evaluatView.snp.bottom).offset(10)
            maker.height.equalTo(125)
        }
        self.numLabel.snp.makeConstraints { (maker) in
            maker.left.right.equalTo(self.textView).offset(0)
            maker.height.equalTo(20)
            maker.top.equalTo(self.textView.snp.bottom).offset(0)
        }
        self.addView.setContentHuggingPriority(UILayoutPriority.defaultHigh, for: UILayoutConstraintAxis.horizontal)
        self.addView.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.footerView.snp.left).offset(0)
            maker.top.equalTo(self.numLabel.snp.bottom).offset(5)
            maker.right.equalTo(self.footerView.snp.right).offset(0)
            maker.height.greaterThanOrEqualTo(0).priority(ConstraintPriority.high)
        }
        self.anonymousBtn.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.footerView.snp.left).offset(10)
            maker.width.equalTo(75)
            maker.top.equalTo(self.addView.snp.bottom).offset(3)
            maker.height.equalTo(18)
            maker.bottom.equalTo(self.footerView.snp.bottom).offset(-10)
        }
    }
    deinit {
        
    }
}
extension SPProductEvaluationVC {
    @objc fileprivate func sp_clickAnonymous(){
        self.anonymousBtn.isSelected = !self.anonymousBtn.isSelected
    }
    @objc fileprivate func sp_clickSubmit(){
        sp_sendUpload()
    }
}
// MARK: - request
extension  SPProductEvaluationVC {
    /// 上传图片
    fileprivate func sp_sendUpload(){
        let imageArray
            = self.addView.sp_getImage()
        sp_showAnimation(view: self.view, title: "提交中...")
        SPOrderHandle.sp_uploadImage(imageType: "rate", imageArray: imageArray) { [weak self](isSuccess, imagePaths) in
            if isSuccess {
                self?.sp_sendRequest(imageList: imagePaths)
            }else{
                sp_hideAnimation(view: self?.view)
                sp_showTextAlert(tips: "上传图片失败")
            }
        }
    }
    fileprivate func sp_sendRequest(imageList : [String]?){
        
        var parm = [String:Any]()
        parm.updateValue(orderModel?.tid ?? 0, forKey: "tid")
        let count = self.evaluatView.sp_getSelect()
        var list = [[String:Any]]()
        if sp_getArrayCount(array: orderModel?.order) > 0 {
            for itemModel in (orderModel?.order)! {
                var rate_dataParm = [String:Any]()
                rate_dataParm.updateValue(itemModel.oid ?? 0, forKey: "oid")
                rate_dataParm.updateValue(sp_getString(string: self.textView.textView.text), forKey: "content")
                
                rate_dataParm.updateValue(count == 5 ? "good" : count > 2 ? "neutral" : "bad", forKey: "result")
                
                if sp_isArray(array: imageList) {
                    rate_dataParm.updateValue( sp_getString(string: imageList?.joined(separator: ",")), forKey: "rate_pic")
                }
                list.append(rate_dataParm)
            }
        }
     
        parm.updateValue(sp_getString(string: sp_arrayValueString(list)), forKey: "rate_data")
        parm.updateValue(self.anonymousBtn.isSelected ? "true" : "false", forKey: "anony")
        parm.updateValue(count, forKey: "tally_score")
        parm.updateValue(count, forKey: "attitude_score")
        parm.updateValue(count, forKey: "delivery_speed_score")
        self.requestModel.parm = parm
        SPOrderRequest.sp_getProductRate(requestModel: self.requestModel) { [weak self](code, msg, errorModel) in
            sp_hideAnimation(view: self?.view)
            if code == SP_Request_Code_Success {
                sp_showTextAlert(tips: msg.count > 0 ? msg :"评价成功")
                self?.sp_dealSuccess()
                self?.navigationController?.popViewController(animated: true)
            }else{
                sp_showTextAlert(tips: msg.count > 0 ? msg : "评价失败")
            }
        }
    }
    fileprivate func sp_dealSuccess(){
        guard let block = self.successBlock else {
            return
        }
        block()
    }
}
// MARK: - delegete
extension SPProductEvaluationVC : UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        if let model = self.orderModel {
            return sp_getArrayCount(array: model.order) > 0 ? 1 : 0
        }
        return 0
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let model = self.orderModel {
            return sp_getArrayCount(array: model.order)
        }
        return 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let evaluationProductCellID = "evaluationProductCellID"
        var cell : SPOrderTableCell? = tableView.dequeueReusableCell(withIdentifier: evaluationProductCellID) as? SPOrderTableCell
        if cell == nil {
            cell = SPOrderTableCell(style: UITableViewCellStyle.default, reuseIdentifier: evaluationProductCellID)
            cell?.showAfterSales = false
        }
        if let detaile = self.orderModel {
            if indexPath.row < sp_getArrayCount(array: detaile.order){
                let model = detaile.order?[indexPath.row]
                cell?.orderItem = model
            }
        }
        return cell!
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 59
    }
   
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let evaluationProductHeaderID = "evaluationProductHeaderID"
        var headerView : SPOrderTableHeaderView? = tableView.dequeueReusableHeaderFooterView(withIdentifier: evaluationProductHeaderID) as? SPOrderTableHeaderView
        if headerView == nil {
            headerView = SPOrderTableHeaderView(reuseIdentifier: evaluationProductHeaderID)
            headerView?.sp_leftRightZero()
        }
        if let detaile = self.orderModel {
            headerView?.orderModel = detaile
            headerView?.orderStateLabel.text = ""
        }
        return headerView
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return self.footerView
    }
}
