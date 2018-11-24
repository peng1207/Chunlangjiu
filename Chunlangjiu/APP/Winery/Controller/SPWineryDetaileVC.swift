//
//  SPWineryDetaileVC.swift
//  Chunlangjiu
//
//  Created by 黄树鹏 on 2018/7/8.
//  Copyright © 2018年 Chunlang. All rights reserved.
//

import Foundation
import SnapKit
class SPWineryDetaileVC: SPBaseVC {
    
    fileprivate lazy var searchView : SPSearchView = {
        let view = SPSearchView(frame: CGRect(x: 0, y: 0, width: sp_getScreenWidth() - 120, height: 30))
        return view
    }()
    fileprivate lazy var searchBtn : UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "public_search_white"), for: UIControlState.normal)
        btn.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        btn.addTarget(self, action: #selector(sp_clickSearchAction), for: UIControlEvents.touchUpInside)
        return btn
    }()
    fileprivate lazy var headerView : SPWineryDetaileView = {
        let view = SPWineryDetaileView()
        view.titleLabel.text = sp_getString(string: self.wineryModel?.name)
        view.shareBtn.addTarget(self, action: #selector(sp_clickShare), for: UIControlEvents.touchUpInside)
        return view
    }()
    fileprivate lazy var btnView : SPWineryDetaileBtnView = {
        let view = SPWineryDetaileBtnView()
        view.btnClickBlock = { (index : Int) in
            self.sp_dealClickComplete(index: index)
        }
        return view
    }()
    fileprivate lazy var scrollView : UIScrollView = {
        let view = UIScrollView()
        view.delegate = self
        view.isPagingEnabled = true
        view.showsHorizontalScrollIndicator = false
        return view
    }()
    fileprivate lazy var  introductionView : SPWineryIntroductionView = {
        let view = SPWineryIntroductionView()
        return view
    }()
    fileprivate lazy var detaileInfoView : SPWineryDetaileInfoView = {
        let view = SPWineryDetaileInfoView()
        return view
    }()
    fileprivate lazy var scoreView : SPWineryScoreView = {
        let view = SPWineryScoreView()
        return view
    }()
    fileprivate lazy var pictureView : SPWineryPictureView = {
        let view = SPWineryPictureView()
        return view
    }()
    var wineryModel : SPWinerModel?
    fileprivate var detaileModel : SPWinerDetaileModel?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "酒庄详情"
        sp_showAnimation(view: self.view, title: "加载中")
        self.sp_setupUI()
        sp_sendRequest()
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
//        self.navigationItem.titleView = self.searchView
//        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: self.searchBtn)
        self.view.addSubview(self.headerView)
        self.view.addSubview(self.btnView)
        self.view.addSubview(self.scrollView)
        self.scrollView.addSubview(self.introductionView)
        self.scrollView.addSubview(self.detaileInfoView)
        self.scrollView.addSubview(self.scoreView)
        self.scrollView.addSubview(self.pictureView)
        self.sp_addConstraint()
    }
    /// 添加约束
    fileprivate func sp_addConstraint(){
        self.headerView.snp.makeConstraints { (maker) in
            maker.left.right.top.equalTo(self.view).offset(0)
            maker.height.greaterThanOrEqualTo(0)
        }
        self.btnView.snp.makeConstraints { (maker) in
            maker.left.right.equalTo(self.view).offset(0)
            maker.top.equalTo(self.headerView.snp.bottom).offset(0)
            maker.height.equalTo(44)
        }
        self.scrollView.snp.makeConstraints { (maker) in
            maker.left.right.equalTo(self.view).offset(0)
            maker.top.equalTo(self.btnView.snp.bottom).offset(0)
            if #available(iOS 11.0, *) {
                maker.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(0)
            } else {
                maker.bottom.equalTo(self.view.snp.bottom).offset(0)
            }
        }
        self.introductionView.snp.makeConstraints { (maker) in
            maker.left.top.bottom.equalTo(self.scrollView).offset(0)
            maker.width.equalTo(self.scrollView.snp.width).offset(0)
            maker.centerY.equalTo(self.scrollView.snp.centerY).offset(0)
        }
        self.detaileInfoView.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.introductionView.snp.right).offset(0)
            maker.top.bottom.equalTo(self.scrollView).offset(0)
            maker.width.equalTo(self.scrollView.snp.width).offset(0)
        }
        self.scoreView.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.detaileInfoView.snp.right).offset(0)
            maker.top.bottom.equalTo(self.scrollView).offset(0)
            maker.width.equalTo(self.scrollView.snp.width).offset(0)
        }
        self.pictureView.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.scoreView.snp.right).offset(0)
            maker.top.bottom.equalTo(self.scrollView).offset(0)
            maker.width.equalTo(self.scrollView.snp.width).offset(0)
            maker.right.equalTo(self.scrollView.snp.right).offset(0)
        }
    }
    deinit {
        
    }
}
// MARK: - deleaget
extension SPWineryDetaileVC : UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let index = scrollView.contentOffset.x / scrollView.frame.size.width
        self.btnView.sp_dealBtnSelect(index: Int(index))
    }
}
// MARK: - action
extension SPWineryDetaileVC{
    @objc fileprivate func sp_clickSearchAction(){
        
    }
    /// 处理按钮点击 设置scrollview的contentoffset
    ///
    /// - Parameter index: 第几个
    fileprivate func sp_dealClickComplete(index : Int){
        self.scrollView.contentOffset = CGPoint(x: (self.scrollView.frame.size.width * CGFloat(integerLiteral: index)), y: 0)
    }
    @objc fileprivate func sp_clickShare(){
        let shareModel = SPShareDataModel()
        shareModel.title = sp_getString(string: self.detaileModel?.name)
        shareModel.descr = sp_getString(string: self.detaileModel?.content)
        shareModel.thumbImage = sp_getString(string: self.detaileModel?.img)
        shareModel.shareData = SP_SHARE_URL
        shareModel.currentViewController = self
        shareModel.placeholderImage = sp_getLogoImg()
        SPShareManager.sp_share(shareDataModel: shareModel) { (completModel, error) in
            
        }
    }
    /// 赋值
    fileprivate func sp_setupData(){
        self.headerView.detaileModel = self.detaileModel
        self.introductionView.detaileModel = self.detaileModel
        self.detaileInfoView.detaileModel = self.detaileModel
        var list = [String]()
        list.append(sp_getString(string: self.detaileModel?.img))
        self.pictureView.dataArray = list
        self.scoreView.dataArray = self.detaileModel?.grade
        
    }
}
extension SPWineryDetaileVC {
    fileprivate func sp_sendRequest(){
        var parm = [String : Any]()
        if let chateau_id = self.wineryModel?.chateau_id  {
             parm.updateValue(chateau_id, forKey: "chateau_id")
        }
       
        self.requestModel.parm = parm
        SPAppRequest.sp_getWinerDetaile(requestModel: self.requestModel) { [weak self](code, model , erroModel) in
            if code == SP_Request_Code_Success {
                self?.detaileModel = model
                self?.sp_setupData()
            }
            sp_hideAnimation(view: self?.view)
        }
    }
    
}
