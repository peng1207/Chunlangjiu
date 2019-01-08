//
//  SPSortVC.swift
//  Chunlangjiu
//
//  Created by 黄树鹏 on 2018/7/4.
//  Copyright © 2018年 Chunlang. All rights reserved.
//
// 分类
import Foundation
import SnapKit

class SPSortVC: SPBaseVC {
    fileprivate lazy var searchView : SPSearchView = {
        var view  = SPSearchView(frame:  CGRect(x: 0, y: 0, width: sp_getScreenWidth() - 80 , height: 30))
        view.didClickBlock = {  [weak self]()-> Bool in
            self?.sp_pushSearchVC()
            return false
        }
        return view
    }()
    lazy var sortMainVC : SPSortMainVC = {
        let sortVC = SPSortMainVC()
        sortVC.selectBlock = { [weak self]( model) in
            self?.sp_dealMainSortSelect(model: model)
        }
        return sortVC
    }()
    lazy var multistageVC : SPSortMultistageVC = {
      return SPSortMultistageVC()
    }()
    fileprivate lazy var nodataBtn : UIButton = {
        let btn = UIButton(type: UIButtonType.custom)
        btn.setTitle("没有数据，点击重试", for: UIControlState.normal)
        btn.setTitleColor(SPColorForHexString(hex: SP_HexColor.color_ffffff.rawValue), for: UIControlState.normal)
        btn.titleLabel?.font = sp_getFontSize(size: 16)
        btn.backgroundColor = SPColorForHexString(hex: SP_HexColor.color_b31f3f.rawValue)
        btn.sp_cornerRadius(cornerRadius: 20)
        btn.isHidden = true
        btn.addTarget(self, action: #selector(sp_sendRequestSort), for: UIControlEvents.touchUpInside)
        return btn
    }()
    fileprivate lazy var searchBtn : UIButton = {
        let btn = UIButton(type: UIButtonType.custom)
        btn.setImage(UIImage(named: "public_search_white"), for: UIControlState.normal)
        btn.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        return btn
    }()
    fileprivate var collectionView : UICollectionView!
    fileprivate let collectionSortCellID = "collectionSortCellID"
    fileprivate var dataArray : [SPSortLv3Model]?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "分类"
        self.sp_setupUI()
        sp_sendRequestSort()
        sp_addNotification()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       
    }
    override func sp_setupUI() {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 5, left: 10, bottom: 0, right: 10)
        layout.minimumInteritemSpacing = 5
        self.collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        self.collectionView.backgroundColor = self.view.backgroundColor
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.register(SPSortCollectCell.self, forCellWithReuseIdentifier: collectionSortCellID)
        self.collectionView.showsVerticalScrollIndicator = false
        self.view.addSubview(self.collectionView)
//        self.view.addSubview(self.sortMainVC.view)
//        self.addChildViewController(self.sortMainVC)
//        self.view.addSubview(self.multistageVC.view)
//        self.addChildViewController(self.multistageVC)
        self.view.addSubview(self.nodataBtn)
//        self.searchBtn.addTarget(self, action: #selector(clickSearchAction), for: UIControlEvents.touchUpInside)
//        let searchItem = UIBarButtonItem(customView: self.searchBtn)
//        self.navigationItem.rightBarButtonItem =  searchItem
        self.sp_addConstraint()
    }
}

