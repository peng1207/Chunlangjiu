//
//  SPString.swift
//  Chunlangjiu
//
//  Created by 黄树鹏 on 2019/1/8.
//  Copyright © 2019 Chunlang. All rights reserved.
//

import Foundation
import CryptoSwift
extension String {
    static let key = "chunlang"
    static let iv = ""
    /// 隐藏手机号码中间四位
    ///
    /// - Returns: 隐藏后的字符串
    func replacePhone() -> String {
        if self.count != 11 {
            return self
        }
        let start = self.index(self.startIndex, offsetBy: 3)
        let end = self.index(self.startIndex, offsetBy: 7)
        let range = Range(uncheckedBounds: (lower: start, upper: end))
        return self.replacingCharacters(in: range, with: "****")
    }
 
    public static func Endcode_AES_ECB(strToEncode:String)->String {
        // 从String 转成data
        let data = strToEncode.data(using: String.Encoding.utf8)
        
        // byte 数组
        var encrypted: [UInt8] = []
        do {
            encrypted = try AES(key: key, iv: iv).encrypt((data?.bytes)!)
//            encrypted = try AES(key: key, iv: iv, blockMode: .CBC, padding: .pkcs7).encrypt(data!.bytes)
        } catch AES.Error.dataPaddingRequired {
            // block size exceeded
        } catch {
            // some error
        }
        
        let encoded = NSData.init(bytes: encrypted, length: encrypted.count)
        //加密结果要用Base64转码
        return encoded.base64EncodedString(options: NSData.Base64EncodingOptions.lineLength64Characters)
    }
    //  MARK:  AES-ECB128解密
    public static func Decode_AES_ECB(strToDecode:String)->String {
        //decode base64
        let data = NSData(base64Encoded: strToDecode, options: NSData.Base64DecodingOptions.init(rawValue: 0))
        
        // byte 数组
        var encrypted: [UInt8] = []
        // 把data 转成byte数组
        for i in 0..<16 {
            var temp:UInt8 = 0
            data?.getBytes(&temp, range: NSRange(location: i,length:1 ))
            encrypted.append(temp)
        }
        // decode AES
        var decrypted: [UInt8] = []
        do {
            decrypted = try AES(key: key, iv: iv).decrypt(encrypted)
//            decrypted = try AES(key: key, iv: iv, blockMode:.CBC, padding: PKCS7()).decrypt(encrypted)
        } catch AES.Error.dataPaddingRequired {
            // block size exceeded
        } catch {
            // some error
        }
        
        // byte 转换成NSData
        let encoded = NSData.init(bytes: decrypted, length: decrypted.count)
        var str = ""
        //解密结果从data转成string
        str = String(data: encoded as Data, encoding: String.Encoding.utf8)!
        return str
    }
  
    
    /// 加密数据
    ///
    /// - Parameter keyStr: 加密密钥
    /// - Returns: 加密数据
    func sp_enCrypt(keyStr:String)->String{
        let keyData = keyStr.data(using: String.Encoding.utf8)
        var data = self.data(using: String.Encoding.utf8)
        if let _ = data , let key = keyData {
            
            let result = data?.enCrypt(algorithm: CryptoAlgorithm.AES, keyData: key)
            print(String(data: result!, encoding: String.Encoding.utf8)!)
            return sp_getString(string:NSString(data: result!, encoding: String.Encoding.utf8.rawValue))
        }
        return ""
    }
    /// 解密数据
    ///
    /// - Parameter keyStr: 加密密钥
    /// - Returns: 解密数据
    func sp_deCrypt(keyStr:String)->String{
        let keyData : NSData! = (keyStr as NSString).data(using: String.Encoding.utf8.rawValue) as! NSData
        let data : NSData! = (self as NSString).data(using: String.Encoding.utf8.rawValue) as! NSData
        let deData = data.deCrypt(algorithm: .AES, keyData: keyData)
        return sp_getString(string:String(data: deData! as Data, encoding: String.Encoding.utf8))
    }
    
}
