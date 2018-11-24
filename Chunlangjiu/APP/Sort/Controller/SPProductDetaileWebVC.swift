//
//  SPProductDetaileWebVC.swift
//  Chunlangjiu
//
//  Created by 黄树鹏 on 2018/7/20.
//  Copyright © 2018年 Chunlang. All rights reserved.
//

import Foundation
import SnapKit

typealias SPPullDownFinishComplete = ()-> Void

class SPProductDetaileWebVC: SPWebVC {
    fileprivate let text = "下拉可以回到商品详情"
    lazy var downView : UIView = {
        let view = UIView()
        return view
    }()
    lazy var refreshLabel : UILabel = {
        let label = UILabel()
        label.textColor = SPColorForHexString(hex: SP_HexColor.color_666666.rawValue)
        label.font = sp_getFontSize(size: 13)
        label.text = text
        return label
    }()
    lazy var refreshImage : UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "public_drop_down")
         view.layer.transform = CATransform3DMakeRotation(CGFloat(M_PI), 0, 0, 1)
        return view
    }()
    var isLoading : Bool = false
    var isDragging : Bool = false
    var refesher_height : CGFloat = 50
    var showDownView : Bool = false
    var finishComlete : SPPullDownFinishComplete?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.sp_setupUI()
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
    /// 创建UI
    override func sp_setupUI() {
        super.sp_setupUI()
        if self.showDownView {
            self.webView.scrollView.addSubview(self.downView)
            self.downView.addSubview(self.refreshLabel)
            self.downView.addSubview(self.refreshImage)
        }
        self.sp_addConstraint()
    }
    /// 添加约束
    fileprivate func sp_addConstraint(){
        if self.showDownView {
            self.downView.snp.makeConstraints { (maker) in
                maker.left.right.equalTo(self.webView.scrollView).offset(0)
                maker.height.equalTo(refesher_height)
                maker.centerX.equalTo(self.webView.scrollView.snp.centerX).offset(0)
                maker.bottom.equalTo(self.webView.scrollView.snp.top).offset(0)
            }
            self.refreshLabel.snp.makeConstraints { (maker) in
                maker.width.greaterThanOrEqualTo(0)
                maker.top.bottom.equalTo(self.downView).offset(0)
                maker.centerX.equalTo(self.downView.snp.centerX).offset(0)
            }
            self.refreshImage.snp.makeConstraints { (maker) in
                maker.right.equalTo(self.refreshLabel.snp.left).offset(-10)
                maker.width.equalTo(11)
                maker.height.equalTo(16)
                maker.centerY.equalTo(self.downView.snp.centerY).offset(0)
            }
        }
        
    }
    deinit {
        
    }
}
extension SPProductDetaileWebVC {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        guard self.showDownView else {
            return
        }
        if self.isLoading {
            return
        }
        self.isDragging = true
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        guard self.showDownView else {
            return
        }
        if self.isLoading && scrollView.contentOffset.y > 0 {
            return
        }
        if isDragging && scrollView.contentOffset.y <= 0 {
            UIView.beginAnimations(nil, context: nil)
            if scrollView.contentOffset.y <= -refesher_height {
                self.refreshLabel.text = "可以松开了"
            }else{
                self.refreshLabel.text = text
            }
            UIView.commitAnimations()
        }
    }
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        guard self.showDownView  else {
            return
        }
        if self.isLoading {
            return
        }
        isDragging = false
        if scrollView.contentOffset.y <= -refesher_height {
            self.sp_startLoading()
        }
    }
    func sp_startLoading() {
        guard self.showDownView else {
            return
        }
        guard self.isLoading == false else {
            return
        }
        isLoading = true
        UIView.beginAnimations(nil, context: nil)
        UIView.setAnimationDuration(0.3)
        self.refreshLabel.text = ""
        UIView.commitAnimations()
        if let complete = self.finishComlete {
            complete()
        }
        self.sp_stopLoading()
    }
    func sp_stopLoading(){
        isLoading = false
        UIView.beginAnimations(nil, context: nil)
        UIView.setAnimationDelegate(self)
        UIView.setAnimationDuration(0.1)
        UIView.setAnimationDidStop(#selector(animationDidStop(anim:finished:)))
        UIView.commitAnimations()
    }
    @objc func animationDidStop(anim: CAAnimation!, finished flag: Bool){
        self.refreshLabel.text = text
    }
}
