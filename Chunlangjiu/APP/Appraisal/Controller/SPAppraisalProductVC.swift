//
//  SPAppraisalProductVC.swift
//  Chunlangjiu
//
//  Created by 黄树鹏 on 2019/4/25.
//  Copyright © 2019 Chunlang. All rights reserved.
//

import Foundation
import SnapKit
typealias SPAppraisalProductScrollBlock = (_ scrollView : UIScrollView)->Void
class SPAppraisalProductVC: SPBaseVC {
    fileprivate var collectionView : UICollectionView!
    fileprivate var dataArray : [SPAppraisalProductModel]?
    fileprivate let cellID = "SPAppraisalProductCellID"
    fileprivate let headerID = "SPAppraisalProductHeaderID"
    fileprivate var currentPage = 1
    fileprivate lazy var noDataView : SPNoDataView = {
        let view = SPNoDataView()
        view.isHidden = true
        return view
    }()
    ///  false 鉴定中 true 已鉴定 默认为已鉴定
    var status : String = "true"
    ///  0 卖家 1 买家  默认为1 买家
    var user_status : String = "1"
    var scrollBlock : SPAppraisalProductScrollBlock?
    var addHeader : Bool = false
    ///  买家
    fileprivate let K_USER_STATUS_1 = "1"
    /// 卖家
     fileprivate let K_USER_STATUS_0 = "0"
    fileprivate var headerHeight : CGFloat = 0
    fileprivate lazy var headerView : UIView = {
        let view = UIView()
        return view
    }()
    fileprivate lazy var infoView : SPAppraisalInfoHeadView = {
        let view = SPAppraisalInfoHeadView()
        view.backgroundColor = SPColorForHexString(hex: SP_HexColor.color_ffffff.rawValue)
        view.editBlock = { [weak self] in
            self?.sp_clickEditInfo()
        }
        return view
    }()
    lazy var btnView : SPAppraisalBtnView = {
        let view = SPAppraisalBtnView()
        view.backgroundColor = SPColorForHexString(hex: SP_HexColor.color_ffffff.rawValue)
//        view.clickBlock = { [weak self] (index) in
//            self?.sp_dealClick(index: index)
//        }
        return view
    }()
    var infoModel : SPAppraisalInfoModel?{
        didSet{
            self.sp_setupData()
        }
    }
    var countComplete: SPGetAppraisalCountComplete?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.sp_setupUI()
        sp_getHeaderHeight()
        sp_sendRequest()
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
        self.infoView.model = self.infoModel
        sp_getHeaderHeight()
    }
    /// 创建UI
    override func sp_setupUI() {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 5
        layout.minimumInteritemSpacing = 5
        layout.sectionInset = UIEdgeInsets(top: 6, left: 10, bottom: 0, right: 10)
        self.collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.backgroundColor = self.view.backgroundColor
        self.collectionView.alwaysBounceVertical = true
        self.collectionView.register(SPAppraisalProductCollectionCell.self, forCellWithReuseIdentifier: self.cellID)
        if self.addHeader {
            self.collectionView.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: self.headerID)
            self.headerView.addSubview(self.infoView)
            self.headerView.addSubview(self.btnView)
            self.infoView.snp.makeConstraints { (maker) in
                maker.left.right.top.equalTo(self.headerView).offset(0)
                maker.height.greaterThanOrEqualTo(0)
            }
            self.btnView.snp.makeConstraints { (maker) in
                maker.left.right.equalTo(self.headerView).offset(0)
                maker.top.equalTo(self.infoView.snp.bottom).offset(10)
                maker.height.equalTo(50)
                maker.bottom.equalTo(self.headerView.snp.bottom).offset(0)
            }
        }
        self.collectionView.showsVerticalScrollIndicator = false
        self.view.addSubview(self.collectionView)
        self.collectionView.sp_headerRefesh { [weak self] in
            self?.currentPage = 1
           self?.sp_sendRequest()
        }
        self.collectionView.sp_footerRefresh { [weak self] in
            if let page = self?.currentPage {
                self?.currentPage = page + 1
            }
           self?.sp_sendRequest()
        }
        self.view.addSubview(self.noDataView)
        self.sp_addConstraint()
    }
    /// 处理有没数据
    override func sp_dealNoData(){
        if sp_getArrayCount(array: self.dataArray) > 0 {
            self.noDataView.isHidden = true
        }else{
            self.noDataView.isHidden = false
        }
        self.collectionView.sp_stopFooterRefesh()
        self.collectionView.sp_stopHeaderRefesh()
        self.collectionView.reloadData()
    }
    /// 获取headerview的高度
    fileprivate func sp_getHeaderHeight(){
        if self.addHeader {
            self.headerHeight = self.headerView.systemLayoutSizeFitting(UILayoutFittingCompressedSize).height
            self.collectionView.reloadData()
            self.noDataView.snp.remakeConstraints { (maker) in
                maker.left.right.equalTo(self.view).offset(0)
                maker.height.greaterThanOrEqualTo(0)
                
                maker.top.equalTo(self.view).offset(self.headerHeight + (self.view.frame.size.height - self.headerHeight - 110 ) / 2.0 )
                if #available(iOS 11.0, *) {
                    maker.bottom.lessThanOrEqualTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(-10)
                } else {
                    maker.bottom.lessThanOrEqualTo(self.view.snp.bottom).offset(-10)
                }
            }
        }
    }
    /// 添加约束
    fileprivate func sp_addConstraint(){
        self.collectionView.snp.makeConstraints { (maker) in
            maker.left.right.top.equalTo(self.view).offset(0)
            if #available(iOS 11.0, *) {
                maker.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(0)
            } else {
                maker.bottom.equalTo(self.view.snp.bottom).offset(0)
            }
        }
        self.noDataView.snp.makeConstraints { (maker) in
            maker.left.right.equalTo(self.view).offset(0)
            maker.height.greaterThanOrEqualTo(0)
            maker.centerY.equalTo(self.view.snp.centerY).offset(0)
        }
    }
    deinit {
        
    }
}
extension SPAppraisalProductVC : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        if self.addHeader {
            return 1
        }
        return sp_getArrayCount(array: self.dataArray) > 0 ? 1 : 0
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sp_getArrayCount(array: self.dataArray)
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell : SPAppraisalProductCollectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: self.cellID, for: indexPath) as! SPAppraisalProductCollectionCell
        if indexPath.row < sp_getArrayCount(array: self.dataArray) {
            let model = self.dataArray?[indexPath.row]
            cell.model = model
            if sp_getString(string: model?.status) == SPAPPraisalProductStatus_True {
               cell.doneBtn.setTitle("鉴定报告", for: UIControlState.normal)
            }else if sp_getString(string: self.user_status) == K_USER_STATUS_0 {
                 cell.doneBtn.setTitle("去鉴定", for: UIControlState.normal)
            }else{
                cell.doneBtn.setTitle("鉴定中", for: UIControlState.normal)
            }
            cell.clickBlock = { [weak self] (m) in
                self?.sp_dealSelect(model: m)
            }
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = NSInteger((collectionView.frame.size.width - 25 ) / 2.0 )
        return CGSize(width: width, height: width + 100)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.size.width, height: self.headerHeight)
    }
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: self.headerID, for: indexPath)
        if self.addHeader {
            header.addSubview(self.headerView)
            self.headerView.snp.makeConstraints { (maker) in
                maker.left.right.top.equalTo(header).offset(0)
                maker.height.greaterThanOrEqualTo(0)
                maker.bottom.equalTo(header).offset(0)
            }
        }
        return header
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row < sp_getArrayCount(array: self.dataArray) {
            self.sp_dealSelect(model: self.dataArray?[indexPath.row])
        }
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let block = self.scrollBlock else {
            return
        }
        block(scrollView)
    }
}
extension SPAppraisalProductVC {
    
