//
//  ClipingViewModel.swift
//  yourEditorial
//
//  Created by 塩見陵介 on 2020/11/15.
//

import UIKit

final class ClipingViewModel: NSObject {
    
    var genreDao: GenreDao!
    var clipDao:  ClipDao!
    
    init(genreDao: GenreDao, clipDao: ClipDao){
        super.init()
        self.genreDao = genreDao
        self.clipDao = clipDao
    }
    
    func getGenres() -> Array<Genre>{
        let genres = genreDao.getGenres(filter: nil)
        return genres
    }
    
    func setGenre(dic: Dictionary<String, Any?>){
        genreDao.create(dic: dic)
    }
    
    func setClip(dic: Dictionary<String, Any?>){
        clipDao.create(dic: dic)
    }

}
