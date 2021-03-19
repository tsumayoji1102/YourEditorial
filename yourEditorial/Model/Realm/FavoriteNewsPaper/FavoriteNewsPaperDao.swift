//
//  FavoriteNewsPaperDao.swift
//  yourEditorial
//
//  Created by 塩見陵介 on 2020/11/01.
//

import UIKit
import RealmSwift

final class FavoriteNewsPaperDao: Dao {
    
    init(realm: Realm){
        super.init()
        connect(realm: realm)
    }
    
    func create(dic: Dictionary<String, Any?>){
        let favoriteNewsPaper = FavoriteNewsPaper()
        favoriteNewsPaper.favoriteNewsPaperId = getId()
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
        let favoriteNewsPaper = getFavoriteNewsPapers(filter: NSPredicate(format: "favoriteNewsPaperName = %@", argumentArray: [favoriteNewsPaperName])).first
        try! realm.write {
            realm.delete(favoriteNewsPaper!)
        }
    }
    
}
