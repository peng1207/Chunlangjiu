//
//  SPAppImg.swift
//  Chunlangjiu
//
//  Created by 黄树鹏 on 2018/12/25.
//  Copyright © 2018 Chunlang. All rights reserved.
//

import Foundation


/// 获取城市合伙人图片
///
/// - Returns: 图片
func sp_getPartnerImg()->UIImage?{
    return UIImage(named: "public_partner")
}
/// 获取默认用户的图片
///
/// - Returns: 图片
func sp_getDefaultUserImg()->UIImage?{
    return UIImage(named: "public_defaultUser")
}
/// 获取星级用户图片
///
/// - Returns: 图片
func sp_getStartUserImg()->UIImage?{
    return UIImage(named: "public_startUser")
}
