//
//  SPAppraisalInfoVC.swift
//  Chunlangjiu
//
//  Created by 黄树鹏 on 2019/4/13.
//  Copyright © 2019 Chunlang. All rights reserved.
//
// 鉴定师信息

import Foundation
import SnapKit
class SPAppraisalInfoVC: SPBaseVC {
    fileprivate var collectionView : UICollectionView!
    fileprivate lazy var infoView : SPAppraisalInfoView = {
        let view = SPAppraisalInfoView()
        view.backgroundColor = SPColorForHexString(hex: SP_HexColor.color_ffffff.rawValue)
        view.clickBlock = { [weak self] in
            self?.sp_pushWineVC()
        }
        return view
    }()
    fileprivate var dataArray : [SPAppraisalProductModel]?
    fileprivate let cellID = "SPAppraisalInfoCellID"
    fileprivate let headerID = "SPAppraisalInfoHeaderID"
    fileprivate var headerHeight : CGFloat = 100
    fileprivate var currentPage : Int = 1
    var infoModel : SPAppraisalInfoModel?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.sp_setupUI()
        sp_setupData()
        sp_sendRequest()
     
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
           sp_sendInfoRequest()
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
        self.navigationItem.title = "鉴定师"
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
        self.collectionView.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: self.headerID)
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
        self.sp_addConstraint()
    }
    /// 赋值
    fileprivate func sp_setupData(){
        self.infoView.model = self.infoModel
        self.infoView.setNeedsLayout()
        self.infoView.layoutIfNeeded()
        self.headerHeight = infoView.systemLayoutSizeFitting(UILayoutFittingCompressedSize).height + 9.0
        self.collectionView.reloadData()
    }
    /// 处理有没数据
    override func sp_dealNoData(){
        self.collectionView.sp_stopFooterRefesh()
        self.collectionView.sp_stopHeaderRefesh()
        self.collectionView.reloadData()
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
    }
    deinit {
        
    }
}
extension SPAppraisalInfoVC : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sp_getArrayCount(array: self.dataArray)
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell : SPAppraisalProductCollectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: self.cellID, for: indexPath) as! SPAppraisalProductCollectionCell
        if indexPath.row < sp_getArrayCount(array: self.dataArray){
            let model = self.dataArray?[indexPath.row]
            cell.model = model
            if sp_getString(string: model?.status) == SPAPPraisalProductStatus_True {
                cell.doneBtn.setTitle("鉴定报告", for: UIControlState.normal)
            }else{
                cell.doneBtn.setTitle("待鉴定", for: UIControlState.normal)
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
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: self.headerID, for: indexPath)
        headerView.addSubview(self.infoView)
        self.infoView.snp.makeConstraints { (maker) in
            maker.left.equalTo(headerView).offset(10)
            maker.right.equalTo(headerView).offset(-10)
            maker.top.equalTo(headerView).offset(5)
            maker.height.greaterThanOrEqualTo(0)
            maker.bottom.equalTo(headerView).offset(-4)
        }
        return headerView
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.size.width, height: self.headerHeight)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row < sp_getArrayCount(array: self.dataArray) {
            sp_dealSelect(model:self.dataArray?[indexPath.row])
        }
    }
}
extension SPAppraisalInfoVC {
    
    fileprivate func sp_pushResult(model : SPAppraisalProductModel?){
        let vc = SPAppraisalResultVC()
        vc.chateau_id = model?.chateau_id
        self.navigationController?.pushViewController(vc, animated: true)
    }
    fileprivate func sp_pushWineVC(){
        if SPAPPManager.sp_isLogin(isPush: true){
            let vc = SPWineValuationVC()
            vc.authenticate_id = sp_getString(string: self.infoModel?.authenticate_id)
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    fileprivate func sp_dealSelect(model : SPAppraisalProductModel?){
        guard let m = model else {
            return
        }
        sp_pushResult(model: m)
    }
    
}
extension SPAppraisalInfoVC {
    
    fileprivate func sp_sendInfoRequest(){
        var parm = [String : Any]()
        parm.updateValue(sp_getString(string: self.infoModel?.authenticate_id), forKey: "authenticate_id")
        let rModel = SPRequestModel()
        rModel.parm = parm
        SPAppraisalRequest.sp_getAppraisalInfo(requestModel: rModel) { [weak self](code , model, errorModel) in
            if code == SP_Request_Code_Success{
                model?.authenticate_id = self?.infoModel?.authenticate_id
                self?.infoModel = model
                self?.sp_setupData()
            }
            
        }
        
        
    }
    fileprivate func sp_sendRequest(){
        var parm = [String : Any]()
        parm.updateValue(sp_getString(string: self.infoModel?.authenticate_id), forKey: "authenticate_id")
        parm.updateValue(self.currentPage, forKey: "page_no")
        parm.updateValue("true", forKey: "status")
        self.requestModel.parm = parm
        SPAppraisalRequest.sp_getAppraisalList(requestModel: self.requestModel) { [weak self](code , list, errorModel, total) in
            self?.sp_dealRequestComplete(code: code, list: list, errorModel: errorModel, total: total)
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
    
}
