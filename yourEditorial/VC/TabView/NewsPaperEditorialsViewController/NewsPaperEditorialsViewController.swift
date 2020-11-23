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
    
    private var appDelegate: AppDelegate!
    private var homeVC:      HomeViewController!
    private var viewModel:   NewsPaperEditorialViewModel!
    private var sortMode:    SortMode = SortMode.all
    private var arrayList:   Array<Array<NewsPaper>> = []
    private var imagesDic: Dictionary<String, UIImage> = [:]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // AppDelegate取得
        appDelegate = UIApplication.shared.delegate as? AppDelegate
        let favoriteNewsPaperDao: FavoriteNewsPaperDao = appDelegate.daoFactory.getDao(daoRoute: DaoRoutes.favoriteNewsPaper) as! FavoriteNewsPaperDao
        viewModel = NewsPaperEditorialViewModel(favoriteNewsPaperDao: favoriteNewsPaperDao)
        
        // VC生成
        homeVC = self.parent as? HomeViewController
        
        for newsPaper in Constraints.newsPapers{
            let image = UIImage(named: newsPaper.image)?.resize(size: CGSize(width: 40, height: 40))
            imagesDic[newsPaper.image] = image
        }
        
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
            break
        case SortMode.favorite:
            let favoriteNewsPapers = viewModel.getFavoriteNewsPapers()
            arrayList.append(favoriteNewsPapers)
            break
        }
    }
    
    // HomeViewから入れる
    // TODO: protocol化
    func changeSortMode(index: Int){
        switch index{
        case SortMode.all.rawValue:
            sortMode = SortMode.all
            editorialView.isEditing = false
            break
        case SortMode.favorite.rawValue:
            sortMode = SortMode.favorite
            editorialView.isEditing = true
            break
        default:
            break
        }
        self.sort()
        editorialView.reloadData()
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
        return 40
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
    
    /*
    // スワイプ用
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let action = UISwipeActionsConfiguration(actions: [])
    }
    
    private func setfavoriteNewsPaper(indexPath: IndexPath!) -> UIContextualAction? {
        let contextualAction = UIContextualAction(
            style: .normal,
            title: "favorite",
            handler: {_,_, handler in
            
            handler(true)
        })
    }
    */
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
