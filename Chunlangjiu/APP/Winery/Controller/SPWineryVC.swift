//
//  SPWineryVC.swift
//  Chunlangjiu
//
//  Created by 黄树鹏 on 2018/7/8.
//  Copyright © 2018年 Chunlang. All rights reserved.
//

import Foundation
import SnapKit
class SPWineryVC: SPBaseVC {
    
    fileprivate var dataArray : Array<SPWinerSortModel>?
    fileprivate var tableView : UITableView!
    fileprivate lazy var searchBtn : UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "public_search_white"), for: UIControlState.normal)
        btn.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        btn.addTarget(self, action: #selector(sp_clickSearchAction), for: UIControlEvents.touchUpInside)
      
        return btn
    }()
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
    override func sp_dealNoData() {
        if sp_getArrayCount(array: self.dataArray) > 0 {
            self.noData.isHidden = true
        }else{
            self.noData.isHidden = false
            self.noData.text = "没有找到相关名庄"
            self.view.bringSubview(toFront: self.noData)
        }
    }
    /// 创建UI
    override func sp_setupUI() {
        self.navigationItem.title = "名庄查询"
        self.tableView = UITableView(frame: CGRect.zero, style: UITableViewStyle.plain)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.separatorStyle = .none
        self.tableView.rowHeight = 40
        let label = UILabel()
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.paragraphSpacing = 10.0
        paragraphStyle.firstLineHeadIndent = 10.0
        let attributedString = NSMutableAttributedString(string: "全部名庄")
        attributedString.addAttributes([NSAttributedStringKey.paragraphStyle : paragraphStyle ,NSAttributedStringKey.font : sp_getFontSize(size: 18),NSAttributedStringKey.foregroundColor : SPColorForHexString(hex: SP_HexColor.color_999999.rawValue)], range: NSRange(location: 0, length: attributedString.length))
        label.attributedText = attributedString
        label.frame = CGRect(x: 0, y: 0, width: sp_getScreenWidth(), height: 44)
        let lineView = sp_getLineView()
        label.addSubview(lineView)
        lineView.snp.makeConstraints { (maker) in
            maker.left.right.bottom.equalTo(label)
            maker.height.equalTo(sp_lineHeight)
        }
        self.tableView.tableHeaderView = label
        self.view.addSubview(self.tableView)
//        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: self.searchBtn)
        self.sp_addConstraint()
    }
    /// 添加约束
    fileprivate func sp_addConstraint(){
        self.tableView.snp.makeConstraints { (maker) in
            maker.left.top.right.equalTo(self.view).offset(0)
            if #available(iOS 11.0, *) {
                maker.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(0)
            } else {
                maker.bottom.equalTo(self.view.snp.bottom).offset(0)
            }
        }
    }
    deinit {
        self.tableView.delegate = nil
        self.tableView.dataSource = nil
    }
}
extension SPWineryVC : UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return sp_getArrayCount(array: self.dataArray) > 0 ? 1 : 0
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sp_getArrayCount(array: self.dataArray)
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let wineryCellID = "wineryCellID"
        var cell : SPWineryTableCell? = tableView.dequeueReusableCell(withIdentifier: wineryCellID) as? SPWineryTableCell
        if cell == nil {
            cell = SPWineryTableCell(style: UITableViewCellStyle.default, reuseIdentifier: wineryCellID)
            if indexPath.row < sp_getArrayCount(array: self.dataArray){
                cell?.sortModel = self.dataArray?[indexPath.row]
            }
            
        }
        return cell!
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row < sp_getArrayCount(array: self.dataArray){
            let listVC = SPWineryListVC()
            if indexPath.row < sp_getArrayCount(array: self.dataArray){
                listVC.sortModel = self.dataArray?[indexPath.row]
            }
            self.navigationController?.pushViewController(listVC, animated: true)
        }
    }
}
extension SPWineryVC {
    @objc fileprivate func sp_clickSearchAction(){
       
    }
  
}
extension SPWineryVC {
    /// 发送请求
    fileprivate func sp_sendRequest(){
        sp_showAnimation(view: self.view, title: nil)
        SPAppRequest.sp_getWinerSort(requestModel: self.requestModel) { [weak self](code , list, errorModel, totalPage) in
            self?.sp_dealRequest(code: code, list: list, errorModel: errorModel, totalPage: totalPage)
        }
    }
    /// 处理请求
    ///
    /// - Parameters:
    ///   - code: 请求码
    ///   - list: 列表
    ///   - errorModel: 错误
    ///   - totalPage: 总页数
    private func sp_dealRequest(code : String,list : [Any]? ,errorModel : SPRequestError?,totalPage : Int){
        sp_hideAnimation(view: self.view)
        if code == SP_Request_Code_Success {
            self.dataArray = list as? [SPWinerSortModel]
            self.tableView.reloadData()
        }
        sp_dealNoData()
    }
}
