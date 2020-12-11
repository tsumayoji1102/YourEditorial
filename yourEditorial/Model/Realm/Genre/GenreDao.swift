//
//  GenreDao.swift
//  yourEditorial
//
//  Created by 塩見陵介 on 2020/10/27.
//

import UIKit
import RealmSwift

final class GenreDao: NSObject, Dao {
    
    var realm: Realm!
    
    init(realm: Realm){
        super.init()
        connect(realm: realm)
    }
    
    func connect(realm: Realm) {
        self.realm = realm
    }
    
    // 採番
    func getGenreNo() -> Int{
        
        let result = realm.objects(Genre.self).sorted(byKeyPath: "genreId", ascending: false).first
        
        if (result == nil){
            return 0
        }else{
            return result!.genreId + 1
        }
    }
    
    func create(dic: Dictionary<String, Any?>){
        var newDic = dic
        let genre = Genre()
        newDic["genreId"] = getGenreNo()
        genre.fromDic(newDic)
        try! realm.write {
            realm.add(genre)
        }
    }
    
    func getGenres(filter: NSPredicate!) ->Array<Genre>{
        
        var results: Results<Genre>
        if filter != nil{
            results = realm.objects(Genre.self).filter(filter)
        }else{
            results = realm.objects(Genre.self)
        }
        let genres = Array(results)
        return genres
    }
    
    func update(genreId: Int, dic: Dictionary<String, Any?>){
        let genre = getGenres(filter: NSPredicate(format: "genreId = %@", argumentArray: [genreId])).first
        try! realm.write {
            genre?.update(dic)
        }
    }
    
    func delete(genre: Genre){
        try! realm.write {
            realm.delete(genre)
        }
    }
    

}
