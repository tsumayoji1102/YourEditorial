//
//  WebViewController.swift
//  yourEditorial
//
//  Created by 塩見陵介 on 2020/10/20.
//

import UIKit
import WebKit
import PKHUD

final class WebViewController: UIViewController {
    
    private var webKitView: WKWebView!
    private var webViewModel: WebViewModel!
    private var appDelegate: AppDelegate!
    
    var newsPaper: NewsPaper!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        appDelegate = UIApplication.shared.delegate as? AppDelegate
        let clipDao: ClipDao = appDelegate.daoFactory.getDao(daoRoute: DaoRoutes.clip) as! ClipDao
        webViewModel = WebViewModel(clipDao: clipDao)
        
        webKitView = WKWebView();
        webKitView.navigationDelegate = self
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "clip.png")?.resize(size: CGSize(width: 25, height: 25)), style: .plain, target: self, action: #selector(setClip(_:)))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        HUD.flash(.progress, delay: 0.0)
        self.navigationItem.title = newsPaper.name
    
        self.view.addSubview(webKitView)
        loadUrl()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        let safeArea = self.view.safeAreaInsets
        webKitView.frame = CGRect(x: 0, y: safeArea.top, width: self.view.frame.width, height: self.view.frame.height - safeArea.top)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
    }
    
    func loadUrl(){
        let url: URL! = URL(string: newsPaper.url)
        let urlRequest: URLRequest! = URLRequest(url: url!)
        webKitView.load(urlRequest)
    }
    
    @objc func setClip(_: UIBarButtonItem){
        
    }
}



extension WebViewController: WKNavigationDelegate{
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        let alert = UIAlertController(title: "エラー", message: "読み込みに失敗しました。", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            self.dismiss(animated: true, completion: nil)
        }))
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("読み込み完了")
    }
    
    func webViewWebContentProcessDidTerminate(_ webView: WKWebView) {
        HUD.hide()
    }
}
