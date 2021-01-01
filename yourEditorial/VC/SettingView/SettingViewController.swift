//
//  SettingViewController.swift
//  yourEditorial
//
//  Created by 塩見陵介 on 2020/12/07.
//

import UIKit

final class SettingViewController: UIViewController {
    
    enum Sections: Int{
        case main
        case other
        case sectionsNum
    }
    
    enum main: Int{
        case genre
        case notification
        case mainNum
    }
    
    enum other: Int{
        case aboutApp
        case otherNum
    }
    
    @IBOutlet weak var settingView: UITableView!
    @IBOutlet weak var naviBar: UINavigationItem!
    
    private var notificationSwitch: UISwitch!
    
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
        
        notificationSwitch = UISwitch()
        let defaults = UserDefaults.standard
        notificationSwitch.isOn = defaults.bool(forKey: "notification")
        notificationSwitch.addTarget(self, action: #selector(setNotification(theSwitch:)), for: .valueChanged)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        let safeArea = self.view.safeAreaInsets
        settingView.frame = CGRect(x: 0, y: safeArea.top, width: self.view.frame.width, height: self.view.frame.height - safeArea.top - safeArea.bottom)
    }
    
    @objc func returnButton(_ :UIBarButtonItem){
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func setNotification(theSwitch : UISwitch){
        let defaults = UserDefaults.standard
        defaults.set(theSwitch.isOn, forKey: "notification")
        
        if theSwitch.isOn{
            AlertPushNortification.checkAndPush()
        }else{
            AlertPushNortification.deleteLocalPush()
        }
        
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
        case Sections.other.rawValue:
            return other.otherNum.rawValue
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
                cell.accessoryType = .disclosureIndicator
                break
            case main.notification.rawValue:
                label.text = "自動通知"
                notificationSwitch.frame = CGRect(x: self.view.frame.width - 70, y: cell.frame.height / 2 - 15, width: 50, height: 30)
                cell.contentView.addSubview(notificationSwitch)
                cell.selectionStyle = .none
                break
            default:
                break
            }
            break
        case Sections.other.rawValue:
            switch indexPath.row{
                case other.aboutApp.rawValue:
                label.text = "このアプリについて"
                cell.accessoryType = .disclosureIndicator
                break
            default:
                break
            }
            break
        default:
            break
        }
        
        cell.contentView.addSubview(label)
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
            default:
                break
            }
            break
        case Sections.other.rawValue:
            switch indexPath.row{
            case other.aboutApp.rawValue:
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