    fileprivate func sp_dealSelect(model : SPAppraisalProductModel?){
        if sp_getString(string: model?.status) == SPAPPraisalProductStatus_True {
            sp_pushResultVC(model: model)
        }else if sp_getString(string: self.user_status) == K_USER_STATUS_0 {
            sp_pushAppraisalVC(model: model)
        }else{
            sp_pushResultVC(model: model)
        }
    }
    fileprivate func sp_pushResultVC(model : SPAppraisalProductModel?){
        let vc = SPAppraisalResultVC()
        vc.chateau_id = model?.chateau_id
        if sp_getString(string: self.user_status) == K_USER_STATUS_1 {
            vc.mySelf = true
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    fileprivate func sp_pushAppraisalVC(model : SPAppraisalProductModel?){
        let vc = SPAppraisalVC()
        vc.model = model
        self.navigationController?.pushViewController(vc, animated: true)
    }
    fileprivate func sp_clickEditInfo(){
        let vc = SPAppraisalEditInfoVC()
        vc.infoModel = self.infoModel
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
extension SPAppraisalProductVC {
    
    fileprivate func sp_sendRequest(){
        if sp_getString(string: self.user_status) == K_USER_STATUS_0{
            sp_sendShopListRequest()
        }else{
            sp_sendListRequest()
        }
    }
    private func sp_sendShopListRequest(){
        var parm = [String : Any]()
        parm.updateValue(self.currentPage, forKey: "page_no")
 
        parm.updateValue(sp_getString(string: self.status), forKey: "status")
        self.requestModel.parm = parm
        SPAppraisalRequest.sp_getShopAppraisalList(requestModel: self.requestModel, complete: { [weak self](code, list, errorModel, total) in
             self?.sp_dealRequestComplete(code: code, list: list, errorModel: errorModel, total: total)
        }) { [weak self](true_count, false_count) in
            self?.sp_dealCountComplete(true_count: true_count, false_count: false_count)
        }
    }
    private func sp_sendListRequest(){
        var parm = [String : Any]()
        parm.updateValue(self.currentPage, forKey: "page_no")
        
        parm.updateValue(sp_getString(string: self.status), forKey: "status")
        self.requestModel.parm = parm
        SPAppraisalRequest.sp_getUserAppraisalList(requestModel: self.requestModel, complete: { [weak self](code, list, errorModel, total) in
             self?.sp_dealRequestComplete(code: code, list: list, errorModel: errorModel, total: total)
        }) { [weak self](true_count, false_count) in
            self?.sp_dealCountComplete(true_count: true_count, false_count: false_count)
        }
    }
    
    private func sp_dealRequestComplete(code : String , list : [Any]? ,errorModel : SPRequestError?,total:Int){
        if code == SP_Request_Code_Success {
            if self.currentPage <= 1 {
                self.dataArray?.removeAll()
            }
            if let array : [SPAppraisalProductModel] = self.dataArray , let l : [SPAppraisalProductModel] = list as? [SPAppraisalProductModel] {
                self.dataArray = array + l
            }else{
                self.dataArray = list as? [SPAppraisalProductModel]
            }
        }
        if self.currentPage > 1 && sp_getArrayCount(array: list) <= 0 {
            self.currentPage = self.currentPage - 1
            if self.currentPage < 1 {
                self.currentPage = 1
            }
        }
        sp_dealNoData()
    }
    private func sp_dealCountComplete(true_count : String,false_count:String){
        guard let block = self.countComplete else {
            return
        }
        block(true_count,false_count)
    }
}
