//
//  SPNavigationBar.swift
//  Chunlangjiu
//
//  Created by 黄树鹏 on 2018/7/28.
//  Copyright © 2018年 Chunlang. All rights reserved.
//

import Foundation
import UIKit
extension UINavigationBar {
    /**
     *  隐藏导航栏下的横线，背景色置空 viewWillAppear调用
     */
    func sp_star() {
        let shadowImg: UIImageView? = self.sp_findNavLineImageViewOn(view: self)
        shadowImg?.isHidden = true
        self.backgroundColor = nil
    }
    
    /**
     在func scrollViewDidScroll(_ scrollView: UIScrollView)调用
     @param color 最终显示颜色
     @param scrollView 当前滑动视图
     @param value 滑动临界值，依据需求设置
     */
    func sp_change(_ color: UIColor, with scrollView: UIScrollView, andValue value: CGFloat) -> CGFloat {
        if scrollView.contentOffset.y < -value{
            // 下拉时导航栏隐藏，无所谓，可以忽略
            self.isHidden = true
            return 0
        } else {
            self.isHidden = false
            // 计算透明度
            let alpha: CGFloat = scrollView.contentOffset.y / value > 1.0 ? 1 : scrollView.contentOffset.y / value
            //设置一个颜色并转化为图片
            let image: UIImage? = UIImage.sp_getImageWithColor(color: color.withAlphaComponent(alpha))
            self.setBackgroundImage(image, for: .default)
            return alpha
        }
    }
    
    func sp_backColor(color : UIColor){
        //设置一个颜色并转化为图片
        let image: UIImage? = UIImage.sp_getImageWithColor(color: color)
        self.setBackgroundImage(image, for: .default)
    }
    
    /**
     *  还原导航栏  viewWillDisAppear调用
     */
    func sp_reset() {
        let shadowImg = sp_findNavLineImageViewOn(view: self)
        shadowImg?.isHidden = false
        self.setBackgroundImage(UIImage.sp_getImageWithColor(color: SPColorForHexString(hex: SP_HexColor.color_b31f3f.rawValue)),for: .default)
    }
    
    
    // MARK: - 其他内部方法
    //寻找导航栏下的横线  （递归查询导航栏下边那条分割线）
    fileprivate func sp_findNavLineImageViewOn(view: UIView) -> UIImageView? {
        if (view.isKind(of: UIImageView.classForCoder())  && view.bounds.size.height <= 1.0) {
            return view as? UIImageView
        }
        for subView in view.subviews {
            let imageView = sp_findNavLineImageViewOn(view: subView)
            if imageView != nil {
                return imageView
            }
        }
        return nil
    }
}
