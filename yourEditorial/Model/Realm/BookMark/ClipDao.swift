//
//  ClipDao.swift
//  yourEditorial
//
//  Created by 塩見陵介 on 2020/10/25.
//

import UIKit
import RealmSwift

final class ClipDao: NSObject, Dao {
    
    var realm: Realm!
    
    init(realm: Realm){
        super.init()
        connect(realm: realm)
    }
    
    func connect(realm: Realm) {
        self.realm = realm
    }
    
    // 採番
    func getClipNo() -> Int{
        
        let result = realm.objects(Clip.self).sorted(byKeyPath: "clipId", ascending: false).first
        
        if (result == nil){
            return 0
        }else{
            return result!.clipId + 1
        }
    }
    
    func create(dic: Dictionary<String, Any?>){
        var newDic = dic
        let clip = Clip()
        newDic["clipId"] = getClipNo()
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
            clip?.fromDic(dic)
        }
    }
}
