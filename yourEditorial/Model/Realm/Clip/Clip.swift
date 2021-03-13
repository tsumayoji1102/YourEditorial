//
//  BookMark.swift
//  yourEditorial
//
//  Created by 塩見陵介 on 2020/10/25.
//

import UIKit
import RealmSwift

class Clip: Object {
    
    @objc dynamic var clipId   : Int    = 0
    @objc dynamic var name     : String = ""
    @objc dynamic var url      : String = ""
    @objc dynamic var newsPaper: String = ""
    @objc dynamic var memo     : String = ""
    @objc dynamic var createdAt: Date?  = Date()
    @objc dynamic var updatedAt: Date?  = Date()
    @objc dynamic var genreId  : Int    = 0
    
    override static  func primaryKey() -> String? {
        return "clipId"
    }
    
    func fromDic(_ dic: Dictionary<String, Any?>){
        self.clipId    = dic["clipId"]    != nil ? dic["clipId"]    as! Int   : 0
        self.name      = dic["name"]      != nil ? dic["name"]      as! String: ""
        self.newsPaper = dic["newsPaper"] != nil ? dic["newsPaper"] as! String: ""
        self.memo      = dic["memo"]      != nil ? dic["memo"]      as! String: ""
        self.url       = dic["url"]       != nil ? dic["url"]       as! String: ""
        self.createdAt = dic["createdAt"] != nil ? dic["createdAt"] as? Date  : Date()
        self.updatedAt = dic["updatedAt"] != nil ? dic["updatedAt"] as? Date  : Date()
        self.genreId   = dic["genreId"]   != nil ? dic["genreId"]   as! Int   : 0
    }
}
