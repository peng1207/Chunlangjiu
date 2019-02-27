//
//  SPProductSearchVC.swift
//  Chunlangjiu
//
//  Created by 黄树鹏 on 2018/7/6.
//  Copyright © 2018年 Chunlang. All rights reserved.
//

import Foundation
import SnapKit
class SPProductSearchVC: SPBaseVC {
    fileprivate lazy var searchView : SPSearchView = {
        var view  = SPSearchView(frame:  CGRect(x: 0, y: 0, width: sp_getScreenWidth() - 120, height: 30))
        view.searchBlock = {  [weak self](text) in
            self?.sp_clickSearch(text: sp_getString(string: text))
        }
        return view
    }()
    fileprivate lazy var listBtn  : UIButton = {
        let btn = UIButton(type: UIButtonType.custom)
        btn.setImage(UIImage(named: "public_list"), for: UIControlState.normal)
        btn.setImage(UIImage(named: "public_abreast"), for: UIControlState.selected)
        btn.setTitleColor(SPColorForHexString(hex: SP_HexColor.color_ffffff.rawValue), for: UIControlState.normal)
        btn.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        btn.isHidden = true
        btn.addTarget(self, action: #selector(clickListAction), for: UIControlEvents.touchUpInside)
        return btn
    }()
    fileprivate lazy var searchBtn : UIButton = {
        let btn = UIButton(type: UIButtonType.custom)
        btn.setImage(UIImage(named: "public_search_white"), for: UIControlState.normal)
        btn.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
  
        btn.addTarget(self, action: #selector(sp_clickSearchBtn), for: UIControlEvents.touchUpInside)
        return btn
    }()
    fileprivate let SPProductSearchCollectCellID = "SPProductSearchCollectCellID"
    fileprivate let SPProductSearchHeaderID = "SPProductSearchHeaderID"
    fileprivate let SPProductSearchFooterID = "SPProductSearchFooterID"
    fileprivate lazy var collectionView : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 0
       
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 10)
        let view = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        view.delegate = self
        view.dataSource = self
        view.backgroundColor = UIColor.white
        view.isScrollEnabled = true
        view.showsVerticalScrollIndicator = false
        view.showsHorizontalScrollIndicator = false
        view.register(SPProductSearchCollectCell.self, forCellWithReuseIdentifier: SPProductSearchCollectCellID)
        view.register(SPProductSearchHeaderView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: SPProductSearchHeaderID)
        view.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: SPProductSearchFooterID)
        return view
    }()
    fileprivate var dataAray : Array<SPSearchRecord>?
    fileprivate var productVC : SPProductListVC?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.sp_setupUI()
        sp_getLocalData()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(sp_keyboardShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    /// 创建UI
    override func sp_setupUI() {
        self.navigationItem.titleView = self.searchView
      
         self.view.addSubview(self.collectionView)
        self.sp_addSearchBtn()
        self.sp_addConstraint()
   
    }
    /// 添加搜索按钮
    fileprivate func sp_addSearchBtn(){
         self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: self.searchBtn)
    }
    
    /// 添加约束
    fileprivate func sp_addConstraint(){
        self.collectionView.snp.makeConstraints { (maker) in
            maker.left.top.right.equalTo(self.view).offset(0)
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
extension SPProductSearchVC : UICollectionViewDelegate ,UICollectionViewDataSource ,UICollectionViewDelegateFlowLayout{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sp_getArrayCount(array: self.dataAray) > 0 ? 1 : 0
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sp_getArrayCount(array: self.dataAray)
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell : SPProductSearchCollectCell = collectionView.dequeueReusableCell(withReuseIdentifier: SPProductSearchCollectCellID, for: indexPath) as! SPProductSearchCollectCell
        if indexPath.row < sp_getArrayCount(array: self.dataAray) {
            let model = self.dataAray?[indexPath.row]
            cell.titleLabel.text = sp_getString(string: model?.searchValue)
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.size.width, height: 44)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.row < sp_getArrayCount(array: self.dataAray) {
            let model = self.dataAray?[indexPath.row]
            return CGSize(width: CGFloat((model?.textWidth)!), height: 27)
        }
        return CGSize.zero
    }
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        var reusableView : UICollectionReusableView!
        if kind == UICollectionElementKindSectionHeader{
            reusableView  = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier:SPProductSearchHeaderID, for: indexPath) as! SPProductSearchHeaderView
            let view = reusableView as! SPProductSearchHeaderView
            view.deleteBlock = { [weak self]()in
                self?.sp_deleteDB()
            }
            
        }else if kind == UICollectionElementKindSectionFooter {
            reusableView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionFooter, withReuseIdentifier: SPProductSearchFooterID, for: indexPath)
            reusableView.backgroundColor = SPColorForHexString(hex: SP_HexColor.color_eeeeee.rawValue)
        }
        return reusableView
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.size.width, height: 10)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row < sp_getArrayCount(array: self.dataAray) {
             let model = self.dataAray?[indexPath.row]
            
            sp_clickSearch(text: sp_getString(string: model?.searchValue))
        }
    }
}
extension SPProductSearchVC {
    /// 点击列表按钮
    @objc fileprivate func clickListAction(){
        self.listBtn.isSelected = !self.listBtn.isSelected
        self.productVC?.isH = self.listBtn.isSelected
    }
    @objc fileprivate func sp_clickSearchBtn(){
        sp_clickSearch(text: sp_getString(string: self.searchView.searchTextFiled.text))
    }
    /// 获取本地数据
    fileprivate func sp_getLocalData(){
      self.dataAray = SPRealmTool.sp_getProductSearch()
      self.collectionView.reloadData()
    }
    
    fileprivate func sp_clickSearch(text : String){
        if sp_getString(string: text).count > 0 {
            sp_hideKeyboard()
            sp_setupVC()
            self.productVC?.keywords = text
            self.productVC?.sp_searchRequest()
            self.listBtn.isHidden = false
            let listBtnItem = UIBarButtonItem(customView: self.listBtn )
            self.navigationItem.rightBarButtonItem = listBtnItem
            sp_saveSearchText(text: text)
            self.searchView.searchTextFiled.text = sp_getString(string: text)
        }else{
            sp_showTextAlert(tips: "请输入商品关键字")
        }
    }
    fileprivate func sp_setupVC(){
        if self.productVC == nil {
            self.productVC = SPProductListVC()
            self.productVC?.canRequest = false
            self.view.addSubview((self.productVC?.view)!)
            self.addChildViewController(self.productVC!)
            self.productVC?.view.snp.makeConstraints { (maker) in
                maker.left.right.top.equalTo(self.view).offset(0)
                if #available(iOS 11.0, *) {
                    maker.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(0)
                } else {
                   maker.bottom.equalTo(self.view.snp.bottom).offset(0)
                }
            }
        }
        
    }
    /// 保存搜索数据
    ///
    /// - Parameter text: 搜索数据
    fileprivate func sp_saveSearchText(text:String){
        let model = SPSearchRecord()
        model.searchValue = text
        SPRealmTool.sp_insert(searchRecord: model)
    }
    /// 删除数据
    fileprivate func sp_deleteDB(){
        SPRealmTool.sp_delete(list: self.dataAray)
        self.dataAray?.removeAll()
        self.collectionView.reloadData()
    }
}
extension SPProductSearchVC {
    
    /// 键盘升起
    @objc fileprivate func sp_keyboardShow(){
        self.sp_addSearchBtn()
    }
    
}
