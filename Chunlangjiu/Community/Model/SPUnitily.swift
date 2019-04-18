//
//  SPUnitily.swift
//  Chunlangjiu
//
//  Created by 黄树鹏 on 2018/7/4.
//  Copyright © 2018年 Chunlang. All rights reserved.
//

import Foundation
import UIKit

/// 线的高度
let sp_lineHeight = 1 / UIScreen.main.scale         // 设置1的分割线
/// 导航栏的高度
let SP_NAVGIT_HEIGHT : CGFloat = 44
let SP_TABBAR_HEIGHT : CGFloat = 60
let SP_TABBAR_DEFAULT_HEIGHT : CGFloat = 49
let SP_CHINE_MONEY = "¥"
//获取程序的Home目录
/// 获取主目录
let SP_HOMEDIRECTORY = NSHomeDirectory()
/// 获取临时目录
let SP_TMPPATH =  NSTemporaryDirectory()
/// 获取缓存目录
let SP_CACHEPATH = NSHomeDirectory() + "/Library/Caches"
typealias SPSelectImgComplete = (_ img : UIImage?)->Void

/// 获取屏幕的宽度
///
/// - Returns: 宽度
func sp_getScreenWidth() -> CGFloat{
    return UIScreen.main.bounds.width;
}
/// 获取屏幕的高度
///
/// - Returns: 高度
func sp_getScreenHeight() -> CGFloat{
    return UIScreen.main.bounds.height
}
/// 获取状态栏高度
///
/// - Returns: 状态栏高度
func sp_getstatusBarHeight() -> CGFloat{
    return UIApplication.shared.statusBarFrame.size.height
}
/// 是否大屏幕
///
/// - Returns: True 大屏幕 false 小屏幕
func sp_isLargeScreen()->Bool{
    if sp_getScreenWidth() < 375{
        return false
    }else{
        return true
    }
    
}
/// 获取不同像素同样高度不同的比例
///
/// - Parameter height: 高度
/// - Returns: 不同像素对应的高度
func sp_heightOfScale(height:CGFloat) -> CGFloat{
    return height / UIScreen.main.scale
}
/// 获取字体
///
/// - Parameter size: 字体大小
/// - Returns: 字体
func sp_getFontSize(size:CGFloat) -> UIFont{
    return UIFont.systemFont(ofSize: size)
}
/// 判断是否为数组
///
/// - Parameter array: 数据源
/// - Returns: 返回数组类型
func sp_isArray(array:Any) -> Array<Any>{
    let list : Array<Any>? = array as? Array<Any>
    if let a = list {
        return a
    }
    return []
}
/// 获取数组的数量
///
/// - Parameter array: 数组
/// - Returns: 数量
func sp_getArrayCount(array:Array<Any>?) -> Int{
    if let listArray = array {
        return listArray.count
    }else{
        return 0
    }
}
/// 是否为数组
///
/// - Parameter array: 数据
/// - Returns: 是否
func sp_isArray(array:Any?) -> Bool {
    if let _ : [Any] = array as? [Any]  {
        return true
    }else{
        return false
    }
}
/// 是否为字典
///
/// - Parameter dic: 数据
/// - Returns: 是否
func sp_isDic(dic : Any?) -> Bool{
    if let _ : [String : Any] = dic as? [String : Any] {
        return true
    }else{
        return false
    }
}
/// 获取字符串
///
/// - Parameter string: 字符串
/// - Returns: 字符串
func sp_getString(string:Any?) ->  String{
    if string == nil{
        return ""
    }
    if string is NSNull {
        return ""
    }
    let str : String? = string as? String
    
    if let s = str {
        return s
    }
    if string is NSNumber {
        let s : NSNumber = string as! NSNumber
        return s.description
    }
    return "\(string.debugDescription)"
    
}
func sp_log<T>(message : T,file : String = #file,methodName: String = #function, lineNumber: Int = #line){
    #if DEBUG
    let fileName = (file as NSString).lastPathComponent
    print("\(fileName).\(methodName)[\(lineNumber)]\(Date().timeIntervalSince1970):\(message)")
    #endif
}

