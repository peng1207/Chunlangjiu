//
//  SPConditionFilterView.swift
//  Chunlangjiu
//
//  Created by chengzong liang on 2018/9/26.
//  Copyright © 2018年 Chunlang. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

typealias SPConfitionFilterComplete = (_ model : Any?)->Void
class SPConditionFilterView : UIView{
    
    fileprivate lazy var hiddenView : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.2)
        let tap = UITapGestureRecognizer(target: self, action: #selector(sp_remove))
        view.addGestureRecognizer(tap)
        return view
    }()
    fileprivate lazy var contentView : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        return view
    }()
    var dataAraay : [Any]? 
    var selectModel : Any?
    var selectCompete : SPConfitionFilterComplete?
    var hiddenComplete : SPBtnClickBlock?
    fileprivate var collectionView : UICollectionView!
    fileprivate let conditionFilterCellID = "conditionFilterCellID"
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        sp_setupUI()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func sp_reload(){
        self.collectionView.reloadData()
    }
    @objc fileprivate func sp_remove(){
        if let block = self.hiddenComplete {
            block()
        }
        self.removeFromSuperview()
    }
    /// 添加UI
    fileprivate func sp_setupUI(){
        self.addSubview(self.hiddenView)
        self.addSubview(self.contentView)
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        self.collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        self.collectionView.backgroundColor = UIColor.white
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.register(SPConditionFilterCell.self, forCellWithReuseIdentifier: conditionFilterCellID)
        self.contentView.addSubview(self.collectionView)
        sp_addConstraint()
    }
    /// 添加约束
    fileprivate func sp_addConstraint(){
        self.hiddenView.snp.makeConstraints { (maker) in
            maker.left.top.right.bottom.equalTo(self).offset(0)
        }
        self.contentView.snp.makeConstraints { (maker) in
            maker.left.top.right.equalTo(self).offset(0)
            maker.height.equalTo(200)
        }
        self.collectionView.snp.makeConstraints { (maker) in
            maker.left.right.top.bottom.equalTo(self.contentView).offset(0)
        }
    }
}
extension SPConditionFilterView: UICollectionViewDelegateFlowLayout,UICollectionViewDataSource,UICollectionViewDelegate {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sp_getArrayCount(array: self.dataAraay) > 0 ? 1 : 0
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sp_getArrayCount(array: self.dataAraay)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: Int(collectionView.frame.size.width / 2.0 ), height: 44)
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell : SPConditionFilterCell = collectionView.dequeueReusableCell(withReuseIdentifier: conditionFilterCellID, for: indexPath) as! SPConditionFilterCell
        var ishidden = true
        var text : String = ""
        if indexPath.row < sp_getArrayCount(array: self.dataAraay) {
            let model = self.dataAraay?[indexPath.row]
            if let brandModel : SPBrandModel = model as? SPBrandModel {
                text = sp_getString(string: brandModel.brand_name)
                if let select : SPBrandModel =  selectModel as?  SPBrandModel{
                    if select.brand_id == brandModel.brand_id {
                        ishidden = false
                    }
                }
            }else if let placeModel : SPPlaceModel =  model as? SPPlaceModel {
                text = sp_getString(string: placeModel.area_name)
                if  let select : SPPlaceModel = selectModel as? SPPlaceModel{
                    if select.area_id == placeModel.area_id {
                        ishidden = false
                    }
                    
                }
            }else if let typeModel : SPTypeModel =  model as? SPTypeModel {
                text = sp_getString(string: typeModel.odor_name)
                if let select : SPTypeModel = selectModel as? SPTypeModel{
                    if typeModel.odor_id == select.odor_id {
                        ishidden = false
                    }
                }
            }else if let alcoholModel : SPAlcoholDegree =  model as? SPAlcoholDegree {
                text = sp_getString(string: alcoholModel.alcohol_name)
                if let select : SPAlcoholDegree =  selectModel as?  SPAlcoholDegree {
                    if select.alcohol_id == alcoholModel.alcohol_id {
                        ishidden = false
                    }
                }
            }else if let priceModel : SPPriceRange = model as? SPPriceRange {
                text = sp_getString(string: priceModel.showPrice)
                if let select : SPPriceRange = selectModel as? SPPriceRange {
                    if sp_getString(string: select.type?.rawValue) == sp_getString(string: priceModel.type?.rawValue) {
                         ishidden = false
                    }
                }
            }
        }
        cell.titleLabel.text = text
        cell.lineView.isHidden = ishidden
        if ishidden {
            cell.titleLabel.textColor = SPColorForHexString(hex: SP_HexColor.color_666666.rawValue)
        }else{
            cell.titleLabel.textColor = SPColorForHexString(hex: SP_HexColor.color_333333.rawValue)
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row < sp_getArrayCount(array: self.dataAraay){
            
            guard let block = self.selectCompete else{
                return
            }
            let model = self.dataAraay?[indexPath.row]
            block(model)
            self.selectModel = model
            collectionView.reloadData()
        }
    }
}
