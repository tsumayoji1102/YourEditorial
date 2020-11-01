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
            let clipDao = ClipDao()
            clipDao.connect(realm: realm)
            return clipDao
        case DaoRoutes.genre:
            let genreDao = GenreDao()
            genreDao.connect(realm: realm)
            return genreDao
        }
    }
}

protocol Dao: NSObject {
    func connect(realm: Realm)
}
