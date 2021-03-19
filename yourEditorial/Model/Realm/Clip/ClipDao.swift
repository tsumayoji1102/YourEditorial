//
//  ClipDao.swift
//  yourEditorial
//
//  Created by 塩見陵介 on 2020/10/25.
//

import UIKit
import RealmSwift

final class ClipDao: Dao {
    
    init(realm: Realm){
        super.init()
        connect(realm: realm)
    }
    
    func create(dic: Dictionary<String, Any?>){
        var newDic = dic
        let clip = Clip()
        newDic["clipId"] = getId()
        clip.fromDic(newDic)
        try! realm.write {
            realm.add(clip)
        }
    }
    
    func getClips(filter: NSPredicate!) ->Array<Clip>{
        
        var results: Results<Clip>
        
        if filter != nil{
            results = realm.objects(Clip.self).filter(filter)
        }else{
            results = realm.objects(Clip.self)
        }
        let clips = Array(results)
        return clips
    }
    
    func update(clipId: String, dic: Dictionary<String, Any?>){
        let clip = getClips(filter: NSPredicate(format: "clipId = %@", argumentArray: [clipId])).first
        try! realm.write {
            clip?.update(dic)
        }
    }
    
    func delete(clip: Clip){
        try! realm.write{
            realm.delete(clip)
        }
    }
}
