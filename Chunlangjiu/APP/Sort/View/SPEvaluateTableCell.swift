//
//  SPEvaluateTableCell.swift
//  Chunlangjiu
//
//  Created by 黄树鹏 on 2018/7/9.
//  Copyright © 2018年 Chunlang. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
class SPEvaluateTableCell: UITableViewCell {
    lazy var evaluateView : SPEvaluateView = {
        return SPEvaluateView()
    }()
   
    var evaluateModel : SPEvaluateModel?{
        didSet{
            self.sp_setupData()
        }
    }
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.sp_setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    /// 赋值
    fileprivate func sp_setupData(){
        self.evaluateView.evaluateModel = self.evaluateModel
    }
    /// 添加UI
    fileprivate func sp_setupUI(){
       self.contentView.addSubview(self.evaluateView)
        self.sp_addConstraint()
    }
    /// 添加约束
    fileprivate func sp_addConstraint(){
        self.evaluateView.snp.makeConstraints { (maker) in
            maker.left.right.top.equalTo(self.contentView).offset(0)
            maker.height.greaterThanOrEqualTo(0)
            maker.bottom.equalTo(self.contentView.snp.bottom).offset(0)
        }
    }
    deinit {
        
    }
}
class SPEvaluateView:  UIView{
    fileprivate lazy var phoneLabel : UILabel = {
        let label = UILabel()
        label.font = sp_getFontSize(size: 12)
        label.textColor = SPColorForHexString(hex: SP_HexColor.color_333333.rawValue)
        return label
    }()
    fileprivate lazy var contentLabel : UILabel = {
        let label = UILabel()
        label.font = sp_getFontSize(size: 11)
        label.textColor = SPColorForHexString(hex: SP_HexColor.color_999999.rawValue)
        label.numberOfLines = 0
        return label
    }()
    fileprivate lazy var timeLabel : UILabel = {
        let label = UILabel()
        label.font = sp_getFontSize(size: 10)
        label.textColor = SPColorForHexString(hex: SP_HexColor.color_999999.rawValue)
        return label
    }()
    var lineView : UIView = {
        return sp_getLineView()
    }()
    
