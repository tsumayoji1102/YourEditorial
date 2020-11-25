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
import GoogleMobileAds

final class WebViewController: UIViewController {
    
    // view parts
    private var webKitView:   WKWebView!
    private var progressView: UIProgressView!
    private var clipingVC:    ClipingViewController!
    private var viewModel:    WebViewModel!
    private var appDelegate:  AppDelegate!
    private var bannerView:   GADBannerView!
    
    var newsPaperName: String!
    var newsPaperUrl:  String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        appDelegate = UIApplication.shared.delegate as? AppDelegate
        let clipDao: ClipDao = appDelegate.daoFactory.getDao(daoRoute: DaoRoutes.clip) as! ClipDao
        viewModel = WebViewModel(clipDao: clipDao)
        
        clipingVC = self.storyboard?.instantiateViewController(identifier: "ClipingViewController") as? ClipingViewController
        clipingVC.modalPresentationStyle = .custom
        clipingVC.transitioningDelegate = self
        
        webKitView = WKWebView();
        webKitView.navigationDelegate = self
        self.view.addSubview(webKitView)
        
        progressView = UIProgressView(progressViewStyle: .bar)
        self.view.addSubview(progressView)
        
        webKitView.addObserver(self, forKeyPath: "isLoading", options: .new, context: nil)
        webKitView.addObserver(self, forKeyPath: "estimatedProgress", options: .new, context: nil)
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "clip.png")?.resize(size: CGSize(width: 25, height: 25)), style: .plain, target: self, action: #selector(setClip(_:)))
        
        // バナー初期化
        let bannerId = UserDefaults.standard.dictionary(forKey: "admobKey")!["test"] as! String
        bannerView = GADBannerView(adSize: kGADAdSizeBanner)
        // TODO: テスト用
        bannerView.adUnitID = bannerId
        bannerView.rootViewController = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        // バナー読み込み
        bannerView.load(GADRequest())
        
        progressView.alpha = 1.0
        HUD.flash(.progress, delay: 0.0)
        self.navigationItem.title = newsPaperName
    
        loadUrl()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        let safeArea = self.view.safeAreaInsets
        webKitView.frame = CGRect(x: 0, y: safeArea.top, width: self.view.frame.width, height: self.view.frame.height - safeArea.top - 50)
        progressView.frame = CGRect(x: 0, y: safeArea.top, width: self.view.frame.width, height: 0.0)
        // バナーサイズ決定
        bannerView.frame = CGRect(x: 0, y: self.view.frame.height - 50, width: self.view.frame.width, height: 50)
        self.view.addSubview(bannerView)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        HUD.hide()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        webKitView.isHidden = true
        super.viewDidDisappear(true)
        
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        switch keyPath {
        case "isLoading":
            if(webKitView.isLoading){
                self.progressView.setProgress(0.1, animated: true)
            }else{
                progressView.isHidden = true
                /*
                self.progressView.setProgress(0.0, animated: false)
                self.progressView.setProgress(1.0, animated: false)
                */
            }
            break
        case "estimatedProgress":
            progressView.setProgress(Float(webKitView.estimatedProgress), animated: true)
            if (self.webKitView.estimatedProgress >= 1.0) {
                UIView.animate(withDuration: 0.2,
                               delay: 0.2,
                               options: [.curveEaseOut],
                               animations: { [weak self] in
                                self?.progressView.alpha = 0.0
                    }, completion: {
                        (finished : Bool) in
                        self.progressView.setProgress(0.0, animated: false)
                })
            }
            break
        default:
            break
        }
    }
    
    deinit {
        self.webKitView.removeObserver(self, forKeyPath: "estimatedProgress")
        self.webKitView.removeObserver(self, forKeyPath: "isLoading")
    }
    
    private func loadUrl(){
        let url: URL! = URL(string: newsPaperUrl)
        let urlRequest: URLRequest! = URLRequest(url: url!)
        webKitView.load(urlRequest)
    }
    
    @objc func setClip(_: UIBarButtonItem){
        webKitView.evaluateJavaScript("document.title", completionHandler: {
            value, error in
            var clipDic: Dictionary<String, Any?> = [:]
            let date: Date = Date()
            clipDic["name"] = value as! String
            clipDic["url"] = self.webKitView.url?.absoluteString
            clipDic["newsPaper"] = self.newsPaperName
            clipDic["createdAt"] = date
            clipDic["updatedAt"] = date
            self.clipingVC?.clipDic = clipDic
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

// MARK: - UITransitioningDelegate
extension WebViewController: UIViewControllerTransitioningDelegate{
    
    // 自動的にモーダル表示ができるように設計
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        
        return TransitionController(presentedViewController: presented, presenting: presenting)
    }
}
