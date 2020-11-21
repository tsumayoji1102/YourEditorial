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
    final private var genreDao: GenreDao!
    
    init(clipDao: ClipDao, genreDao: GenreDao){
        super.init()
        self.clipDao = clipDao
        self.genreDao = genreDao
    }
    
    func getClips() -> Array<Clip>{
        let clips: Array<Clip> = clipDao.getClips(filter: nil)
        return clips
    }
    
    func getGenres() -> Array<Genre>{
        return genreDao.getGenres(filter: nil)
    }
    
    func deleteClip(clip: Clip){
        clipDao.delete(clip: clip)
    }
}