/// 获取统一的分割线
///
/// - Returns: 分割线
func sp_getLineView() -> UIView{
    let lineView = UIView()
    lineView.backgroundColor = SPColorForHexString(hex: SP_HexColor.color_eeeeee.rawValue)
    return lineView
}

/// 多线程
///
/// - Parameters:
///   - queueName:  线程名字
///   - complete: 回调
func sp_simpleSQueues(queueName : String? = "com.queue.defauleQueue" ,complete : ()->Void){
    let queue = DispatchQueue(label: queueName!)
    queue.sync {
        complete()
    }
}
/// 主线程
///
/// - Parameter comlete: 回调
func sp_mainQueue(comlete:@escaping ()->Void){
    DispatchQueue.main.async {
        comlete()
    }
   
}
/// 执行延迟操作
///
/// - Parameters:
///   - time: 延迟时间
///   - complete: 回调
func sp_asyncAfter(time : TimeInterval,complete:@escaping ()->Void){
    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+time) {
        complete()
    }
}

/// 显示动画
///
/// - Parameters:
///   - view: 显示在哪个view
///   - title: 标题
func sp_showAnimation(view : UIView?,title : String?,afterDelay : TimeInterval = 0.0) {
    var superView : UIView
    if let v = view {
        superView = v
    }else{
        let appdelete : AppDelegate = UIApplication.shared.delegate as! AppDelegate
        superView = appdelete.window!
    }
    let hudView = MBProgressHUD(view: superView)
    hudView.label.text = title
    hudView.label.textColor = UIColor.white
    hudView.bezelView.color = SPColorForHexString(hex: SP_HexColor.color_333333.rawValue)
    superView.addSubview(hudView)
    hudView.show(animated: true)
    if afterDelay > 0 {
        hudView.hide(animated: true, afterDelay: afterDelay)
    }
}
/// 隐藏view
///
/// - Parameter view: 在那个view隐藏
func sp_hideAnimation(view : UIView?){
    var superView : UIView
    if let v = view {
        superView = v
    }else{
        let appdelete : AppDelegate = UIApplication.shared.delegate as! AppDelegate
        superView = appdelete.window!
    }
    MBProgressHUD.hide(for: superView, animated: true)
}
/// 提示语提示框
///
/// - Parameters:
///   - tips: 提示语
///   - afterDelay: 延迟几秒隐藏
func sp_showTextAlert(tips:String,afterDelay : TimeInterval = 2.0) {
    if sp_getString(string: tips).count > 0 {
        let appdelete : AppDelegate = UIApplication.shared.delegate as! AppDelegate
        let hudView = MBProgressHUD(view: appdelete.window!)
        hudView.mode = .text
        hudView.label.font = sp_getFontSize(size: 14)
        hudView.label.textColor = UIColor.white
        hudView.label.text = tips
        hudView.bezelView.color = SPColorForHexString(hex: SP_HexColor.color_333333.rawValue)
        appdelete.window?.addSubview(hudView)
        hudView.show(animated: true)
        hudView.hide(animated: true, afterDelay: afterDelay)
    }
}
///  获取联系人姓名首字母(传入汉字字符串, 返回大写拼音首字母)
///
/// - Parameter aString: 字符串
/// - Returns: 首字母
func sp_getFirstLetterFromString(aString: String) -> (String) {
    
    // 注意,这里一定要转换成可变字符串
    let mutableString = NSMutableString.init(string: aString)
    // 将中文转换成带声调的拼音
    CFStringTransform(mutableString as CFMutableString, nil, kCFStringTransformToLatin, false)
    // 去掉声调(用此方法大大提高遍历的速度)
    let pinyinString = mutableString.folding(options: String.CompareOptions.diacriticInsensitive, locale: NSLocale.current)
    // 将拼音首字母装换成大写
    let strPinYin = sp_polyphoneStringHandle(nameString: aString, pinyinString: pinyinString).uppercased()
    // 截取大写首字母
    let firstString = strPinYin.substring(to: strPinYin.index(strPinYin.startIndex, offsetBy:1))
    // 判断姓名首位是否为大写字母
    let regexA = "^[A-Z]$"
    let predA = NSPredicate.init(format: "SELF MATCHES %@", regexA)
    return predA.evaluate(with: firstString) ? firstString : "#"
}
/// 多音字处理
///
/// - Parameters:
///   - nameString: 字符串
///   - pinyinString: 拼音
/// - Returns: 拼音
func sp_polyphoneStringHandle(nameString:String, pinyinString:String) -> String {
    if nameString.hasPrefix("长") {return "chang"}
    if nameString.hasPrefix("沈") {return "shen"}
    if nameString.hasPrefix("厦") {return "xia"}
    if nameString.hasPrefix("地") {return "di"}
    if nameString.hasPrefix("重") {return "chong"}
    
    return pinyinString;
}
/// 隐藏键盘
func sp_hideKeyboard(){
    UIApplication.shared.keyWindow?.endEditing(true)
}
func sp_showSelectImage(viewController : UIViewController,allowsEditing:Bool = true,delegate:(UIImagePickerControllerDelegate & UINavigationControllerDelegate)?){
    let  actionSheetVC = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
    let takePhoto = UIAlertAction(title: "拍照", style: UIAlertActionStyle.default) { (action) in
        SPAuthorizatio.isRightCamera(authoriedBlock: { (success) in
            if success {
                 sp_showPhotLib(viewController: viewController, type: .camera,allowsEditing: allowsEditing,delegate: delegate)
            }else{
                sp_noCameraAuth(viewController: viewController)
            }
        })
       
    }
    let photoLib = UIAlertAction(title: "相册", style: UIAlertActionStyle.default) { (action) in
        SPAuthorizatio.isRightPhoto(authoriedBlock: { (success) in
            if success {
                sp_showPhotLib(viewController: viewController, type: UIImagePickerControllerSourceType.photoLibrary,allowsEditing: allowsEditing,delegate: delegate)
            }else{
                sp_noPhotoAuth(viewController: viewController)
            }
        })

    }
    let cance = UIAlertAction(title: "取消", style: UIAlertActionStyle.cancel) { (action) in
        
    }
    actionSheetVC.addAction(takePhoto)
    actionSheetVC.addAction(photoLib)
    actionSheetVC.addAction(cance)
    sp_mainQueue {
        viewController.present(actionSheetVC, animated: true, completion: nil)
    }
    
}

