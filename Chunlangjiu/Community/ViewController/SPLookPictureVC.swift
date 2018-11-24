//
//  SPLookPictureVC.swift
//  Chunlangjiu
//
//  Created by chengzong liang on 2018/9/29.
//  Copyright © 2018年 Chunlang. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

class SPLookPictureVC :  SPBaseVC{
    
    fileprivate var collectionView : UICollectionView!
    fileprivate let lookPictureCellID = "lookPictureCellID"
    var pageControl : WEIPageControl = {
        let control = WEIPageControl()
        control.currentWidthMultiple = 3;
        control.pointSize = CGSize(width: 9, height: 9)
        control.currentColor = SPColorForHexString(hex: SP_HexColor.color_b31f3f.rawValue)
        control.otherColor = SPColorForHexString(hex: SP_HexColor.color_000000.rawValue).withAlphaComponent(0.2)
        return control
    }()
    fileprivate lazy var backBtn : UIButton = {
        let btn = UIButton(type: .custom)
        btn.setImage(UIImage(named: "public_back_wither"), for: .normal)
        
//        btn.contentEdgeInsets = UIEdgeInsets(top: 0, left: -30, bottom: 0, right: 0)
        btn.addTarget(self, action: #selector(sp_clickBackAction), for: UIControlEvents.touchUpInside)
        return btn
    }()
    
    var dataArray : [Any]?
    var selectIndex : Int! = 0
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
    override func sp_clickBackAction() {
        self.dismiss(animated: true, completion: nil)
    }
    fileprivate func sp_setupData(){
        if self.selectIndex < sp_getArrayCount(array: self.dataArray) {
            sp_asyncAfter(time: 0.1) {
                self.collectionView.scrollToItem(at: IndexPath(item: self.selectIndex, section: 0), at: UICollectionViewScrollPosition.centeredHorizontally, animated: false)
//                self.collectionView.selectItem(at: IndexPath(item: self.selectIndex, section: 0), animated: true, scrollPosition: UICollectionView.ScrollPosition.centeredHorizontally)
                  self.pageControl.currentPage = self.selectIndex
            }
          
           
            
        }
        
    }
    /// 创建UI
    override func sp_setupUI() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        
        self.collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.backgroundColor = UIColor.white
        self.collectionView.isPagingEnabled = true
        self.collectionView.showsHorizontalScrollIndicator = false
        self.collectionView.register(SPLookPictureCollectCell.self, forCellWithReuseIdentifier: lookPictureCellID)
        self.view.addSubview(self.collectionView)
        self.view.addSubview(self.pageControl)
        self.view.addSubview(self.backBtn)
        self.pageControl.numberOfPages = sp_getArrayCount(array: self.dataArray)
        self.sp_addConstraint()
    }
    /// 添加约束
    fileprivate func sp_addConstraint(){
        self.collectionView.snp.makeConstraints { (maker ) in
            maker.left.top.right.equalTo(self.view).offset(0)
            if #available(iOS 11.0, *) {
                maker.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(0)
            } else {
                maker.bottom.equalTo(self.view.snp.bottom).offset(0)
            }
        }
        self.pageControl.snp.makeConstraints { (maker) in
            maker.left.right.equalTo(self.view).offset(0)
            maker.height.equalTo(10)
            if #available(iOS 11.0, *) {
                maker.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(-10)
            } else {
                maker.bottom.equalTo(self.view.snp.bottom).offset(-10)
            }
        }
        self.backBtn.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.view).offset(10)
            maker.top.equalTo(self.view).offset(sp_getstatusBarHeight())
            maker.width.equalTo(30)
            maker.height.equalTo(30)
        }
    }
    deinit {
        
    }
}
extension SPLookPictureVC :  UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sp_getArrayCount(array: self.dataArray) > 0 ? 1 : 0
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sp_getArrayCount(array: self.dataArray)
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell : SPLookPictureCollectCell = collectionView.dequeueReusableCell(withReuseIdentifier: lookPictureCellID, for: indexPath) as! SPLookPictureCollectCell
        if  indexPath.row < sp_getArrayCount(array: self.dataArray) {
            let data = self.dataArray?[indexPath.row]
            if data  is String {
                cell.imageView.sp_cache(string: sp_getString(string: data), plImage: sp_getDefaultImg())
            }else if data is UIImage {
                cell.imageView.image = data as? UIImage
            }else  {
                cell.imageView.image = nil
            }
        
        }
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.frame.size
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.dismiss(animated: true, completion: nil)
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let page = scrollView.contentOffset.x / scrollView.frame.size.width
        self.pageControl.currentPage = Int(page)
    }
}
