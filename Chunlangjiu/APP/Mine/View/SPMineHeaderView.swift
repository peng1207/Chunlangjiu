//
//  SPMineHeaderView.swift
//  Chunlangjiu
//
//  Created by 黄树鹏 on 2018/7/14.
//  Copyright © 2018年 Chunlang. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
class SPMineHeaderView:  UICollectionReusableView{
    
    fileprivate lazy var contentView : UIImageView = {
        let view = UIImageView()
        view.isUserInteractionEnabled = true
        return view
    }()
    
     lazy var iconImageView : UIImageView = {
        let imageView =  UIImageView()
        imageView.sp_cornerRadius(cornerRadius: 35)
        imageView.backgroundColor = UIColor.white
        imageView.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(sp_clickIconAction))
        imageView.addGestureRecognizer(tap)
        return imageView
    }()
     lazy var nameLabel : UILabel = {
        let label = UILabel()
        label.textColor = UIColor.white
        label.font = sp_getFontSize(size: 17)
        label.text = "某某"
        return label
    }()
    lazy var identityBtn : UIButton = {
        let btn = UIButton(type: UIButtonType.custom)
        btn.setTitle(" 个人买家", for: UIControlState.normal)
        btn.titleLabel?.font = sp_getFontSize(size: 16)
        btn.setImage(UIImage(named: "public_people"), for: UIControlState.normal)
        return btn
    }()
 
    lazy var editBtn : UIButton = {
        let btn = UIButton(type: UIButtonType.custom)
        btn.setImage(UIImage(named: "public_edit"), for: UIControlState.normal)
        btn.addTarget(self, action: #selector(sp_clickEdit), for: UIControlEvents.touchUpInside)
        return btn
    }()
    
    fileprivate lazy var changeBtn : UIButton = {
        let btn = UIButton(type: UIButtonType.custom)
        btn.setTitleColor(SPColorForHexString(hex: SP_HexColor.color_ffffff.rawValue), for: UIControlState.normal)
        btn.titleLabel?.font = sp_getFontSize(size: 14)
        btn.backgroundColor = UIColor.white
        btn.setTitle("切换角色", for: UIControlState.normal)
        btn.setTitle("切换角色", for: UIControlState.selected)
        btn.sp_cornerRadius(cornerRadius: 5)
        btn.addTarget(self, action: #selector(sp_clickIdentityAction), for: UIControlEvents.touchUpInside)
        return btn
    }()
     lazy var authBtn : UIButton = {
        let btn = UIButton(type: UIButtonType.custom)
        btn.setTitleColor(SPColorForHexString(hex: SP_HexColor.color_ffffff.rawValue), for: UIControlState.normal)
        btn.titleLabel?.font = sp_getFontSize(size: 14)
        btn.backgroundColor = UIColor.white
        btn.setTitle("我是个人", for: UIControlState.normal)
        btn.setTitle("实名认证中", for: UIControlState.selected)
        
        btn.setImage(nil, for: UIControlState.normal)
        btn.setImage(nil, for: UIControlState.selected)
        btn.setImage(UIImage(named: "public_select_green"), for: UIControlState.disabled)
        btn.sp_cornerRadius(cornerRadius: 5)
        btn.addTarget(self, action: #selector(sp_clickAuthAction), for: UIControlEvents.touchUpInside)
        return btn
    }()
    lazy var componBtn : UIButton = {
        let btn = UIButton(type: UIButtonType.custom)
        btn.setTitleColor(SPColorForHexString(hex: SP_HexColor.color_ffffff.rawValue), for: UIControlState.normal)
        btn.titleLabel?.font = sp_getFontSize(size: 14)
        btn.backgroundColor = UIColor.white
        btn.setTitle("我是企业", for: UIControlState.normal)
        btn.setTitle("企业认证中", for: UIControlState.selected)
        btn.setTitle("已认证", for: UIControlState.disabled)
        btn.setImage(nil, for: UIControlState.normal)
        btn.setImage(nil, for: UIControlState.selected)
     
        btn.sp_cornerRadius(cornerRadius: 5)
        btn.addTarget(self, action: #selector(sp_clickCompome), for: UIControlEvents.touchUpInside)
        return btn
    }()
    lazy var loginBtn : UIButton = {
        let btn = UIButton(type: UIButtonType.custom)
        btn.backgroundColor = UIColor.white
        btn.setTitle("登录", for: UIControlState.normal)
        btn.setTitleColor(SPColorForHexString(hex: SP_HexColor.color_b31f3f.rawValue), for: UIControlState.normal)
        btn.isHidden = true
        btn.sp_cornerRadius(cornerRadius: 20)
        btn.addTarget(self, action: #selector(sp_clickLoginAction), for: UIControlEvents.touchUpInside)
        return btn
    }()
    lazy var authResultBtn : UIButton = {
        let btn = UIButton(type: UIButtonType.custom)
        btn.setTitle(" 未认证", for: UIControlState.normal)
        btn.setImage(UIImage(named: "public_close_block"), for: UIControlState.normal)
        btn.setTitle(" 已认证", for: UIControlState.selected)
        btn.setImage(UIImage(named: "public_select"), for: UIControlState.selected)
        btn.titleLabel?.font = sp_getFontSize(size: 12)
        btn.sp_cornerRadius(cornerRadius: 8)
        btn.backgroundColor = SPColorForHexString(hex: SP_HexColor.color_ce6a00.rawValue)
        return btn
    }()
    fileprivate var collectionView : UICollectionView! 
    fileprivate let SPMineHeaderCollectCellID = "SPMineHeaderCollectCellID"
    var dataArray : [SPMineHeadModel]?
    /// 点击切换身份回调
    var identityBlock : SPBtnClickBlock?
    /// 点击验证回调
    var authBlock : SPBtnClickBlock?
    var compleBlock : SPBtnClickBlock?
    var iconBlock : SPBtnClickBlock?
    var loginBlock : SPBtnClickBlock?
    var editBlock : SPBtnClickBlock?
    var memberModel : SPMemberModel?{
        didSet{
            self.sp_setupData()
        }
    }
    var countModel : SPMineCountModel?{
        didSet{
            self.collectionView.reloadData()
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
         
      
        self.sp_setupUI()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func sp_show(realName show : Bool){
        self.authBtn.snp.remakeConstraints { (maker) in
            if show{
                maker.left.equalTo(self.changeBtn.snp.right).offset(10)
                maker.width.equalTo(self.componBtn.snp.width).offset(0)
                maker.top.equalTo(self.changeBtn.snp.top).offset(0)
                maker.height.equalTo(self.changeBtn.snp.height).offset(0)
            }else{
                maker.left.equalTo(self.componBtn.snp.right).offset(10)
                maker.right.equalTo(self.contentView.snp.right).offset(-20)
                maker.top.equalTo(self.changeBtn.snp.top).offset(0)
                maker.height.equalTo(self.changeBtn.snp.height).offset(0)
            }
        }
        self.componBtn.snp.remakeConstraints { (maker) in
            if show {
                maker.left.equalTo(self.authBtn.snp.right).offset(10)
                maker.right.equalTo(self.snp.right).offset(-20)
                maker.top.height.equalTo(self.authBtn).offset(0)
            }else{
                maker.left.equalTo(self.changeBtn.snp.right).offset(10)
                maker.width.equalTo(self.authBtn.snp.width).offset(0)
                maker.top.height.equalTo(self.changeBtn).offset(0)
            }
        }
        
        self.authBtn.isHidden = !show
    }
    /// 赋值
    fileprivate func sp_setupData(){
       let isLogin = SPAPPManager.sp_isLogin(isPush: false)
        self.iconImageView.sp_cache(string: sp_getString(string: memberModel?.head_portrait), plImage:  sp_getLogoImg())
        self.nameLabel.text = sp_getString(string: memberModel?.username)
        if sp_getString(string: self.nameLabel.text).count <= 0 {
             self.nameLabel.text = sp_getString(string: memberModel?.login_account)
        }
        self.iconImageView.isHidden = !isLogin
        self.nameLabel.isHidden = !isLogin
        
        self.changeBtn.isHidden = !isLogin
        self.authResultBtn.isHidden = !isLogin
        self.identityBtn.isHidden = !isLogin
        if isLogin == false {
            self.authBtn.isHidden = true
        }
     
        self.collectionView.isHidden = !isLogin
        self.loginBtn.isHidden = isLogin
//         self.componBtn.isHidden = isLogin ? false : true
        self.dataArray = SPMineData.sp_getMineHead()
        self.collectionView.reloadData()
        let isCompany =   SPAPPManager.sp_isBusiness()
        if isCompany {
            self.changeBtn.isSelected = true
            self.contentView.backgroundColor = SPColorForHexString(hex: SP_HexColor.color_0c95f5.rawValue)
            self.authResultBtn.backgroundColor = SPColorForHexString(hex: SP_HexColor.color_1981fa.rawValue)
            self.changeBtn.backgroundColor = SPColorForHexString(hex: SP_HexColor.color_1981fa.rawValue)
            self.authBtn.backgroundColor = SPColorForHexString(hex: SP_HexColor.color_1981fa.rawValue)
            self.componBtn.backgroundColor = SPColorForHexString(hex: SP_HexColor.color_1981fa.rawValue)
           self.editBtn.isHidden = false
//            self.contentView.backgroundColor = SPColorForHexString(hex: SP_HexColor.color_b31f3f.rawValue)
//            self.contentView.image = UIImage(named: "public_seller")
        }else{
            self.changeBtn.isSelected = false
           self.contentView.backgroundColor = SPColorForHexString(hex: SP_HexColor.color_e57d00.rawValue)
            self.authResultBtn.backgroundColor = SPColorForHexString(hex: SP_HexColor.color_ce6a00.rawValue)
            self.changeBtn.backgroundColor = SPColorForHexString(hex: SP_HexColor.color_ce6a00.rawValue)
            self.authBtn.backgroundColor = SPColorForHexString(hex: SP_HexColor.color_ce6a00.rawValue)
            self.componBtn.backgroundColor = SPColorForHexString(hex: SP_HexColor.color_ce6a00.rawValue)
            self.editBtn.isHidden = true
//            self.contentView.backgroundColor = SPColorForHexString(hex: SP_HexColor.color_333333.rawValue)
//             self.contentView.image = UIImage(named: "public_buyer")
        }
        if isLogin == false {
            self.editBtn.isHidden = true
        }
        self.collectionView.backgroundColor = self.backgroundColor
    }
    /// 添加UI
    fileprivate func sp_setupUI(){
        self.addSubview(self.contentView)
        self.contentView.addSubview(self.identityBtn)
        self.contentView.addSubview(self.iconImageView)
        self.contentView.addSubview(self.nameLabel)
        self.contentView.addSubview(self.editBtn)
        self.contentView.addSubview(self.changeBtn)
        self.contentView.addSubview(self.authBtn)
        self.contentView.addSubview(self.componBtn)
        self.contentView.addSubview(self.authResultBtn)
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .horizontal
        self.collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.showsHorizontalScrollIndicator = false
        self.collectionView.backgroundColor = SPColorForHexString(hex: SP_HexColor.color_b31f3f.rawValue)
        self.collectionView.register(SPMineHeaderCollectCell.self, forCellWithReuseIdentifier: SPMineHeaderCollectCellID)
        self.addSubview(self.collectionView)
        self.addSubview(self.loginBtn)
        self.sp_addConstraint()
    }
    /// 添加约束
    fileprivate func sp_addConstraint(){
        self.contentView.snp.makeConstraints { (maker) in
            maker.left.right.top.equalTo(self).offset(0)
            maker.bottom.equalTo(self).offset(0)
        }
        self.identityBtn.snp.makeConstraints { (maker) in
            maker.top.equalTo(self.contentView.snp.top).offset( sp_getstatusBarHeight() + 12)
            maker.centerX.equalTo(self.contentView.snp.centerX).offset(0)
            maker.width.greaterThanOrEqualTo(0)
            maker.height.greaterThanOrEqualTo(0)
        }
        self.iconImageView.snp.makeConstraints { (maker) in
            maker.width.height.equalTo(70)
//            maker.top.equalTo((sp_getstatusBarHeight() + SP_NAVGIT_HEIGHT))
            maker.top.equalTo(self.contentView.snp.top).offset(SP_NAVGIT_HEIGHT + sp_getstatusBarHeight() + 18)
            maker.left.equalTo(self.contentView.snp.left).offset(12)
//            maker.centerX.equalTo(self.snp.centerX).offset(0)
        }
        self.authResultBtn.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.iconImageView).offset(5)
            maker.right.equalTo(self.iconImageView.snp.right).offset(-5)
            maker.top.equalTo(self.iconImageView.snp.bottom).offset(5)
            maker.height.equalTo(16)
        }
        self.nameLabel.snp.makeConstraints { (maker) in
            maker.width.greaterThanOrEqualTo(0)
            maker.height.equalTo(18)
            maker.top.equalTo(self.iconImageView.snp.top).offset(5)
//            maker.centerX.equalTo(self.snp.centerX).offset(0)
            maker.left.equalTo(self.iconImageView.snp.right).offset(12)
        }
        self.editBtn.snp.makeConstraints { (maker) in
            maker.width.equalTo(14)
            maker.height.equalTo(13)
            maker.left.equalTo(self.nameLabel.snp.right).offset(7)
            maker.right.lessThanOrEqualTo(self.contentView.snp.right).offset(-10)
            maker.centerY.equalTo(self.nameLabel.snp.centerY).offset(0)
        }
        self.changeBtn.snp.makeConstraints { (maker) in
//            maker.left.equalTo(self.snp.left).offset(50)
            maker.left.equalTo(self.nameLabel.snp.left).offset(0)
            maker.top.equalTo(self.nameLabel.snp.bottom).offset(12)
            maker.width.equalTo(self.componBtn.snp.width).offset(0)
            maker.height.equalTo(27)
        }
        self.authBtn.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.changeBtn.snp.right).offset(10)
            maker.width.equalTo(self.componBtn.snp.width).offset(0)
            maker.top.equalTo(self.changeBtn.snp.top).offset(0)
            maker.height.equalTo(self.changeBtn.snp.height).offset(0)
        }
        self.componBtn.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.authBtn.snp.right).offset(10)
            maker.right.equalTo(self.snp.right).offset(-20)
            maker.top.height.equalTo(self.authBtn).offset(0)
        }
        self.collectionView.snp.makeConstraints { (maker) in
            maker.left.right.equalTo(self.contentView).offset(0)
            maker.height.equalTo(56)
            maker.bottom.equalTo(self.contentView.snp.bottom).offset(0)
        }
        self.loginBtn.snp.makeConstraints { (maker) in
            maker.centerX.equalTo(self.contentView).offset(0)
            maker.centerY.equalTo(self.contentView).offset(0)
            maker.width.equalTo(120)
            maker.height.equalTo(40)
        }
    }
    deinit {
        
    }
}