func sp_showPhotLib(viewController : UIViewController,type:UIImagePickerControllerSourceType,allowsEditing:Bool = true,delegate:(UIImagePickerControllerDelegate & UINavigationControllerDelegate)?){
    if !UIImagePickerController.isSourceTypeAvailable(type) {
        return
    }
    let imagePickerController = UIImagePickerController()
    imagePickerController.delegate = delegate
    imagePickerController.allowsEditing = allowsEditing
    imagePickerController.sourceType = type
    imagePickerController.navigationBar.tintColor = UIColor.white
    viewController.present(imagePickerController, animated: true, completion: nil)
}

func sp_thrSelectImg(viewController : UIViewController,nav : UINavigationController?,compete:SPSelectImgComplete?){
    let  actionSheetVC = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
    let takePhoto = UIAlertAction(title: "拍照", style: UIAlertActionStyle.default) { (action) in
        SPAuthorizatio.isRightCamera(authoriedBlock: { (success) in
            if success {
                sp_takePhoto(type: .camera, nav: nav, complete: compete)
            }else{
                // 没权限
                sp_noCameraAuth(viewController: viewController)
            }
        })
        
    }
    let photoLib = UIAlertAction(title: "相册", style: UIAlertActionStyle.default) { (action) in
        SPAuthorizatio.isRightPhoto(authoriedBlock: { (success) in
            if success {
                sp_takePhoto(type: .photoLibrary, nav: nav, complete: compete)
            }else{
                // 没权限
                sp_noPhotoAuth(viewController: viewController)
            }
        })
    }
    let cance = UIAlertAction(title: "取消", style: UIAlertActionStyle.cancel) { (action) in
        
    }
    actionSheetVC.addAction(takePhoto)
    actionSheetVC.addAction(photoLib)
    actionSheetVC.addAction(cance)
    sp_mainQueue {
        viewController.present(actionSheetVC, animated: true, completion: nil)
    }
    
}
func sp_takePhoto(type:UIImagePickerControllerSourceType,nav : UINavigationController?,complete:SPSelectImgComplete?){
    KiClipperHelper.sharedInstance.nav = nav
    KiClipperHelper.sharedInstance.clippedImgSize = CGSize(width: sp_getScreenWidth(), height: sp_getScreenWidth())
    KiClipperHelper.sharedInstance.clippedImageHandler = {(img) in
        if let block = complete {
            block(img)
        }
    }
    KiClipperHelper.sharedInstance.clipperType = .Move
    KiClipperHelper.sharedInstance.systemEditing = false
    KiClipperHelper.sharedInstance.isSystemType = false
    KiClipperHelper.sharedInstance.photoWithSourceType(type: type)
}
/// 没有相机的权限
///
/// - Parameter viewController: 当前z控制器
func sp_noCameraAuth(viewController : UIViewController){
    let  alertController = UIAlertController(title: "提示", message: "您还没打开相机的权限，无法进行拍照,请前往设置允许", preferredStyle: UIAlertControllerStyle.alert)
    let setAction = UIAlertAction(title: "前往设置", style: UIAlertActionStyle.default) { (action) in
        sp_pushSysSet()
    }
    let cance = UIAlertAction(title: "取消", style: UIAlertActionStyle.cancel) { (action) in
        
    }
    alertController.addAction(cance)
    alertController.addAction(setAction)
    sp_mainQueue {
        viewController.present(alertController, animated: true, completion: nil)
    }
    
}
/// 没有相册的权限
///
/// - Parameter viewController: 当前控制器
func sp_noPhotoAuth(viewController : UIViewController){
    let  alertController = UIAlertController(title: "提示", message: "您还没打开相册的权限，无法进行选择图片,请前往设置允许", preferredStyle: UIAlertControllerStyle.alert)
    let setAction = UIAlertAction(title: "前往设置", style: UIAlertActionStyle.default) { (action) in
        sp_pushSysSet()
    }
    let cance = UIAlertAction(title: "取消", style: UIAlertActionStyle.cancel) { (action) in
        
    }
    alertController.addAction(cance)
    alertController.addAction(setAction)
    sp_mainQueue {
        viewController.present(alertController, animated: true, completion: nil)
    }
    
}

