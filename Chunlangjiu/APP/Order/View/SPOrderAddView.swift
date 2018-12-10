//
//  SPOrderAddVIew.swift
//  Chunlangjiu
//
//  Created by 黄树鹏 on 2018/9/3.
//  Copyright © 2018年 Chunlang. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

private let SP_APPLY_SHOWIMAGE_TAG     =  1000


class SPOrderAddView:  UIView{
    
    fileprivate lazy var addView : SPAddImageView = {
        let view = SPAddImageView()
        view.showImageView.titleLabel.text = "上传相关凭证"
        view.sp_border(color: SPColorForHexString(hex: SP_HexColor.color_dddddd.rawValue), width: sp_lineHeight)
        view.clickAddBlock = { [weak self](addImageView) in
            self?.sp_clickAddImage()
        }
        return view
    }()
    
    var selectImage = [UIImage]()
    /// 总数量
    private let maxCount = 3
    /// 每行显示多少个
    private let row = 3
    var viewController : UIViewController!
    var complete : SPBtnClickBlock?
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.sp_setupUI()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    /// 获取添加的图片
    ///
    /// - Returns: 图片
    func sp_getImage()->[UIImage]{
        var imageArray = [UIImage]()
        for i in 0..<self.maxCount {
            let showImae : SPAddImageView? = self.viewWithTag(SP_APPLY_SHOWIMAGE_TAG + i) as? SPAddImageView
            if let add = showImae {
                if  let image : UIImage = add.imageView.image {
                    imageArray.append(image)
                }
            }
        }
        
        return imageArray
    }
    
    /// 添加UI
    fileprivate func sp_setupUI(){
        self.addSubview(self.addView)
        var tmpView : UIView?
        
        for i in 0..<self.maxCount {
            let showImage = SPAddImageView()
            showImage.isHidden = true
            showImage.tag = SP_APPLY_SHOWIMAGE_TAG + i
            showImage.clickAddBlock = { [weak self](view) in
                self?.sp_clickShow(view: view)
            }
            
            self.addSubview(showImage)
            showImage.snp.makeConstraints { (maker) in
                if i % row == 0 {
                    maker.left.equalTo(self.snp.left).offset(10)
                    if let view = tmpView {
                        maker.top.equalTo(view.snp.bottom).offset(10)
                    }else{
                        maker.top.equalTo(self.snp.top).offset(10)
                    }
                }else{
                    if let view = tmpView {
                        maker.left.equalTo(view.snp.right).offset(10)
                        maker.top.equalTo(view.snp.top).offset(0)
                        maker.width.equalTo(view.snp.width).offset(0)
                    }else{
                        maker.left.equalTo(self.snp.left).offset(10)
                        maker.top.equalTo(self.snp.top).offset(10)
                    }
                    if i % row == row - 1 {
                        maker.right.equalTo(self.snp.right).offset(-10)
                    }
                }
                maker.height.equalTo(showImage.snp.width).offset(0)
            }
            tmpView = showImage
        }
        sp_updateAddLayout()
        self.sp_addConstraint()
    }
    /// 添加约束
    fileprivate func sp_addConstraint(){
        
    }
    deinit {
        
    }
}
extension SPOrderAddView{
    fileprivate func sp_clickShow(view : SPAddImageView){
        let alertController = UIAlertController(title: "提示", message: "是否删除", preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "删除", style: UIAlertActionStyle.default, handler: { (action) in
            let tag = view.tag - SP_APPLY_SHOWIMAGE_TAG
            if tag < self.selectImage.count{
                self.selectImage.remove(at: tag)
                self.sp_dealSelect()
            }
        }))
        alertController.addAction(UIAlertAction(title: "取消", style: UIAlertActionStyle.cancel, handler: { (action) in
            
        }))
        sp_mainQueue {
            viewController.present(alertController, animated: true, completion: nil)    
        }
        
    }
    fileprivate func sp_clickAddImage(){
        if sp_getArrayCount(array: self.selectImage) < self.maxCount {
            sp_showSelectImage(viewController: viewController, allowsEditing: false, delegate: self)
        }else{
            sp_showTextAlert(tips: "最多选择\(self.maxCount)张")
        }
    }
    /// 处理选择的图片
    fileprivate func sp_dealSelect(){
        for i in 0..<self.maxCount {
            let showImae : SPAddImageView? = self.viewWithTag(SP_APPLY_SHOWIMAGE_TAG + i) as? SPAddImageView
            if let add = showImae {
                if i < self.selectImage.count {
                    add.isHidden = false
                    add.sp_update(image: self.selectImage[i])
                }else{
                    add.isHidden = true
                }
            }
        }
        sp_updateAddLayout()
        sp_dealComplete()
    }
    fileprivate func sp_dealComplete(){
        guard let block = self.complete else {
            return
        }
        block()
    }
    /// 处理添加按钮的位置
    fileprivate func sp_updateAddLayout(){
        let remainder = self.selectImage.count % row
        let merchant = self.selectImage.count / row
        let showImage : SPAddImageView? = self.viewWithTag(merchant * (row - 1) + remainder - 1 + SP_APPLY_SHOWIMAGE_TAG) as? SPAddImageView
       self.addView.setNeedsLayout()
        self.addView.layoutIfNeeded()
        self.addView.snp.remakeConstraints { (maker) in
            if self.selectImage.count == 0 {
                maker.left.equalTo(self).offset(10)
                maker.top.equalTo(self.snp.top).offset(10)
            }else{
                if remainder == 0 {
                    maker.left.equalTo(self).offset(10)
                    if let view = showImage {
                        maker.top.equalTo(view.snp.bottom).offset(10)
                    }else{
                        maker.top.equalTo(self.snp.top).offset(10)
                    }
                }else{
                    if let view = showImage {
                        maker.top.equalTo(view.snp.top).offset(0)
                        maker.left.equalTo(view.snp.right).offset(10)
                    }else{
                        maker.left.equalTo(self).offset(10)
                        maker.top.equalTo(self.snp.top).offset(10)
                    }
                }
            }
            maker.width.equalTo(self.snp.width).multipliedBy(CGFloat(1.0/CGFloat(row))).offset(-(CGFloat(((row + 1) * 10))/CGFloat(row)))
            maker.height.equalTo(self.addView.snp.width).offset(0)
            maker.bottom.equalTo(self.snp.bottom).offset(-10)
        }
    }
    
}

extension SPOrderAddView : UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let image = info[ UIImagePickerControllerOriginalImage] as? UIImage
        if let i = image {
            self.selectImage.append(i)
        }
        sp_dealSelect()
        picker.dismiss(animated: true, completion: nil)
    }
}
