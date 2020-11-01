//
//  NewsPaperEditorialViewModel.swift
//  yourEditorial
//
//  Created by 塩見陵介 on 2020/11/01.
//

import UIKit
import RealmSwift

class NewsPaperEditorialViewModel: NSObject {
    
    private var favoriteNewsPaperDao: FavoriteNewsPaperDao!
    
    init(favoriteNewsPaperDao: FavoriteNewsPaperDao){
        self.favoriteNewsPaperDao = favoriteNewsPaperDao
    }
    
    func getFavoriteNewsPapers() -> Array<NewsPaper>{
        let favoriteNewsPapers: Array<FavoriteNewsPaper> = favoriteNewsPaperDao.getFavoriteNewsPapers(filter: nil)
        return favoriteNewsPapers.map{ return $0.toNewsPaper()! }
    }
}