/// 跳到系统设置界面
func sp_pushSysSet(){
    let settingUrl = URL(string: UIApplicationOpenSettingsURLString)
    if let url = settingUrl {
        if  UIApplication.shared.canOpenURL(url)
        {
            UIApplication.shared.openURL(url)
        }
    }
}

/// 字典转json字符串
///
/// - Parameter dic: 字典
/// - Returns: json字符串
func sp_dicValueString(_ dic:[String : Any]) -> String?{
    let data = try? JSONSerialization.data(withJSONObject: dic, options: [])
    let str = String(data: data!, encoding: String.Encoding.utf8)
    return str
}
/// json字符串转字典
///
/// - Parameter str: json字符串
/// - Returns: 字典
func  sp_stringValueDic(_ str: String) -> [String : Any]?{
    let data = str.data(using: String.Encoding.utf8)
    if let d = data {
        if let dict = try? JSONSerialization.jsonObject(with: d, options: JSONSerialization.ReadingOptions.mutableContainers) as? [String : Any] {
            return dict
        }
    }
    
   
    return nil
}
/// json字符串转数组
///
/// - Parameter str: json字符串
/// - Returns: 数组
func sp_stringValueArr(_ str : String) -> [Any]?{
    let data = str.data(using: String.Encoding.utf8)
    if let d = data{
        if let array = try? JSONSerialization.jsonObject(with: d, options: JSONSerialization.ReadingOptions.mutableContainers)  as? [Any]{
            return array
        }
    }
   
    return nil
}
func sp_arrayValueString(_ array : [Any]) -> String?{
    let data = try? JSONSerialization.data(withJSONObject: array, options: [])
    let str = String(data: data!, encoding: String.Encoding.utf8)
    return str
}

