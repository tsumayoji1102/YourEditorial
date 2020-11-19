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
    
    private var appDelegate:   AppDelegate!
    private var viewModel:     ClipsViewModel!
    private var homeVC:        HomeViewController!
    private var clipList:      Array<Array<Clip>> = []
    private var genreList:     Array<Genre>       = []
    private var dateList:      Array<String>      = []
    private var newsPaperList: Array<String>      = []
    private var sortMode:      SortMode = SortMode.genre

    override func viewDidLoad() {
        super.viewDidLoad()
        
        appDelegate = UIApplication.shared.delegate as? AppDelegate
        let clipDao: ClipDao   = appDelegate.daoFactory.getDao(daoRoute: DaoRoutes.clip)  as! ClipDao
        let genreDao: GenreDao = appDelegate.daoFactory.getDao(daoRoute: DaoRoutes.genre) as! GenreDao
        viewModel = ClipsViewModel(clipDao: clipDao, genreDao: genreDao)
        
        homeVC = self.parent as? HomeViewController
        
        genreList = viewModel.getGenres()
        sort()
        
        clipsView.delegate = self
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
                let filter = clips.filter{ return DateFormat.getDateyyyyMMddToString(date: $0.createdAt!) == date}
                clipList.append(filter)
            }
            break
        case SortMode.newsPaper:
            let newsPaperMap = clips.map{ return $0.newsPaper }
            let orderedSet = NSOrderedSet(array: newsPaperMap)
            newsPaperList = orderedSet.array as! [String]
            for newsPaper in newsPaperList{
                let filter = clips.filter{ return $0.newsPaper == newsPaper }
                clipList.append(filter)
            }
            break
        case SortMode.genre:
            var genres: Array<Genre> = []
            for genre in genreList{
                let clipsMap = clips.filter{ return $0.genreId == genre.genreId }
                if(!clipsMap.isEmpty){
                    genres.append(genre)
                }
                clipList.append(clipsMap)
            }
            genreList = genres
            break
        }
        clipsView.reloadData()
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
        return clipList.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header: UIView = UIView()
        
        switch sortMode{
        case SortMode.genre:
            if(!genreList.isEmpty){
                header.makeHeader(title: genreList[section].name)
            }
            break
        case SortMode.newsPaper:
            if(!newsPaperList.isEmpty){
                header.makeHeader(title: newsPaperList[section])
            }
            break
        case SortMode.date:
            if(!dateList.isEmpty){
                header.makeHeader(title: dateList[section])
            }
            break
        }
        
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
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
    
    
}
