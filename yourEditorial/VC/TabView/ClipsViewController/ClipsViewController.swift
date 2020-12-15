//
//  ClipsViewController.swift
//  yourEditorial
//
//  Created by 塩見陵介 on 2020/10/26.
//

import UIKit
import RealmSwift

final class ClipsViewController: UIViewController {
    
    enum SortMode: Int{
        case genre = 0
        case newsPaper
        case date
    }
    
    @IBOutlet weak var clipsView: UITableView!
    private var noClipLabel: UILabel!
    
    private var viewModel:     ClipsViewModel!
    private var homeVC:        HomeViewController!
    private var clipList:      Array<Array<Clip>> = []
    private var genreList:     Array<Genre>       = []
    private var dateList:      Array<String>      = []
    private var newsPaperList: Array<String>      = []
    private var sortMode:      SortMode = SortMode.genre

    override func viewDidLoad() {
        super.viewDidLoad()
        
        noClipLabel = UILabel()
        noClipLabel.text = "クリップがありません。\n登録してみましょう！"
        noClipLabel.numberOfLines = 2
        noClipLabel.textAlignment = .center
        noClipLabel.font = UIFont.boldSystemFont(ofSize: 23)
        noClipLabel.textColor = UIColor.lightGray
        self.view.addSubview(noClipLabel)
        
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        let clipDao:  ClipDao  = appDelegate!.daoFactory.getDao(daoRoute: DaoRoutes.clip)  as! ClipDao
        let genreDao: GenreDao = appDelegate!.daoFactory.getDao(daoRoute: DaoRoutes.genre) as! GenreDao
        viewModel = ClipsViewModel(clipDao: clipDao, genreDao: genreDao)
        
        homeVC = self.parent as? HomeViewController
        
        genreList = viewModel.getGenres()
        sort()
        
        clipsView.delegate   = self
        clipsView.dataSource = self
        clipsView.tableFooterView = UIView()
    }
    
    override func viewWillAppear(_ animated: Bool){
        super.viewWillAppear(true)
        genreList = viewModel.getGenres()
        sort()
        
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        clipsView.frame = self.view.bounds
        noClipLabel.frame = CGRect(x: self.view.frame.width / 2 - 120, y: self.view.frame.height / 2 - 25, width: 240, height: 70)
    }
    
    private func sort(){
        clipList = Array<Array<Clip>>()
        let clips = viewModel.getClips()
        
        switch sortMode{
        case SortMode.date:
            let datesMap = clips.map{ return DateFormat.getDateyyyyMMddToString(date: $0.createdAt!) }
            let orderedSet = NSOrderedSet(array: datesMap)
            dateList = orderedSet.array as! [String]
            for date in dateList{
                var filter = clips.filter{ return DateFormat.getDateyyyyMMddToString(date: $0.createdAt!) == date}
                filter.sort{ return $0.createdAt! < $1.createdAt! }
                clipList.append(filter)
            }
            break
        case SortMode.newsPaper:
            let newsPaperMap = clips.map{ return $0.newsPaper }
            let orderedSet = NSOrderedSet(array: newsPaperMap)
            newsPaperList = orderedSet.array as! [String]
            for newsPaper in newsPaperList{
                var filter = clips.filter{ return $0.newsPaper == newsPaper }
                filter.sort{ return $0.createdAt! < $1.createdAt! }
                clipList.append(filter)
            }
            break
        case SortMode.genre:
            var genres: Array<Genre> = []
            for genre in genreList{
                var filter = clips.filter{ return $0.genreId == genre.genreId }
                if(!filter.isEmpty){
                    genres.append(genre)
                    filter.sort{ return $0.createdAt! < $1.createdAt! }
                    clipList.append(filter)
                }
            }
            genreList = genres
            break
        }
        clipsView.reloadData()
        
        noClipLabel.isHidden = clips.isEmpty ? false: true
        
    }
    
    func changeSortMode(index: Int){
        switch index{
        case SortMode.date.rawValue:
            sortMode = SortMode.date
            break
        case SortMode.newsPaper.rawValue:
            sortMode = SortMode.newsPaper
            break
        case SortMode.genre.rawValue:
            sortMode = SortMode.genre
            break
        default:
            break
        }
        sort()
    }

}

extension ClipsViewController: UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        switch sortMode{
        case SortMode.genre:
            return genreList.count
        case SortMode.newsPaper:
            return newsPaperList.count
        case SortMode.date:
            return dateList.count
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header: UIView = UIView()
        
        var title = ""
        switch sortMode{
        case SortMode.genre:
            if(!genreList.isEmpty){
                title = genreList[section].name
            }
            break
        case SortMode.newsPaper:
            if(!newsPaperList.isEmpty){
                title = newsPaperList[section]
            }
            break
        case SortMode.date:
            if(!dateList.isEmpty){
                title = dateList[section]
            }
            break
        }
        header.makeHeader(title: title)
        
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if clipList.count == 1 && clipList[0].isEmpty {
            return 0
        }
        return 35
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return clipList[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: ClipsViewCell = tableView.dequeueReusableCell(withIdentifier: "clipsViewCell",for: indexPath) as! ClipsViewCell
        
        cell.setClip(clip: clipList[indexPath.section][indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let clip = clipList[indexPath.section][indexPath.row]
        
        homeVC.getSite(newsPaperName: clip.newsPaper, url: clip.url)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            tableView.beginUpdates()
            let clip = clipList[indexPath.section][indexPath.row]
            clipList[indexPath.section].remove(at: indexPath.row)
            viewModel.deleteClip(clip: clip)
            tableView.deleteRows(at: [indexPath], with: .top)
            tableView.endUpdates()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                self.sort()
            })
        }
    }
    
    
}