/// 获取键盘高度
///
/// - Parameter notification: 键盘弹起通知
/// - Returns: 高度
func sp_getKeyBoardheight(notification:Notification)->CGFloat{
    let userinfo: NSDictionary = notification.userInfo! as NSDictionary
    
    let nsValue = userinfo.object(forKey: UIKeyboardFrameEndUserInfoKey) as! NSValue
    
    let keyboardRec = nsValue.cgRectValue
    
    let height = keyboardRec.size.height
    return height
}
func sp_showAlertClick(vc : UIViewController?,title:String?,msg:String?,cance:String?,done:String?,canceComplete:(()->Void)?,doneComplete:(()->Void)?){
    
    if vc == nil {
        return
    }
    
    let alertVC = UIAlertController(title: title, message: msg, preferredStyle: UIAlertControllerStyle.alert)
    
    if sp_getString(string: cance).count > 0  {
        let canceAction = UIAlertAction(title: cance, style: UIAlertActionStyle.cancel) { (action) in
            if let block = canceComplete{
                block()
            }
        }
        alertVC.addAction(canceAction)
    }
    if sp_getString(string: done).count > 0 {
        let doneAction = UIAlertAction(title: done, style: UIAlertActionStyle.default) { (action) in
            if let block = doneComplete{
                block()
            }
        }
        alertVC.addAction(doneAction)
    }
    sp_mainQueue {
        vc?.present(alertVC, animated: true, completion: nil)
    }
    
    
    
}
/// 防止图片颠倒
///
/// - Parameter aImage: 图片
/// - Returns: 转换后的图片
func sp_fixOrientation(aImage: UIImage) -> UIImage {
    // No-op if the orientation is already correct
    if aImage.imageOrientation == .up {
        return aImage
    }
    // We need to calculate the proper transformation to make the image upright.
    // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
    
    var transform: CGAffineTransform = CGAffineTransform.identity
    switch aImage.imageOrientation {
    case .down, .downMirrored:
       
        transform =  CGAffineTransform(translationX: aImage.size.width, y: aImage.size.height)
        transform = transform.rotated(by: .pi)
    case .left, .leftMirrored:
    
        transform = CGAffineTransform(translationX: aImage.size.width, y: 0)
        transform = transform.rotated(by: .pi / 2)
    case .right, .rightMirrored:

        transform =  CGAffineTransform(translationX: 0, y: aImage.size.height)
        transform = transform.rotated(by: -.pi / 2)
    default:
        break
    }
    
    switch aImage.imageOrientation {
    case .upMirrored, .downMirrored:
        transform = transform.translatedBy(x: aImage.size.width, y: 0)
        transform = transform.scaledBy(x: -1, y: 1)
    case .leftMirrored, .rightMirrored:
        transform = transform.translatedBy(x: aImage.size.height, y: 0)
        transform = transform.scaledBy(x: -1, y: 1)
    default:
        break
    }
    //这里需要注意下CGImageGetBitmapInfo，它的类型是Int32的，CGImageGetBitmapInfo(aImage.CGImage).rawValue，这样写才不会报错

    if aImage.cgImage?.bitsPerComponent == nil {
        return aImage
    }
    
    if aImage.cgImage?.bitmapInfo == nil {
        return aImage
    }
    if aImage.cgImage?.colorSpace == nil {
        return aImage
    }
 
    
    let ctx = CGContext(data: nil, width: Int(aImage.size.width), height: Int(aImage.size.height), bitsPerComponent: aImage.cgImage!.bitsPerComponent, bytesPerRow: 0, space: aImage.cgImage!.colorSpace!, bitmapInfo: aImage.cgImage!.bitmapInfo.rawValue)

    
    
    ctx?.concatenate(transform)
    switch aImage.imageOrientation {
    case .left, .leftMirrored, .right, .rightMirrored:
        // Grr...
        ctx?.draw(aImage.cgImage!, in: CGRect(x: CGFloat(0), y: CGFloat(0), width: CGFloat(aImage.size.height), height: CGFloat(aImage.size.width)))
//        CGContextDrawImage(ctx, CGRect(x: 0, y: 0, width: aImage.size.height, height: aImage.size.width), aImage.cgImage)
    default:
        ctx?.draw(aImage.cgImage!, in: CGRect(x: CGFloat(0), y: CGFloat(0), width: CGFloat(aImage.size.width), height: CGFloat(aImage.size.height)))
//        CGContextDrawImage(ctx,  CGRect(x: 0, y: 0, width: aImage.size.width, height: aImage.size.height), aImage.cgImage)
    }
    
    // And now we just create a new UIImage from the drawing context
   
    let cgimg: CGImage = (ctx?.makeImage())!
    
    let img = UIImage(cgImage: cgimg)

    return img
}

