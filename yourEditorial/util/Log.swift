//
//  Log.swift
//  yourEditorial
//
//  Created by 塩見陵介 on 2020/10/26.
//

import UIKit

//
//  GetLog.swift
//  usefulAlerm
//
//  Created by 塩見陵介 on 2020/02/11.
//  Copyright © 2020 つまようじ職人. All rights reserved.
//

import UIKit

final class Log: NSObject {
    
    // とりあえずログ
    static func getLog(
        function: String = #function,
        file:     String = #file,
        line:     Int    = #line){
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy年MM月dd日 HH時mm分ss秒"
        
        let now = dateFormatter.string(from: Date())
        
        Swift.print("\(file): \(function) (\(line)行目) \(now) ")
    }
    
    
    // メッセージありのログ
    static func getLogWithMessage(
        message:  Any,
        function: String = #function,
        file:     String = #file,
        line:     Int    = #line){
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy年MM月dd日 HH時mm分ss秒"
        
        let now = dateFormatter.string(from: Date())
        
        Swift.print("\(file): \(function) (\(line)行目) \(now) \(message)")
    }

}
