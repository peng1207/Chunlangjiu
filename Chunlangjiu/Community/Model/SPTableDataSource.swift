//
//  SPTableDataSource.swift
//  Chunlangjiu
//
//  Created by 黄树鹏 on 2018/12/14.
//  Copyright © 2018年 Chunlang. All rights reserved.
//

import Foundation
typealias SPTableSection = ()->Int
typealias SPTableRow = (_ section : Int)->Int
typealias SPTableCell = (_ indexPath : IndexPath)->UITableViewCell
class SPTableDataSource : NSObject ,UITableViewDataSource{
    fileprivate var sectionBlock : SPTableSection?
    fileprivate var rowBlock : SPTableRow?
    fileprivate var cellBlock : SPTableCell?
    fileprivate var cellID : String!
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if let block = self.sectionBlock {
            return block()
        }
        return 0
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let block = self.rowBlock {
            return block(section)
        }
        return 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: cellID)
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: cellID)
        }
    
        return UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "")
    }
    
}
