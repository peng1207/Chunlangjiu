//
//  SPBlockHeader.swift
//  Chunlangjiu
//
//  Created by 黄树鹏 on 2018/7/8.
//  Copyright © 2018年 Chunlang. All rights reserved.
//

import Foundation

typealias SPBtnClickBlock = ()->Void
typealias SPBtnIndexClickBlock = (_ index : Int) -> Void
/// 获取列表的回调
typealias SPGetListComplete = (_ list : [Any]?) -> Void
