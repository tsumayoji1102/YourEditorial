//
//  NewsPaper.swift
//  yourEditorial
//
//  Created by 塩見陵介 on 2020/10/27.
//

import UIKit

class NewsPaper: NSObject {
    
    enum groups: Int{
        case nationWide = 0
        case block
        case local
        case groupsCount
    }

    var name: String!
    var url:  String!
    var group: groups!
    
    init(name: String, url: String, group: groups){
        self.name = name
        self.url = url
        self.group = group
    }
}
