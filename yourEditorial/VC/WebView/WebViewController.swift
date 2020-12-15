//
//  WebViewController.swift
//  yourEditorial
//
//  Created by 塩見陵介 on 2020/10/20.
//

import UIKit
import PKHUD
import WebKit
import RealmSwift
import GoogleMobileAds

final class WebViewController: UIViewController{
    
    enum TabBarItems: Int{
        case returnUrl = 0
        case proceedUrl
        case share
        case safari
    }
    
    // view parts
    private var webKitView:    WKWebView!
    private var progressView:  UIProgressView!
    private var bannerView:    GADBannerView!
    
    // about tabBar
    private var tabBar:        UITabBar!
    private var returnButton:  UIButton!
    private var forwardButton: UIButton!
    private var safariButton:  UIButton!
    private var shareButton:   UIButton!
    
    // object
    private var clipingVC:     ClipingViewController!
    private var appDelegate:   AppDelegate!
    private var viewModel:     WebViewModel!
    var newsPaperName:         String!
    var newsPaperUrl:          String!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        appDelegate = UIApplication.shared.delegate as? AppDelegate
        let clipDao: ClipDao = appDelegate.daoFactory.getDao(daoRoute: DaoRoutes.clip) as! ClipDao
        viewModel = WebViewModel(clipDao: clipDao)
        
        clipingVC = self.storyboard?.instantiateViewController(identifier: "ClipingViewController") as? ClipingViewController
        clipingVC.modalPresentationStyle = .custom
        clipingVC.transitioningDelegate = self
        
        webKitView = WKWebView();
        
