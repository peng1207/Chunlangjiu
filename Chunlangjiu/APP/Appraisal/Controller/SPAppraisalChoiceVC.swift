
//
//  SPAppraisalChoiceVC.swift
//  Chunlangjiu
//
//  Created by 黄树鹏 on 2019/4/13.
//  Copyright © 2019 Chunlang. All rights reserved.
//
// 选择鉴定师

import Foundation
import SnapKit
class SPAppraisalChoiceVC: SPBaseVC {
    fileprivate var collectionView : UICollectionView!
    fileprivate var dataArray : [SPAppraisalInfoModel]?
    fileprivate lazy var headerView : SPAppraisalChoiceHeadView = {
        let view = SPAppraisalChoiceHeadView()
        view.clickBlock = { [weak self] in
            self?.sp_pushGuideVC()
        }
        return view
    }()
    fileprivate let cellID = "SPAppraisalChoiceCellID"
    fileprivate let headerID = "SPAppraisalChoiceHeaderID"
    fileprivate var currentPage = 1
    fileprivate var count : String?
    fileprivate var content : String?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.sp_setupUI()
        sp_showAnimation(view: self.view, title: nil)
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
    /// 创建UI
    override func sp_setupUI() {
        self.navigationItem.title = "选择鉴定师"
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 5
        layout.minimumInteritemSpacing = 5
        layout.sectionInset = UIEdgeInsets(top: 5, left: 10, bottom: 0, right: 10)
        self.collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.backgroundColor = self.view.backgroundColor
        self.collectionView.alwaysBounceVertical = true
        self.collectionView.register(SPAppraisalInfoCollectionCell.self, forCellWithReuseIdentifier: self.cellID)
//        self.collectionView.register(SPAppraisalChoiceHeadView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: self.headerID)
        self.collectionView.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: self.headerID)
        self.collectionView.showsVerticalScrollIndicator = false
        self.view.addSubview(self.collectionView)
        self.collectionView.sp_headerRefesh { [weak self] in
            self?.currentPage = 1
            self?.sp_sendRequest()
        }
        self.collectionView.sp_footerRefresh {  [weak self] in
            if let page = self?.currentPage {
                self?.currentPage = page + 1
                self?.sp_sendRequest()
            }
        }
        self.sp_addConstraint()
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

extension SPAppraisalChoiceVC {
    
    fileprivate func sp_pushInfoVC(model : SPAppraisalInfoModel?){
        let vc = SPAppraisalInfoVC()
        vc.infoModel = model
        self.navigationController?.pushViewController(vc, animated: true)
    }
    fileprivate func sp_pushGuideVC(){
        let vc = SPAppraisalGuideVC()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
extension SPAppraisalChoiceVC : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sp_getArrayCount(array: self.dataArray) + 1
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell : SPAppraisalInfoCollectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: self.cellID, for: indexPath) as! SPAppraisalInfoCollectionCell
        if indexPath.row < sp_getArrayCount(array: self.dataArray) {
            let model = self.dataArray?[indexPath.row]
            cell.model = model
        }else{
            cell.model = nil
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = NSInteger((collectionView.frame.size.width - 25 ) / 2.0 )
        return CGSize(width: width, height: 200)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row < sp_getArrayCount(array: self.dataArray) {
            sp_pushInfoVC(model: self.dataArray?[indexPath.row])
        }else{
            let alertController = UIAlertController(title: "提示", message: "“若想成为鉴定师，可拨打400-189-0095”联系平台申请！", preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "联系", style: UIAlertActionStyle.default, handler: { (action) in
                 sp_openTel(text: "400-189-0095")
            }))
            let canceAction = UIAlertAction(title: "取消", style: UIAlertActionStyle.cancel) { (action) in
                
            }
            alertController.addAction(canceAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.size.width, height: 153)
    }
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
      let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: self.headerID, for: indexPath)
        sp_log(message: "----------")
        sp_log(message: header.subviews)
        header.addSubview(self.headerView)
        self.headerView.snp.remakeConstraints { (maker) in
            maker.left.right.top.bottom.equalTo(header).offset(0)
        }
        return header
//        let headerView :SPAppraisalChoiceHeadView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: self.headerID, for: indexPath) as! SPAppraisalChoiceHeadView
//        headerView.clickBlock = { [weak self] in
//            self?.sp_pushGuideVC()
//        }
//        headerView.num = count
//        headerView.content = content
//        return headerView
    }
}

extension SPAppraisalChoiceVC {
    
    fileprivate func sp_sendRequest(){
        var parm = [String : Any]()
        parm.updateValue(self.currentPage, forKey: "page_no")
        self.requestModel.parm = parm
        SPAppraisalRequest.sp_getGemmologistList(requestModel: self.requestModel, complete: { [weak self](code, list, errorModel, total) in
            self?.sp_dealListRequest(code: code, list: list, errorModel: errorModel, totalPage: total)
        }) { [weak self](count, content) in
            self?.count = count
            self?.content = content
            self?.sp_dealNum()
        }
    }
    fileprivate func sp_dealNum(){
        self.headerView.num = count
        self.headerView.content = content
    }
    fileprivate func sp_dealListRequest(code : String , list: [Any]?,errorModel : SPRequestError?,totalPage : Int){
        sp_hideAnimation(view: self.view)
        if code == SP_Request_Code_Success {
            if self.currentPage <= 1 {
                self.dataArray?.removeAll()
            }
            if let array : [SPAppraisalInfoModel] = self.dataArray , let l : [SPAppraisalInfoModel] = list as? [SPAppraisalInfoModel] {
                self.dataArray = array + l
            }else{
                self.dataArray = list as? [SPAppraisalInfoModel]
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
