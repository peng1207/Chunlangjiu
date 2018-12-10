//
//  SPWebVC.swift
//  Chunlangjiu
//
//  Created by 黄树鹏 on 2018/7/21.
//  Copyright © 2018年 Chunlang. All rights reserved.
//

import Foundation
import SnapKit
import WebKit
class SPWebVC: SPBaseVC {
    
    lazy var userController : WKUserContentController = {
        let vc = WKUserContentController()
        vc.add(self, name: pushWeb)
        vc.add(self, name: logout)
        vc.add(self, name: closePage)
        vc.add(self, name: jsToNav)
        return vc
    }()
    
    lazy var webConfiguration : WKWebViewConfiguration = {
        let configuration = WKWebViewConfiguration()
        configuration.userContentController = self.userController
        return configuration
    }()
    
    lazy var webView : WKWebView = {
        let view = WKWebView(frame: .zero, configuration: self.webConfiguration)
        view.uiDelegate = self
        view.navigationDelegate = self
        view.scrollView.delegate = self
        return view
    }()
    fileprivate lazy var backBtn : UIButton = {
        let btn = UIButton(type: .custom)
        btn.frame = CGRect(x: 0, y: 0, width: 40, height: 30)
        btn.setImage(UIImage(named: "public_back"), for: .normal)
         btn.contentEdgeInsets = UIEdgeInsets(top: 0, left: -30, bottom: 0, right: 0)
        btn.addTarget(self, action: #selector(sp_clickBackAction), for: UIControlEvents.touchUpInside)
        return btn
    }()
    fileprivate lazy var closeBtn : UIButton = {
        let btn = UIButton(type: .custom)
        btn.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        btn.setImage(UIImage(named: "public_close_white"), for: .normal)
        btn.contentEdgeInsets = UIEdgeInsets(top: 0, left: -25, bottom: 0, right: 0)
        btn.addTarget(self, action: #selector(sp_clickCloseAction), for: UIControlEvents.touchUpInside)
        return btn
    }()
    /// 跳到新的网页
    fileprivate let pushWeb : String = "pushWeb"
    /// 退出登录
    fileprivate let logout = "logout"
    /// 关闭当前的页面
    fileprivate let closePage = "closePage"
    /// js到原生的交互
    fileprivate let jsToNav = "jsToNav"
    var url : URL?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.sp_setupUI()
        self.sp_setupData()
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
    /// 赋值
    fileprivate func sp_setupData(){
        if let u = self.url {
            self.webView.load(URLRequest(url: u))
        }
    }
    func sp_reloadUrl(){
        sp_setupData()
    }
    override func sp_clickBackAction() {
        if self.webView.canGoBack{
            self.webView.goBack()
        }else{
            sp_clickCloseAction()
        }
    }
   @objc fileprivate func sp_clickCloseAction(){
        sp_remove()
        self.navigationController?.popViewController(animated: true)
    }
     func sp_remove(){
        self.userController.removeScriptMessageHandler(forName: pushWeb)
        self.userController.removeScriptMessageHandler(forName: logout)
        self.userController.removeScriptMessageHandler(forName: closePage)
        self.userController.removeScriptMessageHandler(forName: jsToNav)
    }
    /// 创建UI
    override func sp_setupUI() {
       
        self.view.addSubview(self.webView)
       
        self.sp_addConstraint()
        if #available(iOS 11.0, *) {
            self.webView.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentBehavior.never
        } else {
           self.automaticallyAdjustsScrollViewInsets = false
        }
       let backItem = UIBarButtonItem(customView: self.backBtn)
       let closeItem = UIBarButtonItem(customView: self.closeBtn)
       self.navigationItem.leftBarButtonItems = [backItem,closeItem]
        
    }
    /// 添加约束
    fileprivate func sp_addConstraint(){
        self.webView.snp.makeConstraints { (maker) in
            maker.left.top.right.equalTo(self.view).offset(0)
            if #available(iOS 11.0, *) {
                maker.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(0)
            } else {
                // Fallback on earlier versions
                 maker.bottom.equalTo(self.view.snp.bottom).offset(0)
            }
        }
    }
    
