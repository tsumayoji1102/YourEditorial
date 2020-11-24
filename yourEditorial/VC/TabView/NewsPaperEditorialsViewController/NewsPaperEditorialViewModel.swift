//
//  NewsPaperEditorialViewModel.swift
//  yourEditorial
//
//  Created by 塩見陵介 on 2020/11/01.
//

import UIKit
import RealmSwift

final class NewsPaperEditorialViewModel: NSObject {
    
    private var favoriteNewsPaperDao: FavoriteNewsPaperDao!
    
    init(favoriteNewsPaperDao: FavoriteNewsPaperDao){
        self.favoriteNewsPaperDao = favoriteNewsPaperDao
    }
    
    func setFavorite(newspaper: NewsPaper) -> Bool{
        let favoriteNewsPaper: FavoriteNewsPaper! = favoriteNewsPaperDao.getFavoriteNewsPapers(filter: NSPredicate(format: "newsPaperName = %@", argumentArray: [newspaper.name!])).first
        if favoriteNewsPaper == nil{
            favoriteNewsPaperDao.create(dic: newspaper.toDic())
            return true
        }else{
            return false
        }
    }
    
    func getFavoriteNewsPapers() -> Array<NewsPaper>{
        let favoriteNewsPapers: Array<FavoriteNewsPaper> = favoriteNewsPaperDao.getFavoriteNewsPapers(filter: nil)
        return favoriteNewsPapers.map{ return $0.toNewsPaper()! }
    }
    
    func deleteFavoriteNewsPaper(newspaper: NewsPaper){
        favoriteNewsPaperDao.delete(favoriteNewsPaperName: newspaper.name)
    }
}
