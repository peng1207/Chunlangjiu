//
//  SPShopProductBtnView.swift
//  Chunlangjiu
//
//  Created by 黄树鹏 on 2019/3/3.
//  Copyright © 2019 Chunlang. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
class SPShopProductBtnView:  UIView{
    fileprivate lazy var lineView : UIView = {
        let view = sp_getLineView()
        view.backgroundColor = SPColorForHexString(hex: SP_HexColor.color_b31f3f.rawValue)
        return view
    }()
    fileprivate let btnTag : Int = 1000
    var titleArray : [String]?{
        didSet{
            sp_setupData()
        }
    }
    var clickBlock : SPBtnClickBlock?
    fileprivate var selectIndex : Int = 0
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.sp_setupUI()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    fileprivate func sp_setupData(){
        self.selectIndex = btnTag
        if sp_getArrayCount(array: self.titleArray) > 0 {
            var tmpView : UIView? = nil
            var tag : Int = 0
            for title in titleArray! {
                let btn = UIButton(type: UIButtonType.custom)
                btn.tag = tag + btnTag
                btn.setTitle(sp_getString(string: title), for: UIControlState.normal)
                btn.setTitleColor(SPColorForHexString(hex: SP_HexColor.color_000000.rawValue), for: UIControlState.normal)
                btn.setTitleColor(SPColorForHexString(hex: SP_HexColor.color_b31f3f.rawValue), for: UIControlState.selected)
                btn.titleLabel?.font = sp_getFontSize(size: 15)
                btn.addTarget(self, action: #selector(sp_click(btn:)), for: UIControlEvents.touchUpInside)
                if tag == 0 {
                    btn.isSelected = true
                }
                self.addSubview(btn)
                btn.snp.makeConstraints { (maker) in
                    maker.top.bottom.equalTo(self).offset(0)
                    if let view  = tmpView {
                        maker.left.equalTo(view.snp.right).offset(0)
                        maker.width.equalTo(view.snp.width).offset(0)
                    }else{
                        maker.left.equalTo(self.snp.left).offset(0)
                    }
                    if tag == sp_getArrayCount(array: titleArray) - 1 {
                        maker.right.equalTo(self).offset(0)
                    }
                }
                
                tmpView = btn
                tag = tag + 1
            }
        }else{
            
        }
        self.bringSubview(toFront: self.lineView)
       sp_addConstraint()
       
    }
    
    /// 添加UI
    fileprivate func sp_setupUI(){
        self.addSubview(self.lineView)
        
    }
    /// 添加约束
    fileprivate func sp_addConstraint(){
        let view = self.viewWithTag(self.selectIndex )
        self.lineView.snp.remakeConstraints { (maker) in
            maker.width.equalTo(40)
            maker.height.equalTo(sp_lineHeight)
            maker.bottom.equalTo(self.snp.bottom).offset(0)
            if let v = view {
                maker.centerX.equalTo(v.snp.centerX).offset(0)
            }else{
                maker.centerX.equalTo(self.snp.centerX).multipliedBy(0.5)
            }
        }
    }
    deinit {
        
    }
}
extension SPShopProductBtnView {
    
    /// 设置所有的按钮不可选择
    fileprivate func sp_setAllBtnNoSelect(){
        for view in self.subviews{
            if let btn : UIButton = view as? UIButton {
                btn.isSelected = false
            }
        }
    }
    @objc fileprivate func sp_click(btn : UIButton){
        self.selectIndex = btn.tag
        sp_dealComplete()
        sp_setAllBtnNoSelect()
            btn.isSelected = true
         sp_addConstraint()
    }
    fileprivate func sp_dealComplete(){
        guard let block = self.clickBlock else {
            return
        }
        block()
    }
    func sp_getSelectIndex()->Int{
        return self.selectIndex - btnTag
    }
}
