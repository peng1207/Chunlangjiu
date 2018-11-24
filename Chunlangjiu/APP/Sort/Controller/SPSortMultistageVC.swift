//
//  SPSortMultistageVC.swift
//  Chunlangjiu
//
//  Created by 黄树鹏 on 2018/7/4.
//  Copyright © 2018年 Chunlang. All rights reserved.
//

import Foundation
import SnapKit
class SPSortMultistageVC: SPBaseVC  {
    var collectionView : UICollectionView!
    let multistageCellID = "multistageCellID"
    let multistageHeadID = "multistageHeadID"
    var rootModel : SPSortRootModel?{
        didSet{
            self.collectionView.reloadData()
            self.collectionView.setContentOffset(CGPoint.zero, animated: false)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
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
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        self.collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.backgroundColor = UIColor.white
        self.collectionView.register(SPSortMultistageCollectCell.self, forCellWithReuseIdentifier: multistageCellID)
        self.collectionView.register(SPSortMultistageCollectHeadView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: multistageHeadID)
        self.view.addSubview(self.collectionView)
        self.sp_addConstraint()
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
extension SPSortMultistageVC : UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        if let model = self.rootModel {
            return sp_getArrayCount(array: model.lv2)
        }
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let model = self.rootModel {
            if section <  sp_getArrayCount(array: model.lv2) {
                let lv2Model = model.lv2![section]
                return sp_getArrayCount(array: lv2Model.lv3)
            }
        }
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell : SPSortMultistageCollectCell = collectionView.dequeueReusableCell(withReuseIdentifier: multistageCellID, for: indexPath) as! SPSortMultistageCollectCell
        if let model = self.rootModel {
            if indexPath.section <  sp_getArrayCount(array: model.lv2) {
                let lv2Model = model.lv2![indexPath.section]
                if indexPath.row < sp_getArrayCount(array: lv2Model.lv3){
                    cell.lv3Model = lv2Model.lv3?[indexPath.row]
                }
            }
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width =   NSInteger( collectionView.frame.size.width / 3.0)
        return  CGSize(width: width, height: width + 30 + 10)
    }
    // 返回cell 上下左右的间距
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
         return  UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
          return CGSize(width: collectionView.frame.size.width, height: 40)
    }
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headerView : SPSortMultistageCollectHeadView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: multistageHeadID, for: indexPath as IndexPath) as! SPSortMultistageCollectHeadView
        if let model = self.rootModel {
            if indexPath.section <  sp_getArrayCount(array: model.lv2) {
                let lv2Model = model.lv2![indexPath.section]
               headerView.titleLabel.text = sp_getString(string: lv2Model.cat_name)
            }
        }
        return headerView
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let model = self.rootModel {
            if indexPath.section <  sp_getArrayCount(array: model.lv2) {
                let lv2Model = model.lv2![indexPath.section]
                if indexPath.row < sp_getArrayCount(array: lv2Model.lv3){
                    self.pushProductVC(sortLv2Model: lv2Model, sortLv3Model: lv2Model.lv3![indexPath.row])
                }
            }
        }
       
    }
}
//MARK: - 跳转或事件
extension SPSortMultistageVC{
    fileprivate func pushProductVC(sortLv2Model:SPSortLv2Model?,sortLv3Model : SPSortLv3Model){
        let productListVC = SPProductListVC()
        productListVC.rootModel = self.rootModel
        productListVC.sortLv2Model = sortLv2Model
        productListVC.sortLv3Model = sortLv3Model
        self.navigationController?.pushViewController(productListVC, animated: true)
        
    }
}