fileprivate extension SPSortVC{
    /// 添加约束
    fileprivate func sp_addConstraint(){
        self.collectionView.snp.makeConstraints { (maker) in
            maker.left.right.top.equalTo(self.view).offset(0)
            if #available(iOS 11.0, *) {
                maker.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(0)
            } else {
                // Fallback on earlier versions
                maker.bottom.equalTo(self.view.snp.bottom).offset(0)
            }
        }
//        self.sortMainVC.view.snp.makeConstraints { (maker) in
//            maker.left.top.equalTo(self.view).offset(0)
//            if #available(iOS 11.0, *) {
//                maker.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(0)
//            } else {
//                // Fallback on earlier versions
//                 maker.bottom.equalTo(self.view.snp.bottom).offset(0)
//            }
//            maker.width.equalTo(105)
//        }
//        self.multistageVC.view.snp.makeConstraints { (maker) in
//            maker.top.right.equalTo(self.view).offset(0)
//            maker.left.equalTo(self.sortMainVC.view.snp.right).offset(0)
//            maker.bottom.equalTo(self.sortMainVC.view.snp.bottom).offset(0)
//        }
        self.nodataBtn.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.view).offset(20)
            maker.right.equalTo(self.view).offset(-20)
            maker.centerY.equalTo(self.view).offset(0)
            maker.height.equalTo(40)
        }
    }
}
extension SPSortVC : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sp_getArrayCount(array: self.dataArray) > 0 ? 1 : 0
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sp_getArrayCount(array: self.dataArray)
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell : SPSortCollectCell = collectionView.dequeueReusableCell(withReuseIdentifier: collectionSortCellID, for: indexPath) as! SPSortCollectCell
        if indexPath.row < sp_getArrayCount(array: self.dataArray) {
            cell.model = self.dataArray?[indexPath.row]
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width =  NSInteger((collectionView.frame.size.width - 25) / 2.0)
        return  CGSize(width: CGFloat(width), height:  (CGFloat(width) * SP_PRODUCT_SCALE ) + 50 )
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row < sp_getArrayCount(array: self.dataArray) {
            let productVC = SPProductListVC()
            productVC.sortLv3Model = self.dataArray?[indexPath.row]
            self.navigationController?.pushViewController(productVC, animated: true)
        }
    }
}
fileprivate extension SPSortVC {
    @objc fileprivate func sp_sendRequest(){
        sp_showAnimation(view: self.view, title: nil)
        SPAppRequest.sp_getCategory(requestModel: self.requestModel) {  [weak self](code, list, errorModel,totalPage) in
            self?.sp_dealRequest(code: code, list: list, errorModel: errorModel)
        }
    }
    fileprivate func sp_dealRequest(code:String,list:[Any]?,errorModel:SPRequestError?) {
        if sp_getArrayCount(array: list) > 0  {
            self.sortMainVC.dataArray = list as? Array<SPSortRootModel>
          
        }
        self.sp_dealNoBtnData()
        sp_hideAnimation(view: self.view)
    }
    fileprivate func sp_dealNoBtnData() {
        if sp_getArrayCount(array: self.dataArray) > 0 {
            self.nodataBtn.isHidden = true
        }else{
            self.nodataBtn.isHidden = false
        }
       
    }
    /// 处理主分类选择的回调
    ///
    /// - Parameter model: model
    fileprivate func sp_dealMainSortSelect(model:SPSortRootModel){
        self.multistageVC.rootModel = model
    }
    /// 获取分类
   @objc fileprivate func sp_sendRequestSort(){
        let request = SPRequestModel()
        SPAppRequest.sp_getCategory(requestModel: request) { [weak self](code, list, errorModel,totalPage) in
            self?.sp_dealSortRequest(code: code, list: list, errorModel: errorModel)
        }
    }
    fileprivate func sp_dealSortRequest(code:String,list:[Any]?,errorModel:SPRequestError?) {
        if code == SP_Request_Code_Success {
            self.dataArray = list as? [SPSortLv3Model]
            self.collectionView.reloadData()
        }
        sp_dealNoBtnData()
    }
}
// MARK: - action
extension SPSortVC{
    fileprivate func sp_pushSearchVC(){
        let searchVC = SPProductSearchVC()
        self.navigationController?.pushViewController(searchVC, animated: true)
    }
    ///  点击搜索按钮
    @objc fileprivate func clickSearchAction(){
        let searchVC = SPProductSearchVC()
        self.navigationController?.pushViewController(searchVC, animated: true)
    }
}
// MARK: - notification
extension SPSortVC {
    fileprivate func sp_addNotification(){
            NotificationCenter.default.addObserver(self, selector: #selector(sp_netChange), name: NSNotification.Name(SP_NETWORK_NOTIFICATION), object: nil)
    }
    @objc fileprivate func sp_netChange(){
        if SPNetWorkManager.sp_notReachable() == false {
            // 有网络
            if sp_getArrayCount(array: self.dataArray) <= 0 {
                sp_sendRequestSort()
            }
        }
    }
}
