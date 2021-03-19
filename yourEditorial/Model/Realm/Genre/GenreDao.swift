//
//  GenreDao.swift
//  yourEditorial
//
//  Created by 塩見陵介 on 2020/10/27.
//

import UIKit
import RealmSwift

final class GenreDao: Dao {
    
    init(realm: Realm){
        super.init()
        connect(realm: realm)
    }
    
    func create(dic: Dictionary<String, Any?>){
        var newDic = dic
        let genre = Genre()
        newDic["genreId"] = getId()
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
    
    func update(genreId: String, dic: Dictionary<String, Any?>){
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