/// 图片压缩方法
///
/// - Parameters:
///   - sourceImage: 图片
///   - maxImageLenght: 最大的图片长度
///   - maxSizeKB: 最大的kb
/// - Returns: data
func sp_resetImgSize(sourceImage : UIImage,maxImageLenght : CGFloat = 750.0,maxSizeKB : CGFloat = 0.0) -> Data {
    
    var maxSize = maxSizeKB
    
    var maxImageSize = maxImageLenght
    
    
    
    if (maxSize <= 0.0) {
        
        maxSize = 1024.0;
        
    }
    
    if (maxImageSize <= 0.0)  {
        
        maxImageSize = 1024.0;
        
    }
    
    //先调整分辨率
    
    var newSize = CGSize.init(width: sourceImage.size.width, height: sourceImage.size.height)
    
    let tempHeight = newSize.height / maxImageSize;
    
    let tempWidth = newSize.width / maxImageSize;
    
    if (tempWidth > 1.0 && tempWidth > tempHeight) {
        
        newSize = CGSize.init(width: sourceImage.size.width / tempWidth, height: sourceImage.size.height / tempWidth)
        
    }
        
    else if (tempHeight > 1.0 && tempWidth < tempHeight){
        
        newSize = CGSize.init(width: sourceImage.size.width / tempHeight, height: sourceImage.size.height / tempHeight)
        
    }
    
    UIGraphicsBeginImageContext(newSize)
    
    sourceImage.draw(in: CGRect.init(x: 0, y: 0, width: newSize.width, height: newSize.height))
    
    let newImage = UIGraphicsGetImageFromCurrentImageContext()
    
    UIGraphicsEndImageContext()
    
    var imageData = UIImageJPEGRepresentation(newImage!, 1.0)
    
    var sizeOriginKB : CGFloat = CGFloat((imageData?.count)!) / 1024.0;
    
    //调整大小
    
    var resizeRate = 0.9;
    
    while (sizeOriginKB > maxSize && resizeRate > 0.1) {
        
        imageData = UIImageJPEGRepresentation(newImage!,CGFloat(resizeRate));
        
        sizeOriginKB = CGFloat((imageData?.count)!) / 1024.0;
        
        resizeRate -= 0.1;
        
    }
    
    return imageData!
    
}

