//
//  WebViewModel.swift
//  yourEditorial
//
//  Created by 塩見陵介 on 2020/10/27.
//

import UIKit
import RealmSwift

final class WebViewModel: NSObject {
    
    final private var clipDao: ClipDao!
    
    init(clipDao: ClipDao) {
        self.clipDao = clipDao
    }

    func createClip(name: String, url: String, genreId: String){
        let dic: Dictionary<String, Any?> = [
            "name": name,
            "url": url,
            "createdAt": Date(),
            "updatedAt": Date(),
            "genreId": genreId
        ]
        clipDao.create(dic: dic)
    }
    
    func updateMemo(clipId: String, memo: String){
        clipDao.update(clipId: clipId, dic: ["memo": memo])
    }
}
