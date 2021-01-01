//
//  HomeNavigationController.swift
//  yourEditorial
//
//  Created by 塩見陵介 on 2020/11/29.
//

import UIKit

final class HomeNavigationController: UINavigationController {
    
    
    private var statusBarStyle: UIStatusBarStyle = .default

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.changeNavigationColor(isBlue: true)
    }
    
    func changeNavigationColor(isBlue: Bool){
        // バーの色
        self.navigationBar.barTintColor = isBlue ? UIColor.systemBlue : UIColor.systemGroupedBackground

         // navigationItemの色
        self.navigationBar.tintColor = isBlue ? UIColor.white : UIColor.systemBlue

        // タイトルの色
        self.navigationBar.titleTextAttributes = [
                    .foregroundColor: isBlue ? UIColor.white : UIColor.black
                ]
        setStatusBarStyle(style: isBlue ? .lightContent: .darkContent)
    }
    
    private func setStatusBarStyle(style: UIStatusBarStyle) {
        statusBarStyle = style
        self.setNeedsStatusBarAppearanceUpdate()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return statusBarStyle
    }
}
