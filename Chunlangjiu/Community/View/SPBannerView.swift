//
//  SPBannerView.swift
//  Chunlangjiu
//
//  Created by 黄树鹏 on 2018/7/8.
//  Copyright © 2018年 Chunlang. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

/// 获取每个section的row
typealias SPBannerNumBlock = (_ section : Int) -> Int
/// 设置cell的值
typealias SPBannerCellBlock = (_ imageView : UIImageView,_ row : Int) -> Void
/// 选择的回调
typealias SPBannerSelectBlock = (_ row : Int) -> Void

class SPBannerView:  UIView{
    fileprivate var collectionView : UICollectionView!
    fileprivate let bannerCellID = "bannerCellID"
    var pageControl : WEIPageControl = {
        let control = WEIPageControl()
        control.currentWidthMultiple = 3;
        control.pointSize = CGSize(width: 9, height: 9)
        control.currentColor = UIColor.white
        control.otherColor = SPColorForHexString(hex: SP_HexColor.color_000000.rawValue).withAlphaComponent(0.2)
        return control
    }()
    var numBlock : SPBannerNumBlock?
    var cellBlock : SPBannerCellBlock?
    var selectBlock : SPBannerSelectBlock?
    /// 是否循环
    var isLoop : Bool = true
    /// 是否启动自动播放
    var isAutoPaly : Bool! {
        didSet {
            self.dealTimer()
        }
    }
    fileprivate var numCount : Int! {
        didSet{
            if numCount != self.pageControl.numberOfPages {
                 self.pageControl.numberOfPages = numCount
                self.dealTimer()
            }
           
        }
    }
    fileprivate var timer : Timer?
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.numCount = 0
        self.sp_setupUI()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    /// 添加UI
    fileprivate func sp_setupUI(){
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .horizontal
        self.collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.backgroundColor = self.backgroundColor
        self.collectionView.showsHorizontalScrollIndicator = false
        self.collectionView.isPagingEnabled = true
        self.collectionView.register(SPBannerCollectCell.self, forCellWithReuseIdentifier: bannerCellID)
        self.addSubview(self.collectionView)
        self.addSubview(self.pageControl)
        self.sp_addConstraint()
    }
    /// 添加约束
    fileprivate func sp_addConstraint(){
        self.collectionView.snp.makeConstraints { (maker) in
            maker.left.top.right.bottom.equalTo(self).offset(0)
        }
        self.pageControl.snp.makeConstraints { (maker) in
            maker.left.right.equalTo(self).offset(0)
            maker.height.equalTo(10)
            maker.bottom.equalTo(self.snp.bottom).offset(-25)
        }
    }
    deinit {
        self.stopTimer()
    }
}
extension SPBannerView:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
         return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let block = self.numBlock{
            var num = block(section)
            self.numCount = num
            if self.isLoop && self.numCount > 1 {
                num = num + 2
            }
            return num
        }else{
            return 0
        }
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell : SPBannerCollectCell = collectionView.dequeueReusableCell(withReuseIdentifier: bannerCellID, for: indexPath) as! SPBannerCollectCell
        if let block = self.cellBlock {
        
            block(cell.bannerImageView,self.getRow(indexPath: indexPath))
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width, height: collectionView.frame.size.height)
    }
    // 返回cell 上下左右的间距
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return  UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let block = self.selectBlock{
            block(self.getRow(indexPath: indexPath))
        }
    }
    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        sp_log(message: "准备手势")
        stopTimer()
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        let page = scrollView.contentOffset.x / scrollView.frame.size.width
//        sp_dealPage(page: Int(page),animated: false)
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        sp_log(message: "停止滚动")
        let page = scrollView.contentOffset.x / scrollView.frame.size.width
        sp_dealPage(page: Int(page),animated: false)
        startTimer()
 
    }
    fileprivate func getRow(indexPath : IndexPath) -> Int{
        var row = indexPath.row
        if self.isLoop && self.numCount > 1{
            if row == 0{
                row = self.numCount - 1
            }else if (row > self.numCount){
                row = 0
            }else{
                row = row - 1
            }
        }
        return row
    }
}
// MARK: - 事件
extension SPBannerView{
    fileprivate func dealTimer(){
        if  isAutoPaly && self.numCount > 1 {
            self.startTimer()
        }else{
            self.stopTimer()
        }
    }
    
    fileprivate func startTimer (){
        if self.timer == nil{
//            self.collectionView.isUserInteractionEnabled = false
            self.timer = Timer(timeInterval: 5, target: self, selector: #selector(timerRun), userInfo: nil, repeats: true)
            RunLoop.main.add(self.timer!, forMode: RunLoopMode.defaultRunLoopMode)
        }
    }
    fileprivate func stopTimer(){
        if let t = self.timer {
            if t.isValid{
                t.invalidate()
            }
            self.timer = nil
//            self.collectionView.isUserInteractionEnabled = true
        }
    }
    @objc fileprivate func timerRun(){
        let page = self.collectionView.contentOffset.x / self.collectionView.frame.size.width
        sp_dealPage(page: Int(page) + 1 ,animated: true)
//        self.collectionView.scrollToItem(at: IndexPath(row: Int(page + 1), section: 0), at: UICollectionViewScrollPosition.init(rawValue: 0), animated: true)
    }
    fileprivate func sp_dealPage(page : Int,animated : Bool = false){
//        sp_log(message: "page is \(page)")
        var pageInt = page
        if self.isLoop && self.numCount > 1 {
            if pageInt == 0 {
                pageInt = self.numCount
                self.pageControl.currentPage = self.numCount - 1
               self.collectionView.setContentOffset(CGPoint(x: CGFloat(pageInt) * self.collectionView.frame.size.width, y: 0), animated: false)
             
            }else if pageInt == self.numCount + 1{
                pageInt = 1
                self.pageControl.currentPage = 0
                   self.collectionView.setContentOffset(CGPoint(x: CGFloat(pageInt) * self.collectionView.frame.size.width, y: 0), animated: false)
            }else{
                self.pageControl.currentPage = pageInt - 1
                 self.collectionView.setContentOffset(CGPoint(x: CGFloat(pageInt) * self.collectionView.frame.size.width, y: 0), animated: false)
            }
         
        }else if self.isAutoPaly {
            if pageInt > self.numCount - 1 {
                pageInt = 0
            }
            if pageInt < 0 {
                pageInt = self.numCount - 1
            }
            self.collectionView.setContentOffset(CGPoint(x: CGFloat(pageInt) * self.collectionView.frame.size.width, y: 0), animated: false)
        }else{
            if pageInt > self.numCount - 1 {
                pageInt = self.numCount - 1
            }
            if pageInt < 0 {
                pageInt = 0
            }
            self.pageControl.currentPage = pageInt
        }
    }
    
    func sp_reloadData(){
        self.collectionView.reloadData()
        sp_asyncAfter(time: 0.1) {
            self.sp_dealPage(page: self.isLoop ? 1 : 0 ,animated: true)
        }
  
    }
}
