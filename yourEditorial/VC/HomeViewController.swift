//
//  HomeViewController.swift
//  yourEditorial
//
//  Created by 塩見陵介 on 2020/10/19.
//

import UIKit
import GoogleMobileAds

final class HomeViewController: UIViewController {
    
    enum Tabs: Int{
        case editorial = 0
        case clips
    }
    
    @IBOutlet weak var homeNavi:  UINavigationItem!
    @IBOutlet weak var homeTab:   UITabBar!
    @IBOutlet weak var childView: UIView!
    
    private var bannerView:  GADBannerView!
    
    // VC
    private var newsPaperEditorialVC: NewsPaperEditorialsViewController!
    private var clipsVC:              ClipsViewController!
    private var selectVC:             SelectViewController!
    private var webVC:                WebViewController!
    
    // selectedTab
    private var selectedTab: Tabs = Tabs.editorial
    
    // sort
    private var editrialSort: Int = 0
    private var clipsSort:    Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        newsPaperEditorialVC
        = self.storyboard?.instantiateViewController(identifier: "newsPaperEditorialViewController")
          as? NewsPaperEditorialsViewController
        
        clipsVC = self.storyboard?.instantiateViewController(identifier: "ClipsViewController") as? ClipsViewController
        
        webVC = self.storyboard?.instantiateViewController(identifier: "webKitViewController") as? WebViewController
        
        selectVC = SelectViewController.getSelectView()
        selectVC.transitioningDelegate = self
        selectVC.delegate = self
        selectVC.reloadSelectView()
        
        // 初期はalarmVC
        self.addChild(newsPaperEditorialVC)
        childView.addSubview(newsPaperEditorialVC.view)
        newsPaperEditorialVC.didMove(toParent: self)
        
        // タブボタン設定
        let newsPaperImage: UIImage? = UIImage(named: "newspaper.png")?.resize(size: CGSize(width: 30, height: 30))
        newsPaperImage?.withRenderingMode(.alwaysTemplate)
        let newsPaperButton = UITabBarItem(
            title: "社説",
            image: newsPaperImage,
            tag: 0)
        
        let clipsImage: UIImage? = UIImage(named: "clips.png")?.resize(size: CGSize(width: 30, height: 30))
        let clipsButton = UITabBarItem(
            title: "クリップ",
            image: clipsImage,
            tag: 1)
        
        homeTab.items = [newsPaperButton, clipsButton]
        homeTab.selectedItem = newsPaperButton
        homeTab.delegate = self
        
        self.navigationItem.title = "社説一覧"
        
        // バナー初期化
        let bannerId = UserDefaults.standard.dictionary(forKey: "admobKey")!["editorial"] as! String
        bannerView = GADBannerView(adSize: kGADAdSizeBanner)
        // TODO: テスト用
        bannerView.adUnitID = bannerId
        bannerView.rootViewController = self
        
        self.view.addSubview(bannerView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        // バナー読み込み
        bannerView.load(GADRequest())
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "setting.png")?.resize(size: CGSize(width: 25, height: 25)), style: .plain, target: self, action: #selector(tapSettingButton(_:)))
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "list.dash")?.resize(size: CGSize(width: 25, height: 25)), style: .plain, target: self, action: #selector(tapFavoriteButton(_:)))
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        let safeArea = self.view.safeAreaInsets
        
        let homeTabHeight = homeTab.frame.height
        childView.frame = CGRect(x: 0, y: safeArea.top, width: self.view.frame.width, height: self.view.frame.height - safeArea.top - homeTabHeight - safeArea.bottom - 50) // バナー分
        newsPaperEditorialVC.view.frame = childView.bounds
        
        // バナーサイズ決定
        bannerView.frame = CGRect(x: 0, y: childView.frame.maxY , width: self.view.frame.width, height: 50)
        
        // ちょっとめんどくさい
        homeTab.frame = CGRect(x: 0, y: bannerView.frame.maxY, width: self.view.frame.width, height:homeTabHeight)
        
        
        
    }
    
// MARK: - method
    
    @objc private func tapFavoriteButton(_ :UIBarButtonItem){
        present(selectVC!, animated: true)
    }
    
    @objc private func tapSettingButton(_: UIBarButtonItem){
        let settingVC = UIStoryboard(name: "SettingView", bundle: nil).instantiateViewController(identifier: "SettingNavigationController")
        settingVC.modalPresentationStyle = .fullScreen
        present(settingVC, animated: true, completion: nil)
    }
    
    
    private func transitionControl(_ to: UIViewController){
        
        // はがす作業
        for vc in self.children{
            vc.willMove(toParent: self)
            vc.view.removeFromSuperview()
            vc.removeFromParent()
        }
        // つける作業
        self.addChild(to)
        childView.addSubview(to.view)
        to.view.frame = childView.bounds
        to.didMove(toParent: self)
    }
    
    private func settingSelectView(){
        
    }
    
    // 外部からおこなう
    func getSite(newsPaperName: String, url: String){
        webVC.newsPaperName = newsPaperName
        webVC.newsPaperUrl = url
        
        self.show(webVC, sender: nil)
    }
}


// MARK: - SelectViewDelegate
extension HomeViewController: SelectViewDelegate{
    func setSelectArray() -> Array<String>? {
        switch selectedTab {
        case Tabs.editorial:
            return ["全て", "お気に入り"]
        case Tabs.clips:
            return ["ジャンル","新聞社","日付"]
        }
    }
    
    func setStartIndex() -> Int? {
        switch selectedTab {
        case Tabs.editorial:
            return editrialSort
        case Tabs.clips:
            return clipsSort
        }
    }
    
    func setClosure(index: Int!){
        switch selectedTab {
        case Tabs.editorial:
            self.newsPaperEditorialVC.changeSortMode(index: index!)
            self.editrialSort = index!
        case Tabs.clips:
            self.clipsVC.changeSortMode(index: index!)
            self.clipsSort = index!
        }
    }
}


// MARK: - UITabBarDelegate

extension HomeViewController: UITabBarDelegate{
    
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        // 分岐
        switch item.tag {
        case Tabs.editorial.rawValue:
            // VCをセット
            self.navigationItem.title = "社説一覧"
            transitionControl(newsPaperEditorialVC)
            selectedTab = Tabs.editorial
            break
            
        case Tabs.clips.rawValue:
            self.navigationItem.title = "クリップ一覧"
            transitionControl(clipsVC)
            selectedTab = Tabs.clips
            break
        default:
            break
        }
        selectVC.reloadSelectView()
    }
}

// UITransitioningDelegate
extension HomeViewController: UIViewControllerTransitioningDelegate{
    
    // 自動的にモーダル表示ができるように設計
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        
        return TransitionController(presentedViewController: presented, presenting: presenting)
    }
}
