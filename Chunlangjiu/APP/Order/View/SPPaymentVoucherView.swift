//
//  SPPaymentVoucherView.swift
//  Chunlangjiu
//
//  Created by 黄树鹏 on 2018/9/2.
//  Copyright © 2018年 Chunlang. All rights reserved.
//

import Foundation
import UIKit
import SnapKit


typealias SPPaymentComplete = (_ image : UIImage) -> Void

class SPPaymentVoucherView:  UIView{
    
    fileprivate lazy var contentView : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        return view
    }()
    fileprivate lazy var titleLabel : UILabel = {
        let label = UILabel()
        label.text = "上传支付凭证"
        label.font = sp_getFontSize(size: 16)
        label.textColor = SPColorForHexString(hex: SP_HexColor.color_333333.rawValue)
        return label
    }()
    fileprivate lazy var closeBtn : UIButton = {
        let btn = UIButton(type: UIButtonType.custom)
        btn.setTitle("X", for: UIControlState.normal)
        btn.titleLabel?.font = sp_getFontSize(size: 20)
        btn.addTarget(self, action: #selector(sp_clickCance), for: UIControlEvents.touchUpInside)
        return btn
    }()
    fileprivate lazy var  addImageView : SPAddImageView = {
        let view = SPAddImageView()
        view.showImageView.titleLabel.text = "上传凭证"
        view.clickAddBlock = { [weak self](addImageView) in
        }
        return view
    }()
    fileprivate lazy var canceBtn : UIButton = {
        let btn = UIButton(type: UIButtonType.custom)
        btn.setTitle("取消", for: UIControlState.normal)
        btn.setTitleColor(SPColorForHexString(hex: SP_HexColor.color_333333.rawValue), for: UIControlState.normal)
        btn.titleLabel?.font = sp_getFontSize(size: 18)
        btn.addTarget(self, action: #selector(sp_clickCance), for: UIControlEvents.touchUpInside)
        return btn
    }()
    fileprivate lazy var doneBtn : UIButton = {
        let btn = UIButton(type: UIButtonType.custom)
        btn.setTitleColor(UIColor.white, for: UIControlState.normal)
        btn.backgroundColor = SPColorForHexString(hex: SP_HexColor.color_b31f3f.rawValue)
        btn.setTitle("确定", for: UIControlState.normal)
        btn.titleLabel?.font = sp_getFontSize(size: 18)
        btn.addTarget(self, action: #selector(sp_clickDone), for: UIControlEvents.touchUpInside)
        return btn
    }()
    fileprivate var clickBlock : SPPaymentComplete?
    fileprivate var viewController : UIViewController!
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.sp_setupUI()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    class func sp_show(viewController : UIViewController,complete:SPPaymentComplete?){
        let view = SPPaymentVoucherView()
        view.clickBlock = complete
        view.viewController = viewController
        let appdelegate : AppDelegate = UIApplication.shared.delegate as! AppDelegate
        appdelegate.window?.addSubview(view)
        view.snp.makeConstraints { (maker) in
            maker.left.right.bottom.top.equalTo(appdelegate.window!).offset(0)
        }
    }
    
    /// 添加UI
    fileprivate func sp_setupUI(){
        self.addSubview(self.contentView)
        self.addSubview(self.titleLabel)
        self.addSubview(self.closeBtn)
        self.addSubview(self.addImageView)
        self.addSubview(self.canceBtn)
        self.addSubview(self.doneBtn)
        self.sp_addConstraint()
    }
    /// 添加约束
    fileprivate func sp_addConstraint(){
        self.contentView.snp.makeConstraints { (maker) in
            maker.left.equalTo(self).offset(16)
            maker.right.equalTo(self).offset(-16)
            maker.height.greaterThanOrEqualTo(0)
            maker.centerY.equalTo(self.snp.centerY).offset(0)
        }
        self.titleLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.contentView.snp.left).offset(12)
            maker.top.equalTo(self.contentView).offset(0)
            maker.height.equalTo(44)
            maker.width.greaterThanOrEqualTo(0)
        }
        self.closeBtn.snp.makeConstraints { (maker) in
            maker.right.equalTo(self.contentView.snp.right).offset(-10)
            maker.width.equalTo(30)
            maker.height.equalTo(30)
            maker.centerY.equalTo(self.titleLabel.snp.centerY).offset(0)
        }
        self.addImageView.snp.makeConstraints { (maker) in
            maker.width.equalTo(100)
            maker.height.equalTo(100)
            maker.centerX.equalTo(self.contentView.snp.centerX).offset(0)
            maker.top.equalTo(self.titleLabel.snp.bottom).offset(40)
        }
        self.canceBtn.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.contentView.snp.left).offset(0)
            maker.top.equalTo(self.addImageView.snp.bottom).offset(40)
            maker.width.equalTo(self.doneBtn.snp.width).offset(0)
            maker.height.equalTo(40)
            maker.bottom.equalTo(self.contentView).offset(0)
        }
        self.doneBtn.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.canceBtn.snp.right).offset(0)
            maker.top.height.equalTo(self.canceBtn).offset(0)
            maker.right.equalTo(self.contentView.snp.right).offset(0)
        }
    }
    deinit {
        
    }
}
extension SPPaymentVoucherView {
    @objc fileprivate func sp_clickCance(){
        self.removeFromSuperview()
    }
    @objc fileprivate func sp_clickDone(){
        guard let image  = self.addImageView.imageView.image else {
            sp_showTextAlert(tips: "请上传凭证")
            return
        }
        
        guard let block = self.clickBlock else {
            return
        }
        block(image)
        sp_clickCance()
    }
    fileprivate func sp_clickAdd(){
       sp_showSelectImage(viewController: self.viewController, allowsEditing: false, delegate: self)
    }
}
extension SPPaymentVoucherView:UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let image = info[ UIImagePickerControllerOriginalImage] as? UIImage
        self.addImageView.sp_update(image: image)
        picker.dismiss(animated: true, completion: nil)
    }
}

