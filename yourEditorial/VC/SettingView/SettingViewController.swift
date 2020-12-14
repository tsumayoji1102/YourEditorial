//
//  SettingViewController.swift
//  yourEditorial
//
//  Created by 塩見陵介 on 2020/12/07.
//

import UIKit

class SettingViewController: UIViewController {
    
    enum Sections: Int{
        case main
        case sectionsNum
    }
    
    enum main: Int{
        case genre
        case aboutApp
        case mainNum
    }
    
    @IBOutlet weak var settingView: UITableView!
    @IBOutlet weak var naviBar: UINavigationItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        settingView.delegate = self
        settingView.dataSource = self
        settingView.isScrollEnabled = false
        settingView.clipsToBounds = true
        settingView.tableFooterView = UIView()
        settingView.backgroundColor = UIColor.systemGroupedBackground
        
        self.navigationItem.title = "設定"
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "戻る", style: .done, target: self, action: #selector(returnButton(_:)))
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        let safeArea = self.view.safeAreaInsets
        settingView.frame = CGRect(x: 0, y: safeArea.top, width: self.view.frame.width, height: self.view.frame.height - safeArea.top - safeArea.bottom)
    }
    
    @objc func returnButton(_ :UIBarButtonItem){
        self.dismiss(animated: true, completion: nil)
    }
}

extension SettingViewController: UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return Sections.sectionsNum.rawValue
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = UIView()
        header.backgroundColor = UIColor.clear
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section{
        case Sections.main.rawValue:
            return main.mainNum.rawValue
        default:
            break
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "SettingView", for: indexPath)
        
        for subView in cell.contentView.subviews{
            subView.removeFromSuperview()
        }
        
        let label = UILabel(frame: CGRect(x: 30, y: 5, width: 150, height: 40))
        
        switch indexPath.section {
        case Sections.main.rawValue:
            switch indexPath.row{
            case main.genre.rawValue:
                label.text = "ジャンルの整理"
                cell.addSubview(label)
                break
            case main.aboutApp.rawValue:
                label.text = "このアプリについて"
                cell.addSubview(label)
                break
            default:
                break
            }
            break
        default:
            break
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        switch indexPath.section {
        case Sections.main.rawValue:
            switch indexPath.row{
            case main.genre.rawValue:
                let genreVC = self.storyboard?.instantiateViewController(identifier: "GenreViewController") as? GenreViewController
                self.show(genreVC!, sender: nil)
                break
            case main.aboutApp.rawValue:
                let aboutVC = self.storyboard?.instantiateViewController(identifier: "AboutThisAppViewController") as? AboutThisAppViewController
                self.show(aboutVC!, sender: nil)
                break
            default:
                break
            }
            break
        default:
            break
        }
    }
}
