//
//  SPData.swift
//  Chunlangjiu
//
//  Created by 黄树鹏 on 2019/1/9.
//  Copyright © 2019 Chunlang. All rights reserved.
//

import Foundation

enum CryptoAlgorithm {
    /// 加密的枚举选项 AES/AES128/DES/DES3/CAST/RC2/RC4/Blowfish......
    case AES, AES128, DES, DES3, CAST, RC2,RC4, Blowfish
    var algorithm: CCAlgorithm {
        var result: UInt32 = 0
        switch self {
        case .AES:          result = UInt32(kCCAlgorithmAES)
        case .AES128:       result = UInt32(kCCAlgorithmAES128)
        case .DES:          result = UInt32(kCCAlgorithmDES)
        case .DES3:         result = UInt32(kCCAlgorithm3DES)
        case .CAST:         result = UInt32(kCCAlgorithmCAST)
        case .RC2:          result = UInt32(kCCAlgorithmRC2)
        case .RC4:          result = UInt32(kCCAlgorithmRC4)
        case .Blowfish:     result = UInt32(kCCAlgorithmBlowfish)
        }
        return CCAlgorithm(result)
    }
    var keyLength: Int {
        var result: Int = 0
        switch self {
        case .AES:          result = kCCKeySizeAES128
        case .AES128:       result = kCCKeySizeAES256
        case .DES:          result = kCCKeySizeDES
        case .DES3:         result = kCCKeySize3DES
        case .CAST:         result = kCCKeySizeMaxCAST
        case .RC2:          result = kCCKeySizeMaxRC2
        case .RC4:          result = kCCKeySizeMaxRC4
        case .Blowfish:     result = kCCKeySizeMaxBlowfish
        }
        return Int(result)
    }
    var cryptLength: Int {
        var result: Int = 0
        switch self {
        case .AES:          result = kCCKeySizeAES128
        case .AES128:       result = kCCBlockSizeAES128
        case .DES:          result = kCCBlockSizeDES
        case .DES3:         result = kCCBlockSize3DES
        case .CAST:         result = kCCBlockSizeCAST
        case .RC2:          result = kCCBlockSizeRC2
        case .RC4:          result = kCCBlockSizeRC2
        case .Blowfish:     result = kCCBlockSizeBlowfish
        }
        return Int(result)
    }
}


extension NSData {
    
 
}
// MARK: - Data    Data打印出来是16或者32 bytes,打印需转成NSData类型打印结果比较直观
// MARK: - data
extension Data {
    
}
