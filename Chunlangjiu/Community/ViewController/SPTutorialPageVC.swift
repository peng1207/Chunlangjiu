//
//  SPTutorialPageVC.swift
//  Chunlangjiu
//
//  Created by chengzong liang on 2018/12/6.
//  Copyright © 2018年 Chunlang. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

/// 教程页
class SPTutorialPageVC : SPBaseVC{
    
    fileprivate var collectionView : UICollectionView!
    fileprivate lazy var skipBtn : UIButton = {
        let btn = UIButton(type: UIButtonType.custom)
        btn.setTitle("跳过", for: UIControlState.normal)
        btn.setTitleColor(UIColor.white, for: UIControlState.normal)
        btn.backgroundColor = SPColorForHexString(hex: SP_HexColor.color_000000.rawValue).withAlphaComponent(0.3)
        btn.sp_cornerRadius(cornerRadius: 15)
        btn.addTarget(self, action: #selector(sp_clickAdvert), for: UIControlEvents.touchUpInside)
        return btn
    }()
    fileprivate let tutorialPageCellID = "tutorialPageCellID"
    fileprivate lazy var imgArray : [UIImage] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        sp_setupUI()
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
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    /// 赋值
    fileprivate func sp_setupData(){
       
        if let img =  UIImage(named: "public_tutorialPage_1")  {
            imgArray.append(img)
        }
        if let img = UIImage(named: "public_tutorialPage_2") {
            imgArray.append(img)
        }
        if let img = UIImage(named: "public_tutorialPage_3") {
            imgArray.append(img)
        }
        self.collectionView.reloadData()
    }
    /// 添加UI
    override func sp_setupUI(){
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        self.collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.backgroundColor = UIColor.white
        self.collectionView.isPagingEnabled = true
        self.collectionView.register(SPTutorialPageCollectCell.self, forCellWithReuseIdentifier: tutorialPageCellID)
        self.view.addSubview(self.collectionView)
//        self.view.addSubview(self.skipBtn)
        self.sp_addConstraint()
    }
    /// 添加约束
    fileprivate func sp_addConstraint(){
        self.collectionView.snp.makeConstraints { (maker) in
            maker.left.right.top.bottom.equalTo(self.view).offset(0)
        }
//        self.skipBtn.snp.makeConstraints { (maker) in
//            maker.height.equalTo(30)
//            maker.width.equalTo(60)
//            maker.right.equalTo(self.view.snp.right).offset(-20)
//            maker.top.equalTo(self.view.snp.top).offset(sp_getstatusBarHeight() + 20)
//        }
    }
    
}
extension SPTutorialPageVC {
    @objc fileprivate func sp_clickAdvert(){
        SPAPPManager.sp_showMainVC()
    }
}
extension SPTutorialPageVC : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sp_getArrayCount(array: self.imgArray) > 0 ? 1 : 0
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sp_getArrayCount(array: self.imgArray)
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell : SPTutorialPageCollectCell = collectionView.dequeueReusableCell(withReuseIdentifier: tutorialPageCellID, for: indexPath) as! SPTutorialPageCollectCell
        if  indexPath.row < sp_getArrayCount(array: self.imgArray) {
            cell.imageView.image = self.imgArray[indexPath.row]
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.frame.size
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        sp_clickAdvert()
    }
}


class SPTutorialPageCollectCell : UICollectionViewCell{
    lazy var imageView : UIImageView = {
        return UIImageView()
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        sp_setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// 添加UI
    func sp_setupUI(){
        self.contentView.addSubview(self.imageView)
        sp_addConstraint()
    }
    
    /// 添加约束
    fileprivate func sp_addConstraint(){
        self.imageView.snp.makeConstraints { (maker) in
            maker.left.right.top.bottom.equalTo(self.contentView).offset(0)
        }
    }
}
