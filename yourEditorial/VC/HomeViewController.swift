//
//  HomeViewController.swift
//  yourEditorial
//
//  Created by 塩見陵介 on 2020/10/19.
//

import UIKit

protocol SortDelegate{
    func changeSortMode(index: Int)
}

final class HomeViewController: UIViewController {
    
    enum Tabs: Int{
        case editorial = 0
        case clips
    }
    
    @IBOutlet weak var homeNavi:  UINavigationItem!
    @IBOutlet weak var homeTab:   UITabBar!
    @IBOutlet weak var childView: UIView!
    
    
    // VC
    private var newsPaperEditorialVC: NewsPaperEditorialsViewController!
    private var clipsVC:              ClipsViewController!
    private var selectVC:             SelectViewController!
    
    // selectedTab
    private var selectedTab: Tabs = Tabs.editorial

    override func viewDidLoad() {
        super.viewDidLoad()
        
        newsPaperEditorialVC
        = self.storyboard?.instantiateViewController(identifier: "newsPaperEditorialViewController")
          as? NewsPaperEditorialsViewController
        
        clipsVC = self.storyboard?.instantiateViewController(identifier: "ClipsViewController") as? ClipsViewController
        
        selectVC = self.storyboard?.instantiateViewController(identifier: "SelectViewController") as? SelectViewController
        selectVC.modalPresentationStyle = .custom
        selectVC.transitioningDelegate = self
        
        settingSelectView(selectedTab: selectedTab)
        
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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "list.dash")?.resize(size: CGSize(width: 25, height: 25)), style: .plain, target: self, action: #selector(tapFavoriteButton(_:)))
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        let safeArea = self.view.safeAreaInsets
        
        let homeTabHeight = homeTab.frame.height
        childView.frame = CGRect(x: 0, y: safeArea.top, width: self.view.frame.width, height: self.view.frame.height - safeArea.top - homeTabHeight - safeArea.bottom)
        newsPaperEditorialVC.view.frame = childView.bounds
        
        // ちょっとめんどくさい
        homeTab.frame = CGRect(x: 0, y: childView.frame.maxY, width: self.view.frame.width, height: self.view.frame.height - childView.frame.maxY)
        
    }
    
// MARK: - method
    
    @objc private func tapFavoriteButton(_ :UIBarButtonItem){
        present(selectVC!, animated: true)
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
    
    private func settingSelectView(selectedTab: Tabs){
        if selectedTab == Tabs.editorial {
            selectVC.list = ["全て", "お気に入り"]
            selectVC.closure = { index in
                self.newsPaperEditorialVC.changeSortMode(index: index!)
            }
        // TODO: 設定
        }else if selectedTab == Tabs.clips {
            selectVC.list = ["日付", "新聞社"]
            selectVC.closure = { index in
                
            }
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
            settingSelectView(selectedTab: Tabs.editorial)
            break
            
        case Tabs.clips.rawValue:
            self.navigationItem.title = "クリップ一覧"
            transitionControl(clipsVC)
            // selectViewController設定
            settingSelectView(selectedTab: Tabs.clips)
            break
        default:
            break
        }
    }
}

// UITransitioningDelegate
extension HomeViewController: UIViewControllerTransitioningDelegate{
    
    // 自動的にモーダル表示ができるように設計
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        
        return TransitionController(presentedViewController: presented, presenting: presenting)
    }
}
