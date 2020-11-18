//
//  ClipingViewModel.swift
//  yourEditorial
//
//  Created by 塩見陵介 on 2020/11/15.
//

import UIKit

class ClipingViewModel: NSObject {
    
    var genreDao: GenreDao!
    
    init(genreDao: GenreDao){
        super.init()
        self.genreDao = genreDao
    }
    
    func getGenres() -> Array<Genre>{
        let genres = genreDao.getGenres(filter: nil)
        return genres
    }
    
    
    func setGenre(dic: Dictionary<String, Any?>){
        genreDao.create(dic: dic)
    }

}
