//
//  Genre.swift
//  yourEditorial
//
//  Created by 塩見陵介 on 2020/10/27.
//

import UIKit
import RealmSwift

class Genre: Object {
    
    @objc dynamic var genreId: String = ""
    @objc dynamic var name:    String = ""
    @objc dynamic var createdAt: Date? = Date()
    @objc dynamic var updatedAt: Date? = Date()
    
    override static func primaryKey() -> String?{
        return "genreId"
    }
    
    func fromDic(_ dic: Dictionary<String, Any?>){
        self.genreId     = dic["genreId"]  as! String
        self.name       = dic["name"]      as! String
        self.createdAt  = dic["createdAt"] as? Date
        self.updatedAt  = dic["updatedAt"] as? Date
    }
}
