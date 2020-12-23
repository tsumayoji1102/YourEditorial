//
//  HomeNavigationController.swift
//  yourEditorial
//
//  Created by 塩見陵介 on 2020/11/29.
//

import UIKit

final class HomeNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // バーの色
        self.navigationBar.barTintColor = UIColor.systemBlue

         // navigationItemの色
        self.navigationBar.tintColor = UIColor.white

        // タイトルの色
        self.navigationBar.titleTextAttributes = [
                    .foregroundColor: UIColor.white
                ]
    }
}
