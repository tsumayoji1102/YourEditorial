//
//  Genre.swift
//  yourEditorial
//
//  Created by 塩見陵介 on 2020/10/27.
//

import UIKit
import RealmSwift

class Genre: Object {
    
    @objc dynamic var genreId: Int    = 0
    @objc dynamic var name:    String = ""
    @objc dynamic var createdAt: Date? = Date()
    @objc dynamic var updatedAt: Date? = Date()
    
    override static func primaryKey() -> String?{
        return "genreId"
    }
    
    func fromDic(_ dic: Dictionary<String, Any?>){
        self.name       = dic["name"]      != nil ? dic["name"]      as! String : self.name
        self.createdAt  = dic["createdAt"] != nil ? dic["createdAt"] as? Date : self.createdAt
        self.updatedAt  = dic["updatedAt"] != nil ? dic["updatedAt"] as? Date : self.updatedAt
    }
}
