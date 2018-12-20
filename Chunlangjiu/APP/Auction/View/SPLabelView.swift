
//
//  SPLabelView.swift
//  Chunlangjiu
//
//  Created by 黄树鹏 on 2018/7/8.
//  Copyright © 2018年 Chunlang. All rights reserved.
//
// 标签view
import Foundation
import UIKit
import SnapKit
class SPLabelView:  UIView{
    var listArray : Array<String>? {
        didSet{
           self.sp_setupUI()
        }
    }
    let SP_LABEL_TAG : Int = 1000
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    /// 添加UI
    fileprivate func sp_setupUI(){
        if sp_getArrayCount(array: listArray) > 0  {
            var index : Int = 0
            var tempView : UIView? = nil
            for string  in listArray! {
                if sp_getString(string: string).count == 0 {
                    continue
                }
                
                var label : UILabel?  = self.viewWithTag(index + SP_LABEL_TAG) as? UILabel
                if label == nil{
                    label = UILabel()
                }
                label?.tag = index + SP_LABEL_TAG
                label?.text = "\(sp_getString(string: string))"
                label?.font = sp_getFontSize(size: 11)
                label?.textColor = SPColorForHexString(hex: SP_HexColor.color_999999.rawValue)
                label?.textAlignment = NSTextAlignment.center
                label?.backgroundColor = SPColorForHexString(hex: SP_HexColor.color_eeeeee.rawValue).withAlphaComponent(0.8)
                 
                self.addSubview(label!)
                label?.setContentHuggingPriority(UILayoutPriority.defaultHigh, for: UILayoutConstraintAxis.horizontal)
                label?.snp.makeConstraints({ (maker) in
                    if let view = tempView{
                        maker.left.equalTo(view.snp.right).offset(8)
                    }else{
                        maker.left.equalTo(self).offset(0)
                    }
                    maker.top.bottom.equalTo(self).offset(0)
                    maker.width.greaterThanOrEqualTo(34)
                    if index == sp_getArrayCount(array: listArray) - 1 {
                        maker.right.lessThanOrEqualTo(self).offset(-4)
                    }
                })
                tempView = label
                index = index + 1
            }
        }
        for view in self.subviews {
            if view.tag  > sp_getArrayCount(array: listArray) - 1 + SP_LABEL_TAG{
                view.removeFromSuperview()
            }
        }
    }
    
    deinit {
        
    }
}
