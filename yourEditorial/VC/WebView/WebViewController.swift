//
//  WebViewController.swift
//  yourEditorial
//
//  Created by 塩見陵介 on 2020/10/20.
//

import UIKit
import WebKit
import RealmSwift
import PKHUD

final class WebViewController: UIViewController {
    
    // view parts
    private var webKitView:   WKWebView!
    private var clipingVC:    ClipingViewController!
    private var viewModel:    WebViewModel!
    private var appDelegate:  AppDelegate!
    
    var newsPaper: NewsPaper!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        appDelegate = UIApplication.shared.delegate as? AppDelegate
        let clipDao: ClipDao = appDelegate.daoFactory.getDao(daoRoute: DaoRoutes.clip) as! ClipDao
        viewModel = WebViewModel(clipDao: clipDao)
        
        clipingVC = self.storyboard?.instantiateViewController(identifier: "ClipingViewController") as? ClipingViewController
        
        webKitView = WKWebView();
        webKitView.navigationDelegate = self
        self.view.addSubview(webKitView)
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "clip.png")?.resize(size: CGSize(width: 25, height: 25)), style: .plain, target: self, action: #selector(setClip(_:)))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        HUD.flash(.progress, delay: 0.0)
        self.navigationItem.title = newsPaper.name
    
        loadUrl()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        let safeArea = self.view.safeAreaInsets
        webKitView.frame = CGRect(x: 0, y: safeArea.top, width: self.view.frame.width, height: self.view.frame.height - safeArea.top)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        HUD.hide()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        webKitView.isHidden = true
        super.viewDidDisappear(true)
        
    }
    
    private func loadUrl(){
        let url: URL! = URL(string: newsPaper.url)
        let urlRequest: URLRequest! = URLRequest(url: url!)
        webKitView.load(urlRequest)
    }
    
    @objc func setClip(_: UIBarButtonItem){
        webKitView.evaluateJavaScript("document.title", completionHandler: {
            value, error in
            let clip: Clip = Clip()
            let date: Date = Date()
            clip.name = value as! String
            clip.url = try! String(contentsOf: self.webKitView.url!)
            clip.newsPaper = self.newsPaper.name
            clip.createdAt = date
            clip.updatedAt = date
            self.clipingVC?.clip = clip
            self.present(self.clipingVC, animated: true, completion: nil)
        })
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
        webKitView.isHidden = false
        print("読み込み完了")
        
    }
    
    func webViewWebContentProcessDidTerminate(_ webView: WKWebView) {
        
    }
}
