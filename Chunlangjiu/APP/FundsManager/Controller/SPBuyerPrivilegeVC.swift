//
//  SPBuyerPrivilegeVC.swift
//  Chunlangjiu
//
//  Created by 黄树鹏 on 2019/2/20.
//  Copyright © 2019 Chunlang. All rights reserved.
//

import Foundation
import SnapKit
class SPBuyerPrivilegeVC: SPBaseVC {
    fileprivate lazy var scrollView : UIScrollView = {
        let view = UIScrollView()
        return view
    }()
    fileprivate lazy var imgView : UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "public_privilege")
        return view
    }()
    fileprivate lazy var titleLabel : UILabel = {
        let label = UILabel()
        label.font = sp_getFontSize(size: 15)
        label.textColor = SPColorForHexString(hex: SP_HexColor.color_b31f3f.rawValue)
        label.textAlignment = .left
        label.text = "特权介绍："
        return label
    }()
    fileprivate lazy var tipLabel : UILabel = {
        let label = UILabel()
        label.font = sp_getFontSize(size: 15)
        label.textColor = SPColorForHexString(hex: SP_HexColor.color_333333.rawValue)
        label.textAlignment = .left
        label.text = "1、独一无二的星级标识，信用度更高；\n2、星级卖家店铺装饰；\n3、发布商品自由，不受数量限制；\n4、比普通卖家商品排序更靠前；\n5、比普通卖家更容易卖出藏酒；\n6、新功能优先体验权!"
        label.numberOfLines = 0
        return label
    }()
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
        self.navigationItem.title = "星级卖家特权"
        self.view.addSubview(self.scrollView)
        self.scrollView.addSubview(self.imgView)
        self.scrollView.addSubview(self.tipLabel)
        self.scrollView.addSubview(self.titleLabel)
        self.sp_addConstraint()
    }
    /// 处理有没数据
    override func sp_dealNoData(){
        
    }
    /// 添加约束
    fileprivate func sp_addConstraint(){
        self.scrollView.snp.makeConstraints { (maker) in
            maker.left.top.right.equalTo(self.view).offset(0)
            if #available(iOS 11.0, *) {
                maker.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(0)
            } else {
                maker.bottom.equalTo(self.view.snp.bottom).offset(0)
            }
        }
        self.imgView.snp.makeConstraints { (maker) in
            maker.top.equalTo(self.scrollView).offset(0)
            maker.centerX.equalTo(self.scrollView).offset(0)
            maker.width.equalTo(self.scrollView.snp.width).offset(0)
            maker.height.equalTo(self.imgView.snp.width).multipliedBy(0.53)
        }
        self.titleLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.scrollView).offset(32)
            maker.right.equalTo(self.scrollView.snp.right).offset(-32)
            maker.top.equalTo(self.imgView.snp.bottom).offset(37)
            maker.height.greaterThanOrEqualTo(0)
        }
        self.tipLabel.snp.makeConstraints { (maker) in
            maker.left.right.equalTo(self.titleLabel).offset(0)
            maker.top.equalTo(self.titleLabel.snp.bottom).offset(5)
            maker.height.greaterThanOrEqualTo(0)
            maker.bottom.equalTo(self.scrollView.snp.bottom).offset(-5)
        }
    }
    deinit {
        
    }
}
