//
//  FavoriteNewsPaperDao.swift
//  yourEditorial
//
//  Created by 塩見陵介 on 2020/11/01.
//

import UIKit
import RealmSwift

final class FavoriteNewsPaperDao: NSObject, Dao {
    
    var realm: Realm!
    
    init(realm: Realm){
        super.init()
        connect(realm: realm)
    }
    
    func connect(realm: Realm) {
        self.realm = realm
    }
    
    // 採番
    private func getFavoriteNewsPaperNo() -> Int{
        
        let result = realm.objects(FavoriteNewsPaper.self).sorted(byKeyPath: "favoriteNewsPaperId", ascending: false).first
        
        if (result == nil){
            return 0
        }else{
            return result!.favoriteNewsPaperId + 1
        }
    }
    
    func create(dic: Dictionary<String, Any?>){
        let favoriteNewsPaper = FavoriteNewsPaper()
        favoriteNewsPaper.favoriteNewsPaperId = getFavoriteNewsPaperNo()
        favoriteNewsPaper.fromDic(dic)
        try! realm.write {
            realm.add(favoriteNewsPaper)
        }
    }
    
    func getFavoriteNewsPapers(filter: NSPredicate!) ->Array<FavoriteNewsPaper>{
        
        var results: Results<FavoriteNewsPaper>
        
        if filter != nil{
            results = realm.objects(FavoriteNewsPaper.self).filter(filter)
        }else{
            results = realm.objects(FavoriteNewsPaper.self)
        }
        let favoriteNewsPapers = Array(results)
        return favoriteNewsPapers
    }
    
    func delete(favoriteNewsPaperName: String){
        let favoriteNewsPaper = getFavoriteNewsPapers(filter: NSPredicate(format: "newsPaperName = %@", argumentArray: [favoriteNewsPaperName])).first
        try! realm.write {
            realm.delete(favoriteNewsPaper!)
        }
    }
    
}
