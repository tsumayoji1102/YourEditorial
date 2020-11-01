//
//  ClipsViewModel.swift
//  yourEditorial
//
//  Created by 塩見陵介 on 2020/10/26.
//

import UIKit
import RealmSwift

final class ClipsViewModel: NSObject {
    
    final private var clipDao: ClipDao!
    
    init(clipDao: ClipDao){
        super.init()
        self.clipDao = clipDao
    }
    
    func getClips() -> Array<Clip>{
        let clips: Array<Clip> = clipDao.getClips(filter: nil)
        return clips
    }
}
