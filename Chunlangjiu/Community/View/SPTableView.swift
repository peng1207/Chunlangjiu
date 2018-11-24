//
//  SPTableView.swift
//  Chunlangjiu
//
//  Created by 黄树鹏 on 2018/7/6.
//  Copyright © 2018年 Chunlang. All rights reserved.
//

import Foundation
import UIKit

extension UITableView{
    func sp_layoutHeaderView (){
        let header = self.tableHeaderView
        header?.setNeedsLayout()
        header?.layoutIfNeeded()
        let height = header?.systemLayoutSizeFitting(UILayoutFittingCompressedSize).height
        var frame = header?.frame
        frame?.size.height = height!
        header?.frame = frame!
        self.tableHeaderView = header
    }
    func sp_layoutFooterView(){
        let footer = self.tableFooterView
        footer?.setNeedsLayout()
        footer?.layoutIfNeeded()
        let height = footer?.systemLayoutSizeFitting(UILayoutFittingCompressedSize).height
        var frame = footer?.frame
        frame?.size.height = height!
        footer?.frame = frame!
        self.tableFooterView = footer
    }
}


