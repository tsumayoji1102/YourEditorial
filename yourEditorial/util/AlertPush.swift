
//
//  AlertPush.swift
//  yourEditorial
//
//  Created by 塩見陵介 on 2021/01/01.
//

import UIKit
import RealmSwift
import UserNotifications

class AlertPushNortification {
    
    private static let notificationTitle = "社説をチェック"

    // アラームのローカル通知を設定（単体)
    static func setLocalPush(_ center: UNUserNotificationCenter){
        // プッシュ通知内容
        let content = UNMutableNotificationContent()
        content.title = notificationTitle
        content.body = "5時になりました！多くの新聞社が社説を更新する時間です。チェックしてみましょう！"
        
        let calendar = Calendar(identifier: .gregorian)
        let date = calendar.date(from: DateComponents(hour: 5, minute: 0, second: 0))
        
        // リクエスト作成
        let pushTime = Calendar.current.dateComponents([.hour, .minute, .second], from: date!)
        let trigger = UNCalendarNotificationTrigger(dateMatching: pushTime, repeats: false)
        let identifier = NSUUID().uuidString
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        
        center.add(request, withCompletionHandler: { error in
            if error != nil{
                Log.getLogWithMessage(message: "リクエスト失敗")
            }else{
                Log.getLogWithMessage(message: "リクエスト成功")
            }
        })
    }
    
    // ローカル通知を確認して、必要な際はローカル通知を設定
    static func checkAndPush(){
        
        let center = UNUserNotificationCenter.current()
        center.getPendingNotificationRequests(completionHandler: {requests in
            
            // リクエストのタイトルのみ取得
            let requestTitles = requests.map{ return $0.content.title }
            Log.getLogWithMessage(message: requestTitles)
                
            // あるかチェック
            var isNotificationExisted = false
            for requestTitle in requestTitles{
                if requestTitle == notificationTitle{
                    isNotificationExisted = true
                }
            }
            
            // ないなら送信
            if !isNotificationExisted{
                setLocalPush(center)
            }
        })
    }
    
    //プッシュ通知削除
    static func deleteLocalPush(){
        
        let center = UNUserNotificationCenter.current()
        center.getPendingNotificationRequests(completionHandler: {requests in
            
            // 特定して削除
            for request in requests{
                if(request.content.title == notificationTitle){
                    let identifier = request.identifier
                    center.removePendingNotificationRequests(withIdentifiers: [identifier])
                }
            }
        })
    }
   
}
