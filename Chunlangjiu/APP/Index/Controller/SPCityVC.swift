//
//  SPCityVC.swift
//  Chunlangjiu
//
//  Created by 黄树鹏 on 2018/7/6.
//  Copyright © 2018年 Chunlang. All rights reserved.
//

import Foundation
import SnapKit

typealias SPCitySelectBlock = (_ areaModel : SPAreaModel) -> Void

class SPCityVC: SPBaseVC {
    fileprivate lazy var searchView : SPSearchView = {
        let view = SPSearchView(frame: CGRect(x: 0, y: 0, width: sp_getScreenWidth() - 120 , height: 30))
        view.searchTextFiled.placeholder = "请输入城市"
        view.searchBlock = { [weak self](text) in
            self?.sp_dealSearch(text: text)
        }
        return view
    }()
    fileprivate lazy var searchCityView : SPSearchCityView = {
        let view = SPSearchCityView()
        view.isHidden = true
        view.selectBlock = { [weak self](areaModel) in
            self?.sp_dealSelect(areaModel: areaModel)
        }
        return view
    }()
    fileprivate lazy var commonlyusedModel : SPCityHeaderModel = {
       let model = SPCityHeaderModel()
        model.value = "地位/常用"
        return model
    }()
    fileprivate lazy var recommendModel : SPCityHeaderModel = {
        let model = SPCityHeaderModel()
        model.value = "热门城市"
        model.dataArray = self.sp_getRecommendArray()
        return model
    }()
    fileprivate lazy var cityHeaderView : SPCityHeaderView = {
        let view =  SPCityHeaderView()
        view.selectBlock = {[weak self](areaModel) in
            self?.sp_dealSelect(areaModel: areaModel)
        }
        return view
    }()
    fileprivate var tableView : UITableView!
    fileprivate var dataArray : Array<SPCityGroupModel>?
    fileprivate var letterList : [String]?
   
    override func viewDidLoad() {
        super.viewDidLoad()
        self.sp_setupUI()
        self.sp_setupData()
        self.sp_addNotification()
        self.sp_getData()
        self.tableView.sp_layoutHeaderView()
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
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.tableView.sp_layoutHeaderView()
    }
    /// 赋值
    fileprivate func sp_setupData(){
        SPAPPManager.sp_getAreaData(isCity: true) { [weak self](list) in
            self?.dataArray = list as? Array<SPCityGroupModel>
            self?.letterList = SPAPPManager.sp_getCityLetter()
            self?.tableView.reloadData()
        }
    }
    /// 创建UI
    override func sp_setupUI() {
        self.navigationItem.titleView = self.searchView
        self.tableView = UITableView(frame: CGRect.zero, style: UITableViewStyle.grouped)
        self.tableView.sectionIndexBackgroundColor = SPColorForHexString(hex: SP_HexColor.color_ffffff.rawValue)
        self.tableView.sectionIndexColor = SPColorForHexString(hex: SP_HexColor.color_999999.rawValue)
        self.tableView.backgroundColor = self.view.backgroundColor
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.separatorStyle = .none
        self.tableView.rowHeight = 44
        self.tableView.tableHeaderView = self.cityHeaderView
        self.tableView.tableFooterView = UIView()
        self.view.addSubview(self.tableView)
        self.view.addSubview(self.searchCityView)
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
        self.searchCityView.snp.makeConstraints { (maker) in
            maker.left.top.bottom.right.equalTo(self.tableView).offset(0)
        }
    }
    deinit {
        
    }
}
extension SPCityVC : UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return sp_getArrayCount(array: self.dataArray)
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section < sp_getArrayCount(array: self.dataArray) {
            let groupModel = self.dataArray![section]
            return sp_getArrayCount(array: groupModel.list)
        }
        return 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cityCellID = "cityCellID"
        var cell : SPCityTableCell? = tableView.dequeueReusableCell(withIdentifier: cityCellID) as? SPCityTableCell
        if cell == nil {
            cell = SPCityTableCell(style: UITableViewCellStyle.default, reuseIdentifier: cityCellID)
        }
        if indexPath.section < sp_getArrayCount(array: self.dataArray) {
            let groupModel = self.dataArray![indexPath.section]
            if indexPath.row < sp_getArrayCount(array: groupModel.list){
                let areaModel = groupModel.list![indexPath.row]
                cell?.titleLabel.text = sp_getString(string: areaModel.value)
            }
        }
        return cell!
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 39
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cityHeaderId = "cityHeaderId"
        var headerView : SPCitySectionHeadView? = tableView.dequeueReusableHeaderFooterView(withIdentifier: cityHeaderId) as? SPCitySectionHeadView
        if headerView == nil {
            headerView = SPCitySectionHeadView(reuseIdentifier: cityHeaderId)
            headerView?.contentView.backgroundColor = UIColor.white
        }
        if section < sp_getArrayCount(array: self.dataArray) {
            let groupModel = self.dataArray![section]
            headerView?.titleLabel.text = sp_getString(string: groupModel.firstLetter)
        }
        return headerView
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return self.letterList
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section < sp_getArrayCount(array: self.dataArray) {
            let groupModel = self.dataArray![indexPath.section]
            if indexPath.row < sp_getArrayCount(array: groupModel.list){
                let areaModel = groupModel.list![indexPath.row]
                self.sp_dealSelect(areaModel: areaModel)
            }
        }
    }
}
extension SPCityVC {
    /// 添加通知
    fileprivate func sp_addNotification(){
        NotificationCenter.default.addObserver(self, selector: #selector(sp_locationNotification), name: NSNotification.Name(rawValue: SP_LOCATION_NOTIFICATION), object: nil)
    }
    /// 定位成功通知
    @objc fileprivate func sp_locationNotification(){
        self.cityHeaderView.cityLabel.text = sp_getString(string: SPAPPManager.instance().locationCity)
        self.sp_getData()
    }
    
}
extension SPCityVC {
    
