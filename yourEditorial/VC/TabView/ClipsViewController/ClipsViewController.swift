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
    
    private var appDelegate: AppDelegate!
    private var viewModel: ClipsViewModel!
    private var clipList: Array<Array<Clip>> = []
    private var genreList: Array<Genre> = []
    private var sortMode: SortMode   = SortMode.genre

    override func viewDidLoad() {
        super.viewDidLoad()
        
        appDelegate = UIApplication.shared.delegate as? AppDelegate
        let clipDao: ClipDao = appDelegate.daoFactory.getDao(daoRoute: DaoRoutes.clip) as! ClipDao
        let genreDao: GenreDao = appDelegate.daoFactory.getDao(daoRoute: DaoRoutes.genre) as! GenreDao
        viewModel = ClipsViewModel(clipDao: clipDao, genreDao: genreDao)
        
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
            break
        case SortMode.newsPaper:
            break
        case SortMode.genre:
            for genre in genreList{
                let clipsMap = clips.filter{ return $0.genreId == genre.genreId }
                clipList.append(clipsMap)
            }
            break
        }
        clipsView.reloadData()
    }
    
    func changeSortMode(index: Int){
        switch index{
        case SortMode.date.rawValue:
            break
        case SortMode.newsPaper.rawValue:
            break
        case SortMode.genre.rawValue:
            break
        default:
            break
        }
    }

}

extension ClipsViewController: UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return clipList.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header: UIView = UIView()
        header.backgroundColor = UIColor.gray
        
        let label: UILabel = UILabel(frame: CGRect(x: 20, y: 5, width: 200, height: 30))
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textColor = UIColor.white
        header.addSubview(label)
        
        switch sortMode{
        case SortMode.genre:
            label.text = genreList[section].name
            break
        case SortMode.newsPaper:
            break
        case SortMode.date:
            break
        default:
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
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "clipsViewCell",for: indexPath)
        for subView in cell.contentView.subviews{
            subView.removeFromSuperview()
        }
        
        let titleLabel = UILabel(frame: CGRect(x: 10, y: 10, width: self.view.frame.width - 40, height: 60))
        titleLabel.text = clipList[indexPath.section][indexPath.row].name
        cell.contentView.addSubview(titleLabel)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    
}
