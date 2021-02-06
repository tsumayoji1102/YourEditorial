//
//  AboutThisAppViewController.swift
//  yourEditorial
//
//  Created by 塩見陵介 on 2020/12/12.
//

import UIKit
import WebKit
import PKHUD

final class AboutThisAppViewController: UIViewController {
    
    private var label: UILabel!
    private var aboutView: WKWebView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "このアプリについて"
        
        aboutView = WKWebView()
        self.view.addSubview(aboutView)
        
        label = UILabel()
        label.text = "まだ未完成！\nもう少し待ってね！"
        label.numberOfLines = 2
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textColor = UIColor.black
        label.textAlignment = .center
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        HUD.flash(.progress, delay: 0.0)
        loadUrl()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        label.frame = CGRect(x: self.view.frame.width / 2 - 100, y: self.view.frame.height / 2 - 50, width: 200, height: 100)
        //self.view.addSubview(label)
        
        aboutView.frame = self.view.bounds
    }
    
    private func loadUrl(){
        let url: URL! = URL(string: "https://youreditorial-ba691.web.app/")
        let urlRequest: URLRequest! = URLRequest(url: url!)
        aboutView.load(urlRequest)
    }
}

extension AboutThisAppViewController: WKNavigationDelegate{
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        HUD.hide()
    }
}