    fileprivate func sp_dealSelect(areaModel:SPAreaModel){
        SPAPPManager.instance().showCity = sp_getString(string: areaModel.value)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: SP_LOCATION_NOTIFICATION), object: nil)
        self.navigationController?.popViewController(animated: true)
 
        SPRealmTool.sp_insert(areaModel: areaModel)
    }
    
    /// 处理搜索数据
    ///
    /// - Parameter text: 关键字
    fileprivate func sp_dealSearch(text:String?) {
        let keyWord = sp_getString(string: text)
        if keyWord.count > 0  {
            sp_simpleSQueues {
                
                var list = [SPAreaModel]()
                if sp_getArrayCount(array: self.dataArray) > 0 {
                    for groupModel in self.dataArray! {
                        for areaModel in groupModel.list! {
                            if sp_getString(string: areaModel.value).range(of: keyWord) != nil {
                                list.append(areaModel)
                            }
                        }
                    }
                }
               
                sp_mainQueue {
                    self.searchCityView.dataArray = list
                    self.searchCityView.isHidden = false
                }
            }
        }else{
            sp_showTextAlert(tips: "请输入关键字")
        }
    }
    fileprivate func sp_getData(){
        var  list = [SPCityHeaderModel]()
        self.commonlyusedModel.dataArray = sp_getCommonlyused()
        if sp_getArrayCount(array: self.commonlyusedModel.dataArray) > 0 {
            list.append(self.commonlyusedModel)
        }
        list.append(self.recommendModel)
        self.cityHeaderView.dataArray = list

    }
    fileprivate func sp_getRecommendArray()->[SPAreaModel]{
        var list = [SPAreaModel]()
        let model1 = SPAreaModel()
        model1.value = "深圳市"
        list.append(model1)
       
        let model2 = SPAreaModel()
        model2.value = "北京市"
        list.append(model2)
        
        let model3 = SPAreaModel()
        model3.value = "上海市"
        list.append(model3)
        let model4 = SPAreaModel()
        model4.value = "广州市"
        list.append(model4)
        
        let model5 = SPAreaModel()
        model5.value = "杭州市"
        list.append(model5)
        
        let model6 = SPAreaModel()
        model6.value = "天津市"
        list.append(model6)
        
        let model7 = SPAreaModel()
        model7.value = "中山市"
        list.append(model7)
        
        let model8 = SPAreaModel()
        model8.value = "东莞市"
        list.append(model8)
        
        return list
    }
    fileprivate func sp_getCommonlyused()->[SPAreaModel]{
        var list = [SPAreaModel]()
        list = sp_getLocalData()
        if  let model = sp_getLocationData() {
            list.insert(model, at: 0)
        }
        return list
    }
    fileprivate func sp_getLocationData()->SPAreaModel? {
        if sp_getString(string: SPAPPManager.instance().locationCity).count > 0 {
             let areaModel = SPAreaModel()
            areaModel.value = sp_getString(string: SPAPPManager.instance().locationCity)
            return areaModel
        }else{
            return nil
        }
    }
    /// 获取本地保存数据
    ///
    /// - Returns: 数组
    fileprivate func sp_getLocalData()->[SPAreaModel]{
        let list = SPRealmTool.sp_getCityHistory()
        return list
    }
}
