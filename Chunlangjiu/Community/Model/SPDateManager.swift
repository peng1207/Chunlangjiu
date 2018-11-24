//
//  SPDateManager.swift
//  Chunlangjiu
//
//  Created by chengzong liang on 2018/9/5.
//  Copyright © 2018年 Chunlang. All rights reserved.
//

import Foundation
class  SPDateManager  : NSObject {
    
    private static let dateManager = SPDateManager()
    private lazy var dataFormatter : DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        return formatter
    }()
    private lazy var timeFormatter : DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    fileprivate class func instance() -> SPDateManager{
        return dateManager
    }
    /// 时间戳转字符串时间
    ///
    /// - Parameter timeInterval: 时间戳
    /// - Returns: 时间字符串
    class func sp_string(to timeInterval : TimeInterval?)-> String{
        if let time = timeInterval {
            let date = Date(timeIntervalSince1970: time)
            return  SPDateManager.instance().dataFormatter.string(from: date)
        }else{
            return ""
        }
    }
    /// 字符串时间转时间戳
    ///
    /// - Parameter string: 字符串时间
    /// - Returns: 时间戳
    class func sp_timeInterval(to  string : String?)->TimeInterval{
        if sp_getString(string: string).count > 0 {
            let date = SPDateManager.instance().dataFormatter.date(from: string!)
            if let d = date{
                return d.timeIntervalSince1970
            }
        }
        return 0
    }
    class func sp_timeInterval(to date:Date?)->TimeInterval{
        if let d = date{
            return d.timeIntervalSince1970
        }
        return 0
    }
    ///  时间戳转date格式
    ///
    /// - Parameter timeInterval: 时间戳
    /// - Returns: date
    class func sp_date(to timeInterval : TimeInterval?)-> Date?{
        if let time = timeInterval {
            return Date(timeIntervalSince1970: time)
        }
        return nil
    }
    /// 转换为年月日的格式的
    ///
    /// - Parameter date: 日期
    /// - Returns: 年月日
    class func sp_dateString(to date : Date)-> String{
        return SPDateManager.instance().timeFormatter.string(from: date)
    }
}