    deinit {
        self.webView.stopLoading()
        self.webView.uiDelegate = nil
        self.webView.navigationDelegate = nil
        self.webView.scrollView.delegate = nil
        sp_log(message: "网页销毁")
    }
}
extension SPWebVC : WKUIDelegate,WKNavigationDelegate,UIScrollViewDelegate,WKScriptMessageHandler{
  
    
    //MARK: - WKNavigationDelegate
    // 页面开始加载时调用
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        
    }
    // 当内容开始返回时调用
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        
    }
    // 页面加载完成之后调用
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        
    }
    //接收到服务器跳转请求之后调用
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        
    }
    //在发送请求之前，决定是否跳转
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        decisionHandler(WKNavigationActionPolicy.allow)
    }
    // 在收到响应后，决定是否跳转
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
         decisionHandler(WKNavigationResponsePolicy.allow)
    }
    //MARK: - WKUIDelegate
    // 输入框
    func webView(_ webView: WKWebView, runJavaScriptTextInputPanelWithPrompt prompt: String, defaultText: String?, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (String?) -> Void) {
        let alertController = UIAlertController(title: prompt, message: "", preferredStyle: UIAlertControllerStyle.alert)
        alertController.addTextField { (textFiled : UITextField) in
            textFiled.text = defaultText
        }
        alertController.addAction(UIAlertAction(title: "完成", style: UIAlertActionStyle.default, handler: { (action : UIAlertAction) in
            var text = ""
           
            if  sp_getArrayCount(array: alertController.textFields) > 0 {
                let textFiled : UITextField = alertController.textFields![0]
                text = textFiled.text!
            }
            completionHandler(text)
        }))
        self.present(alertController, animated: true, completion: nil)
    }
    //确认框
    func webView(_ webView: WKWebView, runJavaScriptConfirmPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (Bool) -> Void) {
        let alertController = UIAlertController(title: nil, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "取消", style: UIAlertActionStyle.cancel, handler: { (action : UIAlertAction) in
            completionHandler(false)
        }))
        alertController.addAction(UIAlertAction(title: "确定", style: UIAlertActionStyle.default, handler: { (action:UIAlertAction) in
            completionHandler(true)
        }))
        self.present(alertController, animated: true, completion: nil)
    }
    // 警告框
    func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
      let alertController = UIAlertController(title: "提示", message: message, preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "确认", style: UIAlertActionStyle.default, handler: { (action:UIAlertAction) in
            completionHandler()
        }))
        self.present(alertController, animated: true, completion: nil)
    }
    // 接收到html的回调
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        if sp_getString(string: message.name) == pushWeb {
            if let dic : [String: Any] = message.body as? [String : Any]{
                let urlString = sp_getString(string: dic["url"])
                let title = sp_getString(string: dic["title"])
                if urlString.count > 0  {
                    let webVC = SPWebVC()
                    webVC.url = URL(string: urlString)
                    webVC.title = title
                    self.navigationController?.pushViewController(webVC, animated: true)
                }
            }
        }else if sp_getString(string: message.name) == logout{
            sp_logout()
            SPAPPManager.instance().userModel = nil
            NotificationCenter.default.post(name: NSNotification.Name(SP_LOGOUT_NOTIFICATION), object: nil)
              sp_remove()
            self.navigationController?.popToRootViewController(animated: true)
        }else if sp_getString(string: message.name) == closePage{
            if let vcArray = self.navigationController?.viewControllers {
                if vcArray.count > 2 {
                    if vcArray.count - 2 >= 0 && vcArray.count - 2 < vcArray.count{
                         let vc = vcArray[vcArray.count - 2]
                        if let webVC : SPWebVC = vc as? SPWebVC {
                            webVC.sp_reloadUrl()
                        }
                    }
                }
            }
            sp_clickCloseAction()
        }else if sp_getString(string: message.name) == jsToNav{
            if let dic : [String:Any] = message.body as? [String:Any]{
                let method = sp_getString(string: dic["method"])
                if sp_getString(string: method) == "goodsDetail" {
                    if let itemID : Int = Int(sp_getString(string:  dic["itemId"])) {
                        let detaileVC = SPProductDetaileVC()
                        let productModel = SPProductModel()
                        productModel.item_id = itemID
                        detaileVC.productModel = productModel
                        self.navigationController?.pushViewController(detaileVC, animated: true)
                    }
                }else if sp_getString(string: method) == "editGoodsDetail" {
                    let editVC = SPProductAddVC()
                    editVC.title = "编辑商品"
                    editVC.edit = true
                    editVC.item_id = sp_getString(string: dic["itemId"])
                    self.navigationController?.pushViewController(editVC, animated: true)
                }else if sp_getString(string: method) == "addGoods"{
                    let addVC = SPProductAddVC()
                    addVC.title = "添加商品"
                    self.navigationController?.pushViewController(addVC, animated: true)
                }else if sp_getString(string: method) == "login"{
                    SPAPPManager.sp_login()
                }else if sp_getString(string: method) == "showStartTimeDialog"{
                    SPDatePicker.sp_show(datePickerMode: UIDatePicker.Mode.dateAndTime, minDate: Date(), maxDate: nil) { [weak self](date) in
                        self?.webView.evaluateJavaScript("setStartTime('\(Int(SPDateManager.sp_timeInterval(to: date)))')", completionHandler: { (data, error) in
                            
                        })
                    }
                }else if sp_getString(string: method) == "showEndTimeDialog"{
                    SPDatePicker.sp_show(datePickerMode: UIDatePicker.Mode.dateAndTime, minDate: Date(), maxDate: nil) {  [weak self](date) in
                        self?.webView.evaluateJavaScript("setEndTime('\(Int(SPDateManager.sp_timeInterval(to: date)))')", completionHandler: { (data, error) in
                            
                        })
                    }
                }
            }
            
        }
      
        
    }
}
// MARK: - request
extension SPWebVC{
    fileprivate func sp_logout(){
        let request = SPRequestModel()
        SPAppRequest.sp_getLogout(requestModel: request) { (code, msg, errorModel) in
            
        }
        
    }
}
