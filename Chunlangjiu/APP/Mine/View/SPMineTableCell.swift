//
//  SPMineTableCell.swift
//  Chunlangjiu
//
//  Created by chengzong liang on 2018/12/22.
//  Copyright © 2018年 Chunlang. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

typealias SPMineSelectBlock = (_ model : SPMineModel?)->Void

class SPMineTableCell : UITableViewCell {
    fileprivate lazy var cellView : UIView = {
        let view = UIView()
        view.backgroundColor = SPColorForHexString(hex: SP_HexColor.color_ffffff.rawValue)
        return view
    }()
    fileprivate lazy var titleLabel : UILabel = {
        let label = UILabel()
        label.font = sp_getFontSize(size: 12)
        label.textColor = SPColorForHexString(hex: SP_HexColor.color_666666.rawValue)
        label.text = "查看更多订单"
        return label
    }()
    fileprivate lazy var contentLabel : UILabel = {
        let label = UILabel()
        label.font = sp_getFontSize(size: 15)
        label.textColor = SPColorForHexString(hex: SP_HexColor.color_333333.rawValue)
        label.textAlignment = .left
        return label
    }()
    lazy var nextImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "public_rightBack")
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    fileprivate lazy var lineView : UIView = {
        return sp_getLineView()
    }()
    fileprivate var collectionView : UICollectionView!
    fileprivate var collectionHeight : Constraint!
    fileprivate let collectionCellID = "mineTableCellID"
    var sectionModel : SPMineSectionModel? {
        didSet{
            sp_setupData()
        }
    }
    var selectBlock : SPMineSelectBlock?
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        sp_setupUI()
    }
   
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    /// 赋值
    fileprivate func sp_setupData(){
        self.titleLabel.text = sp_getString(string: self.sectionModel?.title)
        var isExist = false
        if let model = self.sectionModel {
            if model.type == .orderManager {
                isExist = true
                self.contentLabel.text = "查看全部订单"
            }else if model.type == .productManager {
                isExist = true
                self.contentLabel.text = "查看全部商品"
            }
        }
        self.nextImageView.isHidden = isExist ? false : true
        self.contentLabel.isHidden = isExist ? false : true
        self.collectionView.reloadData()
    }
    /// 添加UI
    fileprivate func sp_setupUI(){
        self.contentView.addSubview(self.cellView)
        self.cellView.addSubview(self.titleLabel)
        self.cellView.addSubview(self.contentLabel)
        self.cellView.addSubview(self.nextImageView)
        self.cellView.addSubview(self.lineView)
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        self.collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.backgroundColor = self.cellView.backgroundColor
        self.collectionView.register(SPMineCollectCell.self, forCellWithReuseIdentifier: collectionCellID)
        self.collectionView.addObserver(self, forKeyPath: SP_KVO_KEY_CONTENTSIZE, options: NSKeyValueObservingOptions.new, context: nil)
        self.cellView.addSubview(self.collectionView)
        self.sp_addConstraint()
    }
    /// 添加约束
    fileprivate func sp_addConstraint(){
        self.cellView.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.contentView).offset(10)
            maker.right.equalTo(self.contentView).offset(-10)
            maker.top.equalTo(self.contentView).offset(10)
            maker.height.greaterThanOrEqualTo(0)
            maker.bottom.equalTo(self.contentView.snp.bottom).offset(0)
        }
        self.titleLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.cellView).offset(11)
            maker.top.equalTo(self.cellView).offset(0)
            maker.height.equalTo(40)
            maker.right.lessThanOrEqualTo(self.contentLabel.snp.left).offset(-6)
        }
        self.contentLabel.setContentHuggingPriority(UILayoutPriority.defaultHigh, for: UILayoutConstraintAxis.horizontal)
        self.contentLabel.snp.makeConstraints { (maker) in
            maker.right.equalTo(self.nextImageView.snp.left).offset(-6)
            maker.top.bottom.equalTo(self.titleLabel).offset(0)
            maker.width.greaterThanOrEqualTo(0)
        }
        self.nextImageView.snp.makeConstraints { (maker) in
            maker.width.equalTo(9)
            maker.height.equalTo(17)
            maker.right.equalTo(self.cellView.snp.right).offset(-10)
            maker.centerY.equalTo(self.titleLabel.snp.centerY).offset(0)
        }
        self.lineView.snp.makeConstraints { (maker) in
            maker.left.right.equalTo(self.cellView).offset(0)
            maker.height.equalTo(sp_lineHeight)
            maker.top.equalTo(self.titleLabel.snp.bottom).offset(0)
        }
        self.collectionView.snp.makeConstraints { (maker) in
            maker.left.right.equalTo(self.cellView).offset(0)
            maker.top.equalTo(self.lineView.snp.bottom).offset(0)
            self.collectionHeight = maker.height.equalTo(0).constraint
            maker.bottom.equalTo(self.cellView.snp.bottom).offset(0)
        }
    }
    deinit {
        self.collectionView.removeObserver(self, forKeyPath: SP_KVO_KEY_CONTENTSIZE, context: nil)
    }
}
extension SPMineTableCell : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sp_getArrayCount(array: self.sectionModel?.dataArray) > 0 ? 1 : 0
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sp_getArrayCount(array: self.sectionModel?.dataArray)
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell : SPMineCollectCell  = collectionView.dequeueReusableCell(withReuseIdentifier: collectionCellID, for: indexPath) as! SPMineCollectCell
        if indexPath.row < sp_getArrayCount(array: self.sectionModel?.dataArray) {
            cell.model = self.sectionModel?.dataArray?[indexPath.row]
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var num = 0
        let count = self.sectionModel?.rowCount
        if let c = count {
            num = c
        }
        let width = Int(collectionView.frame.size.width / CGFloat(num))
        return CGSize(width: width, height: 81)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let block = self.selectBlock else {
            return
        }
        if indexPath.row < sp_getArrayCount(array: self.sectionModel?.dataArray) {
            block(self.sectionModel?.dataArray?[indexPath.row])
        }
    }
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if sp_getString(string: keyPath) == SP_KVO_KEY_CONTENTSIZE {
            self.collectionHeight.update(offset: self.collectionView.contentSize.height)
            self.cellView.layoutIfNeeded()
        }
    }
}
