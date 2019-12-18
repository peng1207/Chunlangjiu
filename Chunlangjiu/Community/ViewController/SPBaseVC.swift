//
//  SPBaseVC.swift
//  Chunlangjiu
//
//  Created by 黄树鹏 on 2018/6/29.
//  Copyright © 2018年 Chunlang. All rights reserved.
//

import Foundation
import UIKit

class  SPBaseVC: UIViewController {
    lazy var noData : UILabel = {
        let label = UILabel()
        label.textColor = SPColorForHexString(hex: SP_HexColor.color_333333.rawValue)
        label.numberOfLines = 0
        label.font = sp_getFontSize(size: 16)
        label.textAlignment = .center
        label.isHidden = true
        return label
    }()
    var requestModel : SPRequestModel = SPRequestModel()
    override var preferredStatusBarStyle: UIStatusBarStyle{
         return .lightContent
     }
    override func viewDidLoad() {
        super.viewDidLoad()
//        if #available(iOS 13.0, *) {
//            self.overrideUserInterfaceStyle = .light
//        } else {
//            // Fallback on earlier versions
//        }
        self.view.backgroundColor = SPColorForHexString(hex: SP_HexColor.color_f7f7f7.rawValue)
        self.edgesForExtendedLayout = []
        sp_setNoData()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        SPThridManager.sp_beginLogPageView(pageName: "\(self.classForCoder)")
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        SPThridManager.sp_endLogPageView(pageName: "\(self.classForCoder)")
    }
   @objc func sp_clickBackAction(){
        self.navigationController?.popViewController(animated: true)
       
    }
    func sp_setupUI() {
        
    }
    fileprivate func sp_setNoData(){
        self.view.addSubview(self.noData)
        self.noData.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.view).offset(16)
            maker.right.equalTo(self.view).offset(-16)
            maker.height.greaterThanOrEqualTo(0)
            maker.centerY.equalTo(self.view.snp.centerY).offset(0)
        }
    }
    func sp_dealNoData(){
        
    }
    deinit {
        sp_log(message: "销毁对象")
    }
}
 
