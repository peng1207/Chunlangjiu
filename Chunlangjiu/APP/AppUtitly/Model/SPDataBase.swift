//
//  SPDataBase.swift
//  Chunlangjiu
//
//  Created by 黄树鹏 on 2018/8/16.
//  Copyright © 2018年 Chunlang. All rights reserved.
//

import Foundation
import RealmSwift

class SPRealmTool : Object {
    /// 配置数据库
     class func configRealm(){
        /// 如果要存储的数据模型属性发生变化,需要配置当前版本号比之前大
         let dbVersion : UInt64 = 26
        let docPath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)[0] as String
        let dbPath = docPath.appending("/chunlangDB.realm")
        sp_log(message: "数据库地址:\(dbPath)")
        let config = Realm.Configuration(fileURL: URL.init(string: dbPath), inMemoryIdentifier: nil, syncConfiguration: nil, encryptionKey: nil, readOnly: false, schemaVersion: dbVersion, migrationBlock: { (migration, oldSchemaVersion) in

        }, deleteRealmIfMigrationNeeded: false, shouldCompactOnLaunch: nil, objectTypes: nil)
        Realm.Configuration.defaultConfiguration = config
        Realm.asyncOpen { (realm, error) in
            if let _ = realm {
             sp_log(message: "Realm 服务器配置成功!")
            }else if let error = error {
                sp_log(message: "Realm 数据库配置失败：\(error.localizedDescription)")
            }
        }
    }
}

// MARK: - 配置商品搜索的数据
extension SPRealmTool {
    
    class func sp_insert(searchRecord : SPSearchRecord) {
        let realm = try! Realm()
         let tem = realm.objects(SPSearchRecord.self).filter("searchValue == %@",sp_getString(string: searchRecord.searchValue))
        try! realm.write {
            realm.delete(tem)
            realm.add(searchRecord)
        }
    }
    class func sp_getProductSearch()-> [SPSearchRecord]{
        var list = [SPSearchRecord]()
         let realm = try! Realm()
        let lists = realm.objects(SPSearchRecord.self)
        for model in lists {
            try! realm.write {
                  model.sp_calTextWidth()
            }
            if sp_getString(string: model.searchValue).count > 0 {
                 list.append(model)
            }
        }
        return list
    }
    class func sp_delete(list : [SPSearchRecord]?){
         let realm = try! Realm()
        if sp_getArrayCount(array: list) > 0 ,let s = list {
            try! realm.write {
                 realm.delete(s)
//                for model in list! {
//                    realm.delete(model)
//                }
            }
        }
    }
    class func sp_insert(areaModel:SPAreaModel){
        let realm = try! Realm()
        let tem = realm.objects(SPCityHistoryModel.self).filter("value == %@",sp_getString(string: areaModel.value))
        try! realm.write {
            realm.delete(tem)
            let historyModel = SPCityHistoryModel()
            historyModel.value = sp_getString(string: areaModel.value)
            realm.add(historyModel)
        }
    }
    class func sp_getCityHistory()->[SPAreaModel]{
        var list = [SPAreaModel]()
        let realm = try! Realm()
        let lists = realm.objects(SPCityHistoryModel.self)
        for model in lists {
            let areaModel = SPAreaModel()
            areaModel.value = model.value
          
            list.append(areaModel)
          
        }
        return list
    }
    
    class func sp_insertAuthSuccess(isAlert : Bool){
        let model = SPMineAuthModel()
        model.isShowAlert = isAlert ? "1" : "0"
        model.status = "1"
        model.user_id = sp_getString(string: SPAPPManager.instance().userModel?.user_id)
        let realm = try! Realm()
         let predicate = NSPredicate(format: "status = %@ and user_id = %@", "1",sp_getString(string: SPAPPManager.instance().userModel?.user_id))
        let tem = realm.objects(SPMineAuthModel.self).filter(predicate)
        try! realm.write {
            realm.delete(tem)
            realm.add(model)
        }
    }
    class func sp_insertAuthFaile(isAlert : Bool){
        let model = SPMineAuthModel()
        model.isShowAlert =  isAlert ? "1" : "0"
        model.status = "0"
        model.user_id = sp_getString(string: SPAPPManager.instance().userModel?.user_id)
        let realm = try! Realm()
         let predicate = NSPredicate(format: "status = %@ and user_id = %@", "0",sp_getString(string: SPAPPManager.instance().userModel?.user_id))
        let tem = realm.objects(SPMineAuthModel.self).filter(predicate)
        try! realm.write {
            realm.delete(tem)
            realm.add(model)
        }
    }
    class func sp_getIsAlert(isSuccess : Bool)->Bool {
        var isShow : Bool = false
        let realm = try! Realm()
        if isSuccess {
           let predicate =  NSPredicate(format: "status = %@ and user_id = %@", "1",sp_getString(string: SPAPPManager.instance().userModel?.user_id))
            let tem = realm.objects(SPMineAuthModel.self).filter(predicate)
            for model in tem {
                if sp_getString(string: model.isShowAlert) == "1"{
                    isShow = true
                    break
                }
            }
        }else {
            let predicate =  NSPredicate(format: "status = %@ and user_id = %@", "0",sp_getString(string: SPAPPManager.instance().userModel?.user_id))
            let tem = realm.objects(SPMineAuthModel.self).filter(predicate)
            for model in tem {
                if sp_getString(string: model.isShowAlert) == "1"{
                    isShow = true
                    break
                }
            }
        }
        
        return isShow
    }
    
}


