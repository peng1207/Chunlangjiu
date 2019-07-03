//
//  SPDevice.swift
//  Chunlangjiu
//
//  Created by 黄树鹏 on 2018/7/4.
//  Copyright © 2018年 Chunlang. All rights reserved.
//

import Foundation
import UIKit
let SP_IOS_VERSION = UIDevice.current.systemVersion             //iOS版本
let SP_IDENTIFIERNUMBER = UIDevice.current.identifierForVendor?.uuidString       //设备udid
let SP_SYSTEMNAME = UIDevice.current.systemName                     //设备名称
let SP_MODEL = UIDevice.current.model                           //设备型号
let SP_LOCALIZEDMODEL = UIDevice.current.localizedModel         //设备区域化型号如A1533
