//
//  SPProductEvaluationListVC.swift
//  Chunlangjiu
//
//  Created by 黄树鹏 on 2018/9/2.
//  Copyright © 2018年 Chunlang. All rights reserved.
//

import Foundation
import SnapKit
class SPProductEvaluationListVC: SPBaseVC {
    
    fileprivate  var tableView : UITableView!
    var orderModel : SPOrderModel?
    override func viewDidLoad() {
        super.viewDidLoad()
         self.navigationItem.title = "商品评价"
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
    /// 创建UI
    override func sp_setupUI() {
        self.tableView = UITableView(frame: CGRect.zero, style: UITableViewStyle.plain)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.rowHeight = 70
        self.tableView.separatorStyle = .none
        self.view.addSubview(self.tableView)
        self.sp_addConstraint()
    }
    /// 添加约束
    fileprivate func sp_addConstraint(){
        self.tableView.snp.makeConstraints { (maker) in
            maker.left.right.top.equalTo(self.view).offset(0)
            if #available(iOS 11.0, *) {
                maker.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(0)
            } else {
                // Fallback on earlier versions
                 maker.bottom.equalTo(self.view.snp.bottom).offset(0)
            }
        }
    }
    deinit {
        
    }
}
extension SPProductEvaluationListVC : UITableViewDelegate,UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        guard let model = self.orderModel else {
            return 0
        }
        return sp_getArrayCount(array: model.order) > 0 ? 1 : 0
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let model = self.orderModel else {
            return 0
        }
        return sp_getArrayCount(array: model.order)
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let productEvaluationTableCellID = "productEvaluationTableCellID"
        var cell : SPProductEvaluationListTableCell? = tableView.dequeueReusableCell(withIdentifier: productEvaluationTableCellID) as? SPProductEvaluationListTableCell
        if cell == nil {
            cell = SPProductEvaluationListTableCell(style: UITableViewCellStyle.default, reuseIdentifier: productEvaluationTableCellID)
        }
        if let model = self.orderModel {
            if indexPath.row < sp_getArrayCount(array: model.order) {
                cell?.itemModel = model.order?[indexPath.row]
            }
        }
        cell?.clickBlock = { (itemModel) in
            self.sp_clickEvaluation(itemModel: itemModel)
        }
       
        return cell!
    }
    fileprivate func sp_clickEvaluation(itemModel : SPOrderItemModel?){
        let evaluatVC = SPProductEvaluationVC()
        evaluatVC.orderModel = orderModel
        self.navigationController?.pushViewController(evaluatVC, animated: true)
    }
}
