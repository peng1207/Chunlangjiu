//
//  SPSetData.swift
//  Chunlangjiu
//
//  Created by chengzong liang on 2018/12/13.
//  Copyright © 2018年 Chunlang. All rights reserved.
//

import Foundation
class SPSetData {
    
    class func sp_getSetData()->[Array<SPSetModel>]{
        var array = [Array<SPSetModel>]()
        var firstArray = [SPSetModel]()
        var secondArray = [SPSetModel]()
        firstArray.append(SPSetModel.sp_init(title: "登录密码", type: SPSetType.loginPwd))
        firstArray.append(SPSetModel.sp_init(title: "我的资料", type: SPSetType.info))
        firstArray.append(SPSetModel.sp_init(title: "我的认证", type: SPSetType.auth))
        firstArray.append(SPSetModel.sp_init(title: "地址管理", type: SPSetType.address))
        firstArray.append(SPSetModel.sp_init(title: "银行卡管理", type: SPSetType.bankCard))
        secondArray.append(SPSetModel.sp_init(title: "关于醇狼", type: SPSetType.about))
        secondArray.append(SPSetModel.sp_init(title: "使用协议", type: SPSetType.agreement))
        array.append(firstArray)
        array.append(secondArray)
        return array
    }
    
    
}
