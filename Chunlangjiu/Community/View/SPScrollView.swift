//
//  SPScrollView.swift
//  Chunlangjiu
//
//  Created by 黄树鹏 on 2018/8/11.
//  Copyright © 2018年 Chunlang. All rights reserved.
//

import Foundation
import UIKit
import ESPullToRefresh
typealias SPScrollRefeshComplete = ()->Void

extension UIScrollView {
    /// 增加刷新控件
    func sp_headerRefesh(refeshComplete : SPScrollRefeshComplete?){
            
         self.es.addPullToRefresh {
            guard let block = refeshComplete else {
                return
            }
            block()
        }
         
    }
    /// 增加加载更多控件
    func sp_footerRefresh(refeshComplete : SPScrollRefeshComplete?){
        self.es.addInfiniteScrolling {
            guard let block = refeshComplete else {
                return
            }
            block()
        }
    }
    /// 停止刷新
    func sp_stopHeaderRefesh(){
        self.es.stopPullToRefresh()
        
    }
    /// 停止加载更多
    func sp_stopFooterRefesh(){
        self.es.stopLoadingMore()

    }
}
