//
//  GenreViewModel.swift
//  yourEditorial
//
//  Created by 塩見陵介 on 2020/12/09.
//

import UIKit
import RealmSwift

final class GenreViewModel: NSObject {
    
    private var genreDao: GenreDao!
    private var clipDao:  ClipDao!

    init(genreDao: GenreDao, clipDao: ClipDao){
        super.init()
        self.genreDao = genreDao
        self.clipDao = clipDao
    }
    
    func getGenres() -> Array<Genre>{
        return genreDao.getGenres(filter: nil)
    }
    
    func addGenre(dic: Dictionary<String, Any?>){
        genreDao.create(dic: dic)
    }
    
    func updateGenreName(genreId: Int, name: String){
        let dic = ["name": name, "updatedAt": Date()] as [String : Any?]
        genreDao.update(genreId: genreId, dic: dic)
    }
    
    func deleteGenre(genre: Genre){
        let clips = clipDao.getClips(filter: NSPredicate(format: "genreId = %@", argumentArray: [genre.genreId]))
        for clip in clips{
            clipDao.delete(clip: clip)
        }
        genreDao.delete(genre: genre)
    }
}
