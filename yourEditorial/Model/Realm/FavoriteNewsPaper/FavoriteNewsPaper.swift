//
//  FavoriteNewsPaper.swift
//  yourEditorial
//
//  Created by 塩見陵介 on 2020/11/01.
//

import UIKit
import RealmSwift

class FavoriteNewsPaper: Object {
    
    @objc dynamic var favoriteNewsPaperId: String = ""
    @objc dynamic var newsPaperName: String = ""
    
    override static func primaryKey() -> String?{
        return "favoriteNewsPaperId"
    }
    
    func toNewsPaper() -> NewsPaper?{
        return Constraints.newsPapers.filter{
            return $0.name == self.newsPaperName
        }[0]
    }
    
    func fromDic(_ dic: Dictionary<String, Any?>){
        self.newsPaperName = dic["name"] as! String
    }
}
