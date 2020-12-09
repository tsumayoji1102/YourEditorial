//
//  GenreViewController.swift
//  yourEditorial
//
//  Created by 塩見陵介 on 2020/12/07.
//

import UIKit

class GenreViewController: UIViewController {
    
    enum Sections: Int {
        case add = 0
        case list
        case sectionsNum
    }

    @IBOutlet weak var genreView: UITableView!
    private var addTextField: UITextField!
    private var addButton:    UIButton!
    
    private var genreList: Array<Genre> = []
    private var viewModel: GenreViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        let genreDao = appDelegate?.daoFactory.getDao(daoRoute: DaoRoutes.genre) as? GenreDao
        let clipDao = appDelegate?.daoFactory.getDao(daoRoute: DaoRoutes.clip) as? ClipDao
        viewModel = GenreViewModel(genreDao: genreDao, clipDao: clipDao)
        
        self.navigationItem.title = "ジャンルの整理"
        
        genreView.delegate = self
        genreView.dataSource = self
        genreView.backgroundColor = UIColor.systemBackground
        genreView.tableFooterView = UIView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        genreList = viewModel.getGenres()
    }
    
    
    
    
}

extension GenreViewController: UITableViewDelegate, UITableViewDataSource{
    
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
        switch section {
        case Sections.add.rawValue:
            return 1
        case Sections.list.rawValue:
            return genreList.count
            return
        default:
            return 0
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "GenreViewCell", for: indexPath)
        
        for subView in cell.contentView.subviews{
            subView.removeFromSuperview()
            cell.isEditing = false
        }
        
        switch indexPath.section {
        case Sections.add.rawValue:
            
            cell.isEditing = false
            break
        case Sections.list.rawValue:
            let genre = genreList[indexPath.row]
            let textField = UITextField(frame: CGRect(x: 20, y: 10, width: 200, height: 30))
            textField.text = genre.name
            
            cell.contentView.addSubview(textField)
            cell.isEditing = true
            break
        default:
            break
        }
        
        return cell
    }
    
    
    
}
