//
//  NewsPaperEditorialsViewController.swift
//  yourEditorial
//
//  Created by 塩見陵介 on 2020/10/19.
//

import UIKit
import PKHUD
import GoogleMobileAds

final class NewsPaperEditorialsViewController: UIViewController{
    
    enum SortMode: Int{
        case all = 0
        case favorite
    }

    @IBOutlet weak var editorialView: UITableView!
    private var noClipLabel: UILabel!
    
    private var homeVC:      HomeViewController!
    private var viewModel:   NewsPaperEditorialViewModel!
    private var sortMode:    SortMode = SortMode.all
    private var arrayList:   Array<Array<NewsPaper>> = []
    private var imagesDic: Dictionary<String, UIImage> = [:]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // AppDelegate取得
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        let favoriteNewsPaperDao: FavoriteNewsPaperDao = appDelegate!.daoFactory.getDao(daoRoute: DaoRoutes.favoriteNewsPaper) as! FavoriteNewsPaperDao
        viewModel = NewsPaperEditorialViewModel(favoriteNewsPaperDao: favoriteNewsPaperDao)
        
        // VC生成
        homeVC = self.parent as? HomeViewController
        
        for newsPaper in Constraints.newsPapers{
            let image = UIImage(named: newsPaper.image)?.resize(size: CGSize(width: 40, height: 40))
            imagesDic[newsPaper.image] = image
        }
        
        noClipLabel = UILabel()
        noClipLabel.text = "お気に入りがありません。\n登録してみましょう！"
        noClipLabel.numberOfLines = 2
        noClipLabel.textAlignment = .center
        noClipLabel.font = UIFont.boldSystemFont(ofSize: 23)
        noClipLabel.textColor = UIColor.lightGray
        self.view.addSubview(noClipLabel)
        
        self.sort()
        editorialView.delegate = self
        editorialView.dataSource = self
        editorialView.tableFooterView = UIView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        editorialView.frame = self.view.bounds
        noClipLabel.frame = CGRect(x: self.view.frame.width / 2 - 130, y: self.view.frame.height / 2 - 25, width: 260, height: 70)
    }
    
    private func sort(){
        arrayList = Array<Array<NewsPaper>>()
        switch sortMode {
        case SortMode.all:
            for groupIndex in 0..<NewsPaper.groups.groupsCount.rawValue{
                let fillterArray = Constraints.newsPapers.filter{ newspaper in
                    return newspaper.group.rawValue == groupIndex
                }
                arrayList.append(fillterArray)
            }
            noClipLabel.isHidden = true
            break
        case SortMode.favorite:
            let favoriteNewsPapers = viewModel.getFavoriteNewsPapers()
            arrayList.append(favoriteNewsPapers)
            if favoriteNewsPapers.isEmpty {
                noClipLabel.isHidden = false
            }
            break
        }
        editorialView.reloadData()
    }
    
    // HomeViewから入れる
    // TODO: protocol化
    func changeSortMode(index: Int){
        switch index{
        case SortMode.all.rawValue:
            sortMode = SortMode.all
            break
        case SortMode.favorite.rawValue:
            sortMode = SortMode.favorite
            break
        default:
            break
        }
        self.sort()
    }
}

extension NewsPaperEditorialsViewController: UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        switch sortMode {
        case SortMode.all:
            return NewsPaper.groups.groupsCount.rawValue
        case SortMode.favorite:
            return 1
        }
        
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header: UIView = UIView()
        if sortMode == SortMode.all{
            switch section {
            case NewsPaper.groups.nationWide.rawValue:
                header.makeHeader(title: "全国紙")
                break
            case NewsPaper.groups.block.rawValue:
                header.makeHeader(title: "ブロック紙")
                break
            case NewsPaper.groups.local.rawValue:
                header.makeHeader(title: "地方紙(47NEWS)")
            default:
                break
            }
        }else if sortMode == SortMode.favorite{
            header.makeHeader(title: "お気に入り")
        }
        
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 35
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayList[section].count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: NewsPaperCell = tableView.dequeueReusableCell(withIdentifier: "newsPaperEditorialCell",for: indexPath) as! NewsPaperCell
        
        // newsPaper取得
        let newsPaper: NewsPaper = arrayList[indexPath.section][indexPath.row]
        cell.setNewsPaper(icon: imagesDic[newsPaper.image]!, name: newsPaper.name)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let newsPaper: NewsPaper = arrayList[indexPath.section][indexPath.row]
        
        homeVC.getSite(newsPaperName: newsPaper.name, url: newsPaper.url)
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        
    }
    
    // スワイプ用
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        var action: UIContextualAction
        switch sortMode{
        case SortMode.all:
            action = setfavoriteNewsPaper(indexPath: indexPath)!
            break
        case SortMode.favorite:
            action = deletefavoriteNewsPaper(indexPath: indexPath)!
            break
        }
           
        let configration = UISwipeActionsConfiguration(actions: [action])
        return configration
    }
    
    private func setfavoriteNewsPaper(indexPath: IndexPath) -> UIContextualAction? {
        let contextualAction = UIContextualAction(
            style: .normal,
            title: "favorite",
            handler: {_,_, handler in
                let result = self.viewModel.setFavorite(newspaper: self.arrayList[indexPath.section][indexPath.row])
                
                var title: String
                var message: String
                
                if result {
                    title = "完了"
                    message = "お気に入り登録しました。"
                }else{
                    title = "登録済み"
                    message = "この社説は既にお気に入りに登録されています。"
                }
                let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            handler(true)
        })
        contextualAction.image = UIImage(systemName: "star.fill")
        contextualAction.backgroundColor = UIColor.systemYellow
        return contextualAction
    }
    
    private func deletefavoriteNewsPaper(indexPath: IndexPath) -> UIContextualAction? {
        let contextualAction = UIContextualAction(
            style: .normal,
            title: "delete",
            handler: {_,_, handler in
                let newsPaper = self.arrayList[indexPath.section][indexPath.row]
                self.arrayList[indexPath.section].remove(at: indexPath.row)
                self.viewModel.deleteFavoriteNewsPaper(newspaper: newsPaper)
                // リストの削除が先（注意)
                self.editorialView.beginUpdates()
                self.editorialView.deleteRows(at: [indexPath], with: .top)
                self.editorialView.endUpdates()
                if self.arrayList[indexPath.section].isEmpty {
                    self.noClipLabel.isHidden = false
                }                /*
                DispatchQueue.main.async {
                    self.sort()
                }
 */ 
            handler(true)
        })
        contextualAction.backgroundColor = UIColor.systemRed
        return contextualAction
    }
    
}

class NewsPaperCell: UITableViewCell{
    
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var name: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        icon.frame = CGRect(x: 15, y: 10, width: 40, height: 40)
        name.frame = CGRect(x: icon.frame.maxX + 20, y: 15, width: 120, height: 30)
    }
    
    func setNewsPaper(icon: UIImage, name: String){
        self.icon.image = icon
        self.name.text = name
    }
    
}