    fileprivate lazy var startView : SPStarView = {
        let view = SPStarView()
        return view
    }()
    fileprivate var collectionView : UICollectionView!
    fileprivate let cellId = "evaluateImgCellID"
    fileprivate var imgArray :  [String]?
    fileprivate var collectionHeight : Constraint!
    var evaluateModel : SPEvaluateModel?{
        didSet{
            self.sp_setupData()
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
    
        self.sp_setupUI()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    /// 赋值
    fileprivate func sp_setupData(){
      
        self.phoneLabel.text = sp_getString(string: self.evaluateModel?.user_name)
        self.contentLabel.text = sp_getString(string: self.evaluateModel?.content)
        self.timeLabel.text = sp_getString(string: self.evaluateModel?.created_time)
        if sp_getString(string: evaluateModel?.result) == "good"{
            self.startView.count = 5
        }else if sp_getString(string: evaluateModel?.result) == "neutral"{
            self.startView.count = 3
        }else{
              self.startView.count = 2
        }
        self.imgArray = self.evaluateModel?.rate_pic
        if sp_getArrayCount(array: self.imgArray) > 0 {
            let remainder = sp_getArrayCount(array: self.imgArray) % 3
            var divisor = sp_getArrayCount(array: self.imgArray) / 3
            if remainder > 0 {
                divisor = divisor + 1
            }
            let rowW = NSInteger((sp_getScreenWidth() - 36 - 40) / 3.0)
            self.collectionHeight.update(offset: (rowW + 15) * divisor)
        }else{
            self.collectionHeight.update(offset: 0)
        }
        
        self.collectionView.reloadData()
    }
    /// 添加UI
    fileprivate func sp_setupUI(){
        self.addSubview(self.phoneLabel)
        self.addSubview(self.contentLabel)
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 18
        layout.minimumInteritemSpacing = 18
        layout.sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 17, right: 20)
        self.collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.backgroundColor = SPColorForHexString(hex: SP_HexColor.color_ffffff.rawValue)
        self.collectionView.alwaysBounceVertical = true
        self.collectionView.register(SPOrderImgCollectionCell.self, forCellWithReuseIdentifier: self.cellId)
        self.collectionView.showsVerticalScrollIndicator = false
        self.collectionView.isScrollEnabled = false
        self.addSubview(self.collectionView)
        self.addSubview(self.timeLabel)
        self.addSubview(self.lineView)
        self.addSubview(self.startView)
        self.sp_addConstraint()
    }
    /// 添加约束
    fileprivate func sp_addConstraint(){
        self.phoneLabel.setContentHuggingPriority(UILayoutPriority.defaultHigh, for: UILayoutConstraintAxis.horizontal)
        self.phoneLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(self).offset(23)
            maker.top.equalTo(self.snp.top).offset(24)
            maker.width.greaterThanOrEqualTo(0)
            maker.height.greaterThanOrEqualTo(0)
            maker.right.lessThanOrEqualTo(self.startView.snp.left).offset(-4)
        }
        self.contentLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.phoneLabel.snp.left).offset(0)
            maker.top.equalTo(self.phoneLabel.snp.bottom).offset(15)
            maker.right.equalTo(self.snp.right).offset(-20)
            maker.height.greaterThanOrEqualTo(0)
        }
        self.collectionView.snp.makeConstraints { (maker) in
            maker.left.right.equalTo(self).offset(0)
            maker.top.equalTo(self.contentLabel.snp.bottom).offset(9)
           self.collectionHeight = maker.height.equalTo(0).priorityHigh().constraint
        }
        self.timeLabel.snp.makeConstraints { (maker) in
            maker.right.equalTo(self.snp.right).offset(-20)
            maker.top.equalTo(self.collectionView.snp.bottom).offset(0)
            maker.width.greaterThanOrEqualTo(0)
            maker.height.greaterThanOrEqualTo(0)
        }
        self.lineView.snp.makeConstraints { (maker) in
            maker.left.right.equalTo(self.contentLabel).offset(0)
            maker.height.equalTo(sp_lineHeight)
            maker.top.equalTo(self.timeLabel.snp.bottom).offset(14)
            maker.bottom.equalTo(self.snp.bottom).offset(0)
        }
        self.startView.snp.makeConstraints { (maker) in
            maker.right.equalTo(self.snp.right).offset(-20)
            maker.centerY.equalTo(self.phoneLabel.snp.centerY).offset(0)
            maker.height.equalTo(10)
            maker.width.equalTo(84)
        }
    }
    deinit {
        
    }
}
extension SPEvaluateView : UICollectionViewDelegate ,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
 
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sp_getArrayCount(array: self.imgArray) > 0 ? 1 : 0
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sp_getArrayCount(array: self.imgArray)
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell : SPOrderImgCollectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: self.cellId, for: indexPath) as! SPOrderImgCollectionCell
        if indexPath.row < sp_getArrayCount(array: self.imgArray) {
            cell.iconImgView.sp_cache(string: sp_getString(string: self.imgArray?[indexPath.row]), plImage: sp_getDefaultImg())
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = NSInteger((collectionView.frame.size.width - 36 - 40) / 3.0)
        return CGSize(width: width, height: width)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row < sp_getArrayCount(array: self.imgArray) {
            
            let appdelegate : AppDelegate = UIApplication.shared.delegate as! AppDelegate
            let tabbarController = appdelegate.window?.rootViewController
            if tabbarController is SPMainVC {
                let tabBar : SPMainVC = tabbarController as! SPMainVC
                let nav : UINavigationController? = tabBar.viewControllers![tabBar.selectedIndex] as? UINavigationController
                if nav != nil {
                    let lookPictureVC = SPLookPictureVC()
                    lookPictureVC.dataArray = self.imgArray
                    lookPictureVC.selectIndex = indexPath.row
                    nav?.present(lookPictureVC, animated: true, completion: nil)
                }
            }
            
        }
    }
}