/// 保存数据到UserDefaults
///
/// - Parameters:
///   - data: 数据
///   - key: 对应的key
func sp_saveUser(data:Any?,key:String){
    UserDefaults.standard.set(data, forKey: key)
    UserDefaults.standard.synchronize()
}
/// 从UserDefaults获取数据
///
/// - Parameter key: 对应的key
/// - Returns: 数据
func sp_getUser(key:String)->Any?{
    return UserDefaults.standard.value(forKey: key)
}
func sp_getInt(price : String?)-> Int{
    if sp_getString(string: price).count > 0  {
        let priceArray : [String] = sp_getString(string: price).components(separatedBy: ".")
        var newPrice : String = ""
        if priceArray.count > 0 {
            newPrice.append(sp_getString(string: priceArray.first))
            if priceArray.count > 1 {
                var string : String = sp_getString(string: priceArray[1])
                if string.count > 2 {
                    let range = string.index(string.startIndex, offsetBy: 2)..<string.endIndex
                    string.removeSubrange(range)
                }
                newPrice.append(string)
            }else{
                newPrice.append("00")
            }
        }else{
            newPrice = "0"
        }
        if let i = Int(newPrice) {
            return i
        }
    }
    return 0
}
/// 判断第一个价格是否小于第二个价格
///
/// - Parameters:
///   - price: 第一个价格
///   - secondPrice: 第二个价格
/// - Returns: 是否小于
func sp_compare(price:String?,secondPrice : String?)->Bool{
    var check = false
    if sp_getInt(price: price) < sp_getInt(price: secondPrice) {
        check = true
    }
    return check
}


