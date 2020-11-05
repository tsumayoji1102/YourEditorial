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

    final var name:  String!
    final var image: String!
    final var url:   String!
    final var group: groups!
    
    init(name: String, url: String, image: String, group: groups){
        super.init()
        self.name = name
        self.url = url
        self.image = image
        self.group = group
    }
    
    func toDic() -> Dictionary<String, Any?>{
        let dic: Dictionary<String, Any?> = [
            "name":  self.name,
            "url":   self.url,
            "image": self.image,
            "group": self.group
        ]
        return dic
    }
}
