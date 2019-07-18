//
//  SPAdvertVC.swift
//  Chunlangjiu
//
//  Created by 黄树鹏 on 2018/12/6.
//  Copyright © 2018年 Chunlang. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

/// 广告页
class SPAdvertVC : SPBaseVC{
    
    fileprivate lazy var advertImg : UIImageView = {
        let img = UIImageView()
        img.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(sp_clickImg))
        img.addGestureRecognizer(tap)
        return img
    }()
    fileprivate lazy var skipBtn : UIButton = {
        let btn = UIButton(type: UIButtonType.custom)
        btn.setTitle("完成", for: UIControlState.normal)
        btn.setTitleColor(UIColor.white, for: UIControlState.normal)
        btn.backgroundColor = SPColorForHexString(hex: SP_HexColor.color_b31f3f.rawValue)
        btn.sp_cornerRadius(cornerRadius: 15)
        btn.addTarget(self, action: #selector(sp_clickSkip), for: UIControlEvents.touchUpInside)
        return btn
    }()
    var model : SPOpenAdvModel?
    fileprivate var timer : Timer?
    fileprivate var timeCount : Int = 5
    override func viewDidLoad() {
        super.viewDidLoad()
        sp_setupUI()
        sp_setupData()
        sp_setBtnValue()
        sp_startTimer()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        sp_stopTimer()
        
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    /// 赋值
    fileprivate func sp_setupData(){
        self.advertImg.image = UIImage(contentsOfFile: sp_getString(string: model?.sp_getLocalPath()))
        if self.advertImg.image == nil {
            self.advertImg.sp_cache(string: sp_getString(string: model?.imagesrc), plImage: nil)
        }
    }
    
    /// 添加UI
    override func sp_setupUI(){
        self.view.addSubview(self.advertImg)
        self.view.addSubview(self.skipBtn)
        self.sp_addConstraint()
    }
    /// 添加约束
    fileprivate func sp_addConstraint(){
        self.advertImg.snp.makeConstraints { (maker) in
            maker.left.right.top.bottom.equalTo(self.view).offset(0)
        }
        self.skipBtn.snp.makeConstraints { (maker) in
            maker.height.equalTo(30)
            maker.width.equalTo(80)
            maker.right.equalTo(self.view.snp.right).offset(-20)
            maker.top.equalTo(self.view.snp.top).offset(sp_getstatusBarHeight() + 20)
        }
    }
 }

extension SPAdvertVC {
    @objc fileprivate func sp_clickSkip(){
        sp_log(message: "开启广告移除")
        sp_stopTimer()
        self.view.removeFromSuperview()
        self.removeFromParentViewController()
        if  SPAPPManager.sp_isLogin(isPush: true) {
            sp_log(message: "已经登陆了")
        }
        
    }
    fileprivate func sp_startTimer(){
        if self.timer == nil {
            self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(sp_timerRun), userInfo: nil, repeats: true)
            
        }
    }
    @objc fileprivate func sp_timerRun(){
        self.timeCount = self.timeCount - 1
        sp_setBtnValue()
        if self.timeCount < 1 {
            sp_clickSkip()
        }
    }
    fileprivate func sp_stopTimer(){
        if self.timer != nil {
            if (self.timer?.isValid)!{
                self.timer?.invalidate()
            }
        }
        self.timer = nil
    }
    fileprivate func sp_setBtnValue(){
        let att = NSMutableAttributedString()
        att.append(NSAttributedString(string: "\(sp_getString(string: self.timeCount))s", attributes: [NSAttributedStringKey.font : sp_getFontSize(size: 12),NSAttributedStringKey.foregroundColor: SPColorForHexString(hex: SP_HexColor.color_ffffff.rawValue)]))
         att.append(NSAttributedString(string: " | 完成", attributes: [NSAttributedStringKey.font : sp_getFontSize(size: 12),NSAttributedStringKey.foregroundColor: SPColorForHexString(hex: SP_HexColor.color_ffffff.rawValue)]))
        self.skipBtn.setAttributedTitle(att, for: UIControlState.normal)
    }
    @objc fileprivate func sp_clickImg(){
        if SPAPPManager.sp_isLogin(isPush: false) == false {
            sp_clickSkip()
            return
        }
        
        let appdeleage = UIApplication.shared.delegate as! AppDelegate
        var vc : UIViewController? = nil
        if let window = appdeleage.window  {
            if let rootVC = window.rootViewController {
                if let mainVC : SPMainVC  = rootVC as? SPMainVC {
                    let selectVC = mainVC.viewControllers?[mainVC.selectedIndex]
                    if let sVC : UINavigationController = selectVC as? UINavigationController {
                        vc = sVC.topViewController
                    }else if let sVC : UIViewController = selectVC {
                        vc = sVC
                    }
                }
            }
        }
        
        if let viewController = vc {
            let model =  SPAPPManager.sp_getOpenAdv()
            SPIndexHande.sp_deal(viewController: viewController, lineType: model?.linktype,linktarget: model?.link, webparam: model?.webparam,name: "",webview: model?.webview)
            self.sp_clickSkip()
        }
    }
    
}

