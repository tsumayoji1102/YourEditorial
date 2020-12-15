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

    @IBOutlet weak var genreView:    UITableView!
    @IBOutlet weak var keyboardView: UIScrollView!
    private var addTextField:        UITextField!
    private var addButton:           UIButton!
    
    private var genreList:           Array<Genre> = []
    private var viewModel:           GenreViewModel!
    private var selectedTFFieldTag:  Int = 0
    private var textFieldCGRect:     CGRect!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        let genreDao = appDelegate?.daoFactory.getDao(daoRoute: DaoRoutes.genre) as? GenreDao
        let clipDao = appDelegate?.daoFactory.getDao(daoRoute: DaoRoutes.clip) as? ClipDao
        viewModel = GenreViewModel(genreDao: genreDao!, clipDao: clipDao!)
        
        self.navigationItem.title = "ジャンルの整理"
        
        keyboardView.backgroundColor = UIColor.systemGroupedBackground
        genreView.delegate = self
        genreView.dataSource = self
        genreView.allowsSelection = false
        genreView.backgroundColor = UIColor.systemGroupedBackground
        genreView.tableFooterView = UIView()
        
        addTextField = UITextField()
        addTextField.delegate = self

        addButton = UIButton()
        addButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        addButton.layer.cornerRadius = 5
        addButton.setTitle("追加", for: .normal)
        addButton.setTitleColor(UIColor.white, for: .normal)
        addButton.backgroundColor = UIColor.systemBlue
        addButton.addTarget(self, action: #selector(tapAddButton(_:)), for: .touchUpInside)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        genreList = viewModel.getGenres()
        genreList.sort{ $0.createdAt! > $1.createdAt! }
        genreView.reloadData()
        
        // テキストビューの対策(高さ)
        let notification = NotificationCenter.default
        notification.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        notification.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardDidHideNotification, object: nil)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        let safeArea = self.view.safeAreaInsets
        self.keyboardView.frame = CGRect(x: 0, y: safeArea.top, width: self.view.frame.width, height: self.view.frame.height - safeArea.top)
        genreView.frame = keyboardView.bounds
        
        addTextField.frame = CGRect(x: 20, y: 10, width: 200, height: 30)
        addTextField.addBottomBorder(height: 1, color: UIColor.systemGray)
        
        addButton.frame = CGRect(x: self.view.frame.width - 90, y: 10, width: 60, height: 30)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        let notification = NotificationCenter.default
        notification.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        notification.removeObserver(self, name: UIResponder.keyboardDidHideNotification, object: nil)
        super.viewDidDisappear(true)
    }
    
    @objc func tapAddButton(_: UIButton){
        if addTextField.text!.isEmpty {
            let alert = UIAlertController(title: "未入力", message: "ジャンル名を入力してください。", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            return
        }
        var isContained = false
        for genre in genreList{
            if genre.name == addTextField!.text{
                isContained = true
            }
        }
        if isContained {
            let alert = UIAlertController(title: "注意", message: "同じジャンル名が入力されています。", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            return
        }
        viewModel.addGenre(dic: [
            "name": addTextField.text,
            "updatedAt": Date(),
            "createdAt": Date()
        ])
        addTextField.text = ""
        genreList = viewModel.getGenres()
        genreList.sort{ $0.createdAt! > $1.createdAt! }
        DispatchQueue.main.async {
            self.genreView.beginUpdates()
            self.genreView.insertRows(at: [IndexPath(row: 0, section: Sections.list.rawValue)], with: .automatic)
            self.genreView.endUpdates()
        }
    }
    
    // キーボードが出現する時
    @objc private func keyboardWillShow(notification: Notification?){
        let rect = (notification?.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
        let duration: TimeInterval? = notification?.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double
        
        // textFieldごとに判定
        let textFieldY: CGFloat = ((genreView.cellForRow(at: IndexPath(row: selectedTFFieldTag, section: Sections.list.rawValue))?.frame.origin.y)! + 80)
        let keyboardY = self.view.frame.height - (rect?.size.height)!
        
        if textFieldY > keyboardY {
            UIView.animate(withDuration: duration!, delay: 0.0, options: .curveEaseIn, animations: {
                    () in
                self.genreView.transform = CGAffineTransform(translationX: 0, y:  -(textFieldY - keyboardY + 80))
            }, completion: nil)
            
        }
    }
    
    // キーボードが隠れるとき
    @objc private func keyboardWillHide(notification: Notification?){
        UIView.animate(withDuration: 0.28, delay: 0.0, options: .curveEaseInOut, animations: {
            self.genreView.transform = CGAffineTransform.identity
        })
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
        
        switch indexPath.section {
        case Sections.add.rawValue:
            let cell = tableView.dequeueReusableCell(withIdentifier: "GenreViewCell", for: indexPath)
            
            for subView in cell.contentView.subviews{
                subView.removeFromSuperview()
                cell.isEditing = false
            }
            cell.contentView.addSubview(addTextField)
            cell.contentView.addSubview(addButton)
            cell.isEditing = false
            return cell
            
        case Sections.list.rawValue:
            let cell = tableView.dequeueReusableCell(withIdentifier: "GenreEditCell", for: indexPath) as? GenreEditCell
            let genre = genreList[indexPath.row]
            // セル初期化
            cell?.setGenre(
                genre: genre,
                tag: indexPath.row,
                editFunc: { genre, name in
                if name.isEmpty {
                    let alert = UIAlertController(title: "エラー", message: "アラート名を入力してください。", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(alert, animated: true)
                    return
                }
                if genre.name != name {
                    self.viewModel.updateGenreName(genreId: genre.genreId, name: name)
                }
            }, tapTfFunc: { tag in
                self.selectedTFFieldTag = tag
            })
            
            cell!.isEditing = true
            return cell!
        default:
            return UITableViewCell()
        }
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
    
    func setIndexPath(tag: Int) -> Bool {
        return true
    }
}

extension GenreViewController: UITextFieldDelegate{
    

    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func updateGenre(genre: Genre, name: String){
        if name.isEmpty {
            let alert = UIAlertController(title: "エラー", message: "アラート名を入力してください。", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true)
            return
        }
        if genre.name != name {
            viewModel.updateGenreName(genreId: genre.genreId, name: name)
        }
    }
}

class GenreEditCell: UITableViewCell{
    
    @IBOutlet weak var genreTextField: UITextField!
    private var genre: Genre!
    private var editFunc: ((Genre, String) -> Void)!
    private var tapTfFunc: ((Int) -> Void)!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        genreTextField.frame = CGRect(x: 20, y: 10, width: 200, height: 30)
        genreTextField.delegate = self
    }
    
    func setGenre(genre: Genre, tag: Int, editFunc: @escaping ((Genre, String) -> Void), tapTfFunc: @escaping ((Int) -> Void)){
        self.genre = genre
        genreTextField.tag = tag
        genreTextField.text = genre.name
        self.editFunc = editFunc
        self.tapTfFunc = tapTfFunc
    }
}

extension GenreEditCell: UITextFieldDelegate{
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
           tapTfFunc(textField.tag)
           return true
       }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        editFunc(genre, textField.text!)
        return true
    }
}