/// 计算价格 只保留两位 两个值相乘
///
/// - Parameters:
///   - price: 价格
///   - count: 数量
/// - Returns: 计算好的价格
func sp_multiplying(price:String,count:String)->String{
    if sp_getString(string: price).count > 0 , sp_getString(string: count).count > 0 {
        let priceArray : [String] = price.components(separatedBy: ".")
       let countArray : [String] = count.components(separatedBy: ".")
        var newPrice : String = ""
        if priceArray.count > 0 {
           newPrice.append(sp_getString(string: priceArray.first))
            if priceArray.count > 1 {
                var string : String = sp_getString(string: priceArray[1])
                if string.count > 2 {
                    let range = string.index(string.startIndex, offsetBy: 2)..<string.endIndex
                    string.removeSubrange(range)
                }
                newPrice.append(string)
            }else{
                newPrice.append("00")
            }
        }else{
            newPrice = "0"
        }
        sp_log(message: "重新的newPrice is \(newPrice)")
        var newCount : String = ""
        if countArray.count > 0 {
            newCount.append(sp_getString(string: countArray.first))
            if countArray.count > 1 {
                var string : String = sp_getString(string: countArray[1])
                if string.count > 2 {
                    let range = string.index(string.startIndex, offsetBy: 2)..<string.endIndex
                    string.removeSubrange(range)
                }
                newCount.append(string)
            }else{
                newCount.append("00")
            }
        }else{
            newCount = "0000"
        }
        sp_log(message: "重新的newCount is \(newCount)")
        let total : Int = Int(newPrice)! * Int(newCount)!
        var totalPrice : String = sp_getString(string: String(total))
        if totalPrice.count > 2 {
            totalPrice.remove(at: totalPrice.index(before: totalPrice.endIndex))//删除最后一个字符
            totalPrice.remove(at: totalPrice.index(before: totalPrice.endIndex))//删除最后一个字符
        }
        
        
        if totalPrice.count > 2 {
            totalPrice.insert(".", at: totalPrice.index(totalPrice.startIndex, offsetBy: totalPrice.count - 2))
            
        }else if totalPrice.count == 2{
            totalPrice = "0.\(totalPrice)"
        }else if totalPrice.count == 1{
            totalPrice = "0.0\(totalPrice)"
        }else {
            totalPrice = "0.00"
        }
        return totalPrice
    }else if sp_getString(string: price).count > 0 {
        return sp_getString(string: price)
    }else if sp_getString(string: count).count > 0 {
        return sp_getString(string: count)
    }
    return "0.00"
}
/// 两个价格相加 只保留两位
///
/// - Parameters:
///   - price: 第一个加数
///   - addPrice: 第二个加数
/// - Returns: 相加的结果
func sp_add(price:String, addPrice : String) -> String{
    if sp_getString(string: price).count > 0 , sp_getString(string: addPrice).count > 0 {
        let priceArray : [String] = price.components(separatedBy: ".")
        let countArray : [String] = addPrice.components(separatedBy: ".")
        var newPrice : String = ""
        if priceArray.count > 0 {
            newPrice.append(sp_getString(string: priceArray.first))
            if priceArray.count > 1 {
                var string : String = sp_getString(string: priceArray[1])
                if string.count > 2 {
                    let range = string.index(string.startIndex, offsetBy: 2)..<string.endIndex
                    string.removeSubrange(range)
                }
                newPrice.append(string)
            }else{
                newPrice.append("00")
            }
        }else{
            newPrice = "0"
        }
        sp_log(message: "重新的newPrice is \(newPrice)")
        var newCount : String = ""
        if countArray.count > 0 {
            newCount.append(sp_getString(string: countArray.first))
            if countArray.count > 1 {
                var string : String = sp_getString(string: countArray[1])
                if string.count > 2 {
                    let range = string.index(string.startIndex, offsetBy: 2)..<string.endIndex
                    string.removeSubrange(range)
                }
                newCount.append(string)
            }else{
                newCount.append("00")
            }
        }else{
            newCount = "0000"
        }
        sp_log(message: "重新的newCount is \(newCount)")
        let total : Int = Int(newPrice)! + Int(newCount)!
        var totalPrice : String = sp_getString(string: String(total))
        if totalPrice.count > 2 {
            totalPrice.insert(".", at: totalPrice.index(totalPrice.startIndex, offsetBy: totalPrice.count - 2))
            
        }else if totalPrice.count == 2{
            totalPrice = "0.\(totalPrice)"
        }else if totalPrice.count == 1{
            totalPrice = "0.0\(totalPrice)"
        }else {
            totalPrice = "0.00"
        }
        
        return totalPrice
    }else if sp_getString(string: price).count > 0 {
        return sp_getString(string: price)
    }else if sp_getString(string: addPrice).count > 0 {
        return sp_getString(string: addPrice)
    }
    return "0.00"
}
/// 秒数转换成时分秒
///
/// - Parameter second: 秒数
/// - Returns: 转换后的格式
func sp_change(second : Int) ->(String,String,String,String){
    var hourStr = "00"
    var minuStr = "00"
    var secondStr = "00"
    var dayStr = "00"
    let hour = second / 3600
    dayStr = String(format: "%02ld", hour / 24  )
    hourStr = String(format: "%02ld", hour % 24  )
    minuStr = String(format: "%02d", (second % 3600)/60)
    secondStr =  String(format: "%02ld", second % 60)
    return (dayStr,hourStr,minuStr,secondStr)
}
/// 复制功能
///
/// - Parameter text: 复制内容
func sp_copy(text :String?)->Void{
    //就这两句话就实现了
    let paste = UIPasteboard.general
    paste.string = sp_getString(string: text)
    sp_showTextAlert(tips: "复制成功")
}
/// 拨打电话
///
/// - Parameter text: 号码
func sp_openTel(text:String?)->Void{
    if let url = URL(string: "tel://\(sp_getString(string: text))") {
        UIApplication.shared.openURL(url)
    }
}

func sp_getAppIcon()->UIImage?{
    let infoPlist = Bundle.main.infoDictionary
    if let dic = infoPlist {
        let icons : [String :Any]?   = dic["CFBundleIcons"] as? [String : Any]
        if let iconDic : [String : Any] = icons {
            let primaryIcon : [String : Any]? = iconDic["CFBundlePrimaryIcon"] as? [String : Any]
            if let primaryIconDic = primaryIcon {
                let files : [String]?  = primaryIconDic["CFBundleIconFiles"] as? [String]
                if sp_getArrayCount(array: files) > 0 {
                     return UIImage(named: sp_getString(string: files?.last))
                }
            }
        }
        
        //            let icons = dic["CFBundleIcons.CFBundlePrimaryIcon.CFBundleIconFiles"]
        
    }
    return nil
}

/// 获取沙盒cache目录
///
/// - Returns: 目录
func sp_getCachePath()->String{
     let cachePath = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first
    return sp_getString(string: cachePath)
}
