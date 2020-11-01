//
//  GenreDao.swift
//  yourEditorial
//
//  Created by 塩見陵介 on 2020/10/27.
//

import UIKit
import RealmSwift

class GenreDao: NSObject, Dao {
    
    var realm: Realm!
    
    override init(){
        super.init()
        
    }
    
    func connect(realm: Realm) {
        self.realm = realm
    }

    
    func create(dic: Dictionary<String, Any?>){
        let genre = Genre()
        genre.fromDic(dic)
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
            genre?.fromDic(dic)
        }
    }
    

}