        progressView = UIProgressView(progressViewStyle: .bar)
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "clip.png")?.resize(size: CGSize(width: 25, height: 25)), style: .plain, target: self, action: #selector(setClip(_:)))
        
        // バナー初期化
        let bannerId = UserDefaults.standard.dictionary(forKey: "admobKey")!["web"] as! String
        bannerView = GADBannerView(adSize: kGADAdSizeBanner)
        // TODO: テスト用
        bannerView.adUnitID = bannerId
        bannerView.rootViewController = self
        
        returnButton = UIButton()
        let returnImage = UIImage(systemName: "lessthan")?.resize(size: CGSize(width: 25, height: 25))!.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        returnButton.setImage(returnImage, for: .normal)
        returnButton.tintColor = UIColor.systemBlue
        returnButton.tag = TabBarItems.returnUrl.rawValue
        returnButton.addTarget(self, action: #selector(tapButton(button:)), for: .touchDown)
        
        forwardButton = UIButton()
        let forwardImage = UIImage(systemName: "greaterthan")?.resize(size: CGSize(width: 25, height: 25))!.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        forwardButton.setImage(forwardImage, for: .normal)
        forwardButton.tintColor = UIColor.systemBlue
        forwardButton.tag = TabBarItems.proceedUrl.rawValue
        forwardButton.addTarget(self, action: #selector(tapButton(button:)), for: .touchDown)
        
        shareButton = UIButton()
        let shareImage = UIImage(systemName: "paperplane.fill")?.resize(size: CGSize(width: 25, height: 25))!.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        shareButton.setImage(shareImage, for: .normal)
        shareButton.tintColor = UIColor.systemBlue
        shareButton.tag = TabBarItems.share.rawValue
        shareButton.addTarget(self, action: #selector(tapButton(button:)), for: .touchDown)
        
        safariButton = UIButton()
        let safari = UIImage(systemName: "safari")?.resize(size: CGSize(width: 25, height: 25))!.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        safariButton.setImage(safari, for: .normal)
        safariButton.tintColor = UIColor.systemBlue
        safariButton.tag = TabBarItems.safari.rawValue
        safariButton.addTarget(self, action: #selector(tapButton(button:)), for: .touchDown)
        
        tabBar = UITabBar()
        tabBar.tintColor = UIColor.systemGray
        tabBar.addSubview(returnButton)
        tabBar.addSubview(forwardButton)
        tabBar.addSubview(shareButton)
        tabBar.addSubview(safariButton)
        self.view.addSubview(tabBar)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        // バナー読み込み
        bannerView.load(GADRequest())
        
        self.view.addSubview(webKitView)
        self.view.addSubview(progressView)
        webKitView.navigationDelegate = self
        webKitView.addObserver(self, forKeyPath: "isLoading", options: .new, context: nil)
        webKitView.addObserver(self, forKeyPath: "estimatedProgress", options: .new, context: nil)
        
        progressView.alpha = 1.0
        HUD.flash(.progress, delay: 0.0)
        self.navigationItem.title = newsPaperName
    
        self.returnButton.isEnabled = self.webKitView.canGoBack
        self.forwardButton.isEnabled = self.webKitView.canGoForward
        loadUrl()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        let safeArea = self.view.safeAreaInsets
        webKitView.frame = CGRect(x: 0, y: safeArea.top, width: self.view.frame.width, height: self.view.frame.height - safeArea.top - 40 - safeArea.bottom)
        progressView.frame = CGRect(x: 0, y: safeArea.top, width: self.view.frame.width, height: 0.0)
        
        // バナーサイズ決定
        bannerView.frame = CGRect(x: 0, y: tabBar.frame.minY - 50, width: self.view.frame.width, height: 50)
        self.view.addSubview(bannerView)
        
        tabBar.frame = CGRect(x: 0, y: self.view.frame.height - 40 - safeArea.bottom, width: self.view.frame.width, height: 40 + safeArea.bottom)
        
        let tabBarHeight: CGFloat = 40 + safeArea.bottom
        let tabBarButtonWidth: CGFloat = tabBar.frame.width / 4
        
        returnButton.frame = CGRect(x: 0, y: 10, width: tabBarButtonWidth, height: tabBarHeight)
        returnButton.contentVerticalAlignment = .top
        forwardButton.frame = CGRect(x: tabBarButtonWidth, y: 10, width: tabBarButtonWidth, height: tabBarHeight)
        forwardButton.contentVerticalAlignment = .top
        shareButton.frame = CGRect(x: tabBarButtonWidth * 2, y: 10, width: tabBarButtonWidth, height: tabBarHeight)
        shareButton.contentVerticalAlignment = .top
        safariButton.frame = CGRect(x: tabBarButtonWidth * 3, y: 10, width: tabBarButtonWidth, height: tabBarHeight)
        safariButton.contentVerticalAlignment = .top
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        HUD.hide()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        self.webKitView.removeObserver(self, forKeyPath: "estimatedProgress")
        self.webKitView.removeObserver(self, forKeyPath: "isLoading")
        progressView.removeFromSuperview()
        webKitView.removeFromSuperview()
        webKitView = WKWebView()
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
    
    @objc func tapButton(button : UIButton){
        switch button.tag {
        case TabBarItems.returnUrl.rawValue:
            if webKitView.canGoBack{
                webKitView.goBack()
                DispatchQueue.main.async {
                    self.returnButton.isEnabled = self.webKitView.canGoBack
                }
            }
            break
        case TabBarItems.proceedUrl.rawValue:
            if webKitView.canGoForward{
                webKitView.goForward()
                DispatchQueue.main.async {
                    self.forwardButton.isEnabled = self.webKitView.canGoForward
                }
            }
        case TabBarItems.safari.rawValue:
            let url = self.webKitView.url
            if UIApplication.shared.canOpenURL(url!){
                UIApplication.shared.open(url!)
            }
            break
        case TabBarItems.share.rawValue:
            webKitView.evaluateJavaScript("document.title", completionHandler: {
                value, error in
                var clipDic: Dictionary<String, Any?> = [:]
                clipDic["name"] = value as! String
                clipDic["url"] = self.webKitView.url?.absoluteString
                clipDic["newsPaper"] = self.newsPaperName
                let alertVC = UIActivityViewController(activityItems: ["【\(clipDic["newsPaper"] as! String)】 \(clipDic["name"] as! String) #社説クリップ \n\(clipDic["url"] as! String)"], applicationActivities: nil)
                self.present(alertVC, animated: true, completion: nil)
            })
            break
        default:
            break
        }
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        let alert = UIAlertController(title: "エラー", message: "読み込みに失敗しました。", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            self.dismiss(animated: true, completion: nil)
        }))
    }
    
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        returnButton.isEnabled  = webView.canGoBack
        forwardButton.isEnabled = webView.canGoForward
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        webKitView.isHidden = false
        print("読み込み完了")
    }
    
    /*
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if navigationAction.navigationType == .linkActivated  {
            if let url = navigationAction.request.url,
                let host = url.host, !host.hasPrefix("www.google.com"),
                UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url)
                print(url)
                print("Redirected to browser. No need to open it locally")
                decisionHandler(.cancel)
            } else {
                print("Open it locally")
                decisionHandler(.allow)
            }
        } else {
            print("not a user click")
            decisionHandler(.allow)
        }
    }
 */
}

// MARK: - UITransitioningDelegate
extension WebViewController: UIViewControllerTransitioningDelegate{
    
    // 自動的にモーダル表示ができるように設計
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        
        return TransitionController(presentedViewController: presented, presenting: presenting)
    }
}
