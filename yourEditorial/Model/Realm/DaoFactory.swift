//
//  DaoFactory.swift
//  yourEditorial
//
//  Created by 塩見陵介 on 2020/10/25.
//

import UIKit
import RealmSwift

enum DaoRoutes: Int{
    case clip = 0
    case favoriteNewsPaper
    case genre
}

final class DaoFactory: NSObject {
    
    let realm: Realm = try! Realm()
    
    override init(){
        super.init()
    }
    
    deinit {
    }
    
    func getDao(daoRoute: DaoRoutes) -> Dao!{
        
        switch daoRoute {
        case DaoRoutes.clip:
            let clipDao = ClipDao(realm: realm)
            return clipDao
        case DaoRoutes.favoriteNewsPaper:
            let favoriteNewsPaperDao = FavoriteNewsPaperDao(realm: realm)
            return favoriteNewsPaperDao
        case DaoRoutes.genre:
            let genreDao = GenreDao(realm: realm)
            return genreDao
        }
    }
}

protocol DaoDelegate: NSObject {
    func connect(realm: Realm)
    func getId() -> String
}

class Dao: NSObject, DaoDelegate {
    
    var realm: Realm!
    
    func connect(realm: Realm) {
        self.realm = realm
    }
    
    func getId() -> String {
        var id = UUID().uuidString
        Log.getLogWithMessage(message: "id: \(id)")
        return id
    }
}