extension SPMineHeaderView : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sp_getArrayCount(array: self.dataArray) > 0 ? 1 : 0
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sp_getArrayCount(array: self.dataArray)
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell : SPMineHeaderCollectCell = collectionView.dequeueReusableCell(withReuseIdentifier: SPMineHeaderCollectCellID, for: indexPath) as! SPMineHeaderCollectCell
        if  indexPath.row < sp_getArrayCount(array: self.dataArray) {
            cell.model = self.dataArray?[indexPath.row]
            if let model = cell.model {
                if model.type == .avail {
                   cell.titleLabel.text = sp_getString(string: self.countModel?.money)
                }else if model.type == .freeze {
                    cell.titleLabel.text = sp_getString(string: self.countModel?.money_frozen)
                }else if model.type == .news {
                    cell.titleLabel.text = sp_getString(string: self.countModel?.information)
                }
                if sp_getString(string: cell.titleLabel.text).count == 0 {
                    cell.titleLabel.text = "0"
                }
            }
            
           
            
        }
        if indexPath.row == 0{
            cell.lineView.isHidden = true
        }else{
            cell.lineView.isHidden = false
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = Int(collectionView.frame.size.width / CGFloat(integerLiteral:  sp_getArrayCount(array: self.dataArray)))
        return CGSize(width: CGFloat(integerLiteral: width), height: collectionView.frame.size.height)
    }
}
extension SPMineHeaderView {
    /// 点击切换身份事件
    @objc fileprivate func sp_clickIdentityAction(){
        guard let block = self.identityBlock else {
            return
        }
        block()
    }
    /// 点击身份验证按钮
    @objc fileprivate func sp_clickAuthAction(){
        guard let block = self.authBlock else {
            return
        }
        block();
    }
    /// 点击图片
    @objc fileprivate func sp_clickIconAction(){
        guard let block = self.iconBlock else {
            return
        }
        block()
    }
    @objc fileprivate func sp_clickLoginAction(){
        guard let block = self.loginBlock else {
            return
        }
        block()
    }
    @objc fileprivate func sp_clickCompome(){
        guard let block = self.compleBlock else {
            return
        }
        block()
    }
    @objc fileprivate func sp_clickEdit(){
        guard let block = self.editBlock else {
            return
        }
        block()
    }
}
