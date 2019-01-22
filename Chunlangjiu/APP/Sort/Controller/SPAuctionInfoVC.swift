//
//  SPAuctionInfoVC.swift
//  Chunlangjiu
//
//  Created by 黄树鹏 on 2019/1/22.
//  Copyright © 2019 Chunlang. All rights reserved.
//

import Foundation
import SnapKit
class SPAuctionInfoVC: SPBaseVC {
    
    fileprivate lazy var scrollView : UIScrollView = {
        let view = UIScrollView()
        return view
    }()
    fileprivate lazy var joinTitleLabel : UILabel = {
        let label = UILabel()
        label.font = sp_getFontSize(size: 15)
        label.textColor = SPColorForHexString(hex: SP_HexColor.color_333333.rawValue)
        label.textAlignment = .left
        label.numberOfLines = 0
        label.text = "*如何参与竞拍？"
        return label
    }()
    fileprivate lazy var joinAnswerLabel : UILabel = {
        let label = UILabel()
        label.font = sp_getFontSize(size: 14)
        label.textColor = SPColorForHexString(hex: SP_HexColor.color_666666.rawValue)
        label.textAlignment = .left
        label.numberOfLines = 0
        label.text = "1.点击“出价”参与竞拍，价高者得；\n2.竞拍成功，支付货款；\n3.等待卖家发货。"
        return label
    }()
    
    fileprivate lazy var appraisalTitleLabel : UILabel = {
        let label = UILabel()
        label.font = sp_getFontSize(size: 15)
        label.textColor = SPColorForHexString(hex: SP_HexColor.color_333333.rawValue)
        label.textAlignment = .left
        label.numberOfLines = 0
        label.text = "*商品是否支持鉴定？"
        return label
    }()
    fileprivate lazy var appraisalAnswerLabel : UILabel = {
        let label = UILabel()
        label.font = sp_getFontSize(size: 14)
        label.textColor = SPColorForHexString(hex: SP_HexColor.color_666666.rawValue)
        label.textAlignment = .left
        label.numberOfLines = 0
        label.text = "竞拍商品有权威专家进行鉴定，并出有鉴定书。"
        return label
    }()
    fileprivate lazy var securityTitleLabel : UILabel = {
        let label = UILabel()
        label.font = sp_getFontSize(size: 15)
        label.textColor = SPColorForHexString(hex: SP_HexColor.color_333333.rawValue)
        label.textAlignment = .left
        label.numberOfLines = 0
        label.text = "*如何保证钱款安全？"
        return label
    }()
    fileprivate lazy var securityAnswerLabel : UILabel = {
        let label = UILabel()
        label.font = sp_getFontSize(size: 14)
        label.textColor = SPColorForHexString(hex: SP_HexColor.color_666666.rawValue)
        label.textAlignment = .left
        label.numberOfLines = 0
        label.text = "支付的货款有平台担保，确认收货后，货款才打给商家。"
        return label
    }()
    fileprivate lazy var afterSaleTitleLabel : UILabel = {
        let label = UILabel()
        label.font = sp_getFontSize(size: 15)
        label.textColor = SPColorForHexString(hex: SP_HexColor.color_333333.rawValue)
        label.textAlignment = .left
        label.numberOfLines = 0
        label.text = "*收到商品不满意，可以售后吗？"
        return label
    }()
    fileprivate lazy var afterSaleAnswerLabel : UILabel = {
        let label = UILabel()
        label.font = sp_getFontSize(size: 14)
        label.textColor = SPColorForHexString(hex: SP_HexColor.color_666666.rawValue)
        label.textAlignment = .left
        label.numberOfLines = 0
        label.text = "1.竞拍成功后，若卖家72小时内未发货，可申请退款；\n2.竞拍商品不满意可与商家协商售后。"
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
        self.navigationItem.title = "竞拍说明"
        self.view.addSubview(self.scrollView)
        self.scrollView.addSubview(self.joinTitleLabel)
        self.scrollView.addSubview(self.joinAnswerLabel)
        self.scrollView.addSubview(self.appraisalTitleLabel)
        self.scrollView.addSubview(self.appraisalAnswerLabel)
        self.scrollView.addSubview(self.securityTitleLabel)
        self.scrollView.addSubview(self.securityAnswerLabel)
        self.scrollView.addSubview(self.afterSaleTitleLabel)
        self.scrollView.addSubview(self.afterSaleAnswerLabel)
        self.sp_addConstraint()
    }
    /// 处理有没数据
    override func sp_dealNoData(){
        
    }
    /// 添加约束
    fileprivate func sp_addConstraint(){
        self.scrollView.snp.makeConstraints { (maker) in
            maker.left.right.top.equalTo(self.view).offset(0)
            if #available(iOS 11.0, *) {
                maker.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(0)
            } else {
                maker.bottom.equalTo(self.view.snp.bottom).offset(0)
            }
        }
        self.joinTitleLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.scrollView).offset(22)
            maker.right.equalTo(self.scrollView).offset(-12)
            maker.top.equalTo(self.scrollView).offset(33)
            maker.height.greaterThanOrEqualTo(0)
            maker.centerX.equalTo(self.scrollView.snp.centerX).offset(0)
        }
        self.joinAnswerLabel.snp.makeConstraints { (maker) in
            maker.left.right.equalTo(self.joinTitleLabel).offset(0)
            maker.height.greaterThanOrEqualTo(0)
            maker.top.equalTo(self.joinTitleLabel.snp.bottom).offset(12)
           
        }
        self.appraisalTitleLabel.snp.makeConstraints { (maker) in
            maker.left.right.equalTo(self.joinTitleLabel).offset(0)
            maker.height.greaterThanOrEqualTo(0)
            maker.top.equalTo(self.joinAnswerLabel.snp.bottom).offset(33)
        }
        self.appraisalAnswerLabel.snp.makeConstraints { (maker) in
            maker.left.right.equalTo(self.joinTitleLabel).offset(0)
            maker.height.greaterThanOrEqualTo(0)
            maker.top.equalTo(self.appraisalTitleLabel.snp.bottom).offset(12)
        }
        self.securityTitleLabel.snp.makeConstraints { (maker) in
            maker.left.right.equalTo(self.joinTitleLabel).offset(0)
            maker.height.greaterThanOrEqualTo(0)
            maker.top.equalTo(self.appraisalAnswerLabel.snp.bottom).offset(33)
        }
        self.securityAnswerLabel.snp.makeConstraints { (maker) in
            maker.left.right.equalTo(self.joinTitleLabel).offset(0)
            maker.height.greaterThanOrEqualTo(0)
            maker.top.equalTo(self.securityTitleLabel.snp.bottom).offset(12)
        }
        self.afterSaleTitleLabel.snp.makeConstraints { (maker) in
            maker.left.right.equalTo(self.joinTitleLabel).offset(0)
            maker.height.greaterThanOrEqualTo(0)
            maker.top.equalTo(self.securityAnswerLabel.snp.bottom).offset(33)
        }
        self.afterSaleAnswerLabel.snp.makeConstraints { (maker) in
            maker.left.right.equalTo(self.joinTitleLabel).offset(0)
            maker.height.greaterThanOrEqualTo(0)
            maker.top.equalTo(self.afterSaleTitleLabel.snp.bottom).offset(12)
            maker.bottom.equalTo(self.scrollView.snp.bottom).offset(-10)
        }
    }
    deinit {
        
    }
}
