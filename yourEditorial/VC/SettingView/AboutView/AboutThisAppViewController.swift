//
//  AboutThisAppViewController.swift
//  yourEditorial
//
//  Created by 塩見陵介 on 2020/12/12.
//

import UIKit

final class AboutThisAppViewController: UIViewController {
    
    private var label: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "このアプリについて"
        
        label = UILabel()
        label.text = "まだ未完成！\nもう少し待ってね！"
        label.numberOfLines = 2
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textColor = UIColor.black
        label.textAlignment = .center
        
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        label.frame = CGRect(x: self.view.frame.width / 2 - 100, y: self.view.frame.height / 2 - 50, width: 200, height: 100)
        self.view.addSubview(label)
    }
}
