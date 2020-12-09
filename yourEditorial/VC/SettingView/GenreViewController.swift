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
        viewModel = GenreViewModel(genreDao: genreDao!, clipDao: clipDao!)
        
        self.navigationItem.title = "ジャンルの整理"
        
        genreView.delegate = self
        genreView.dataSource = self
        genreView.backgroundColor = UIColor.systemGroupedBackground
        genreView.tableFooterView = UIView()
        
        addTextField = UITextField()
        addTextField.delegate = self

        addButton = UIButton()
        addButton = UIButton()
        addButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        addButton.layer.cornerRadius = 5
        addButton.setTitle("追加", for: .normal)
        addButton.setTitleColor(UIColor.white, for: .normal)
        addButton.backgroundColor = UIColor.systemBlue
        //addButton.addTarget(self, action: #selector(tapButton(_:)), for: .touchUpInside)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        genreList = viewModel.getGenres()
        genreView.reloadData()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        let safeArea = self.view.safeAreaInsets
        genreView.frame = CGRect(x: 0, y: safeArea.top, width: self.view.frame.width, height: self.view.frame.height - safeArea.top - safeArea.bottom)
        
        addTextField.frame = CGRect(x: 20, y: 10, width: 200, height: 30)
        addTextField.addBottomBorder(height: 1, color: UIColor.systemGray)
        
        addButton.frame = CGRect(x: self.view.frame.width - 90, y: 10, width: 60, height: 30)
    }
    
    @objc func tapAddButton(){
        
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
            cell.contentView.addSubview(addTextField)
            cell.contentView.addSubview(addButton)
            cell.isEditing = false
            break
        case Sections.list.rawValue:
            let genre = genreList[indexPath.row]
            let textField = UITextField(frame: CGRect(x: 20, y: 10, width: 200, height: 30))
            textField.text = genre.name
            textField.tag = indexPath.row + 1
            textField.delegate = self
            
            cell.contentView.addSubview(textField)
            cell.isEditing = true
            break
        default:
            break
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let alert = UIAlertController(title: "注意", message: "ジャンルを削除すると、そのジャンルのクリップが全て削除されます。本当に実行しますか。", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {action in
                tableView.beginUpdates()
                let genre = self.genreList[indexPath.row]
                self.genreList.remove(at: indexPath.row)
                self.viewModel.deleteGenre(genre: genre)
                tableView.deleteRows(at: [indexPath], with: .top)
                tableView.endUpdates()
                tableView.reloadData()
            }))
            alert.addAction(UIAlertAction(title: "キャンセル", style: .cancel, handler: nil))
            present(alert, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        switch indexPath.section{
        case Sections.add.rawValue:
            return false
        case Sections.list.rawValue:
            return true
        default:
            return false
        }
    }
}

extension GenreViewController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if textField.tag != 0{
            if textField.text!.isEmpty {
                let alert = UIAlertController(title: "エラー", message: "アラート名を入力してください。", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                present(alert, animated: true)
                return true
            }
            let genre = genreList[textField.tag - 1]
           
            if genre.name != textField.text {
                viewModel.updateGenreName(genreId: genre.genreId, name: textField.text!)
            }
        }
        return true
    }
}
