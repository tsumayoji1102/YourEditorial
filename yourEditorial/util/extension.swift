//
//  Extension.swift
//  usefulAlerm
//
//  Created by 塩見陵介 on 2020/05/27.
//  Copyright © 2020 つまようじ職人. All rights reserved.
//

import UIKit

extension UIImage{
    
    func resize(size _size: CGSize) -> UIImage? {
        let widthRatio = _size.width / size.width
        let heightRatio = _size.height / size.height
        let ratio = widthRatio < heightRatio ? widthRatio : heightRatio

        let resizedSize = CGSize(width: size.width * ratio, height: size.height * ratio)

        UIGraphicsBeginImageContextWithOptions(resizedSize, false, 0.0) // 変更
        draw(in: CGRect(origin: .zero, size: resizedSize))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return resizedImage
    }
}

extension UIColor{
    
    static func getThemeColor() ->UIColor{
        
        let color = UserDefaults.standard.string(forKey: "themeColor")
        
        switch color {
        case "ブルー":
            return UIColor.systemBlue
        case "レッド":
            return UIColor.systemRed
        case "イエロー":
            return UIColor.systemYellow
        case "グリーン":
            return UIColor.systemGreen
        case "パープル":
            return UIColor.systemPurple
        case "ブラウン":
            return UIColor.brown
        case "オレンジ":
            return UIColor.systemOrange
        case "ピンク":
            return UIColor.systemPink
        default:
            return UIColor.systemBlue
        }
    }
    
    // お手製ダークモード
    static func getDarkModeColor(area: String) ->UIColor!{
        
        var returnColor = UIColor()
        let darkMode = UserDefaults.standard.bool(forKey: "darkMode")
        
        // ダークモードが有効なら
        if(darkMode){
            switch area {
            case "cell":
                returnColor = UIColor(red: 28/255, green: 28/255, blue: 30/255, alpha: 1)
                break
            case "cellLine":
                returnColor = UIColor(red: 68/255, green: 68/255, blue: 68/255, alpha: 1)
                break
            case "fontColor":
                returnColor = UIColor.white
                break
            case "alarmView":
                returnColor = UIColor.black
                break
            case "settingView":
                returnColor = UIColor.black
                break
            case "tabBarTint":
                returnColor = UIColor(red: 40/255, green: 39/255, blue: 44/255, alpha: 0.5)
                break
            case "tabBarItemTint":
                returnColor = UIColor.lightGray
                break
            default:
                break
            }
        }else{
            switch area {
            case "cell":
                returnColor = UIColor.white
                break
            case "cellLine":
                returnColor = UIColor.separator
                break
            case "fontColor":
                returnColor = UIColor.black
                break
            case "alarmView":
                returnColor = UIColor.white
                break
            case "settingView":
                returnColor = UIColor.systemGroupedBackground
                break
            case "tabBarTint":
                returnColor = UIColor.systemGray5
                break
            case "tabBarItemTint":
                returnColor = UIColor.lightGray
                break
            default:
                break
            }
        }
        
        return returnColor
    }
}


// MARK: - UITextField
extension UITextField {
    
    /*下線を追加する
     *
     * @param height: line height
     * @param color:  line color
     *
     */
    func addBottomBorder(height: CGFloat, color: UIColor){
        
        let border = CALayer()
        
        border.frame = CGRect(x: 0, y: self.frame.height - height, width: self.frame.width, height:height)
        border.backgroundColor = color.cgColor
        self.layer.addSublayer(border)
        
    }
    
   
}
