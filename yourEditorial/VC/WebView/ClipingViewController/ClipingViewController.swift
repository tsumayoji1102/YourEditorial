//
//  ClipingViewController.swift
//  yourEditorial
//
//  Created by 塩見陵介 on 2020/11/07.
//

import UIKit
import PKHUD
import StoreKit
//import TPKeyboardAvoiding

final class ClipingViewController: UIViewController {
    
    enum ClipingViewCell: Int{
        case cancel = 0
        case title
        case genre
        case decide
        case cellCount
    }
    
    enum TextFieldTag: Int{
        case title = 0
        case genre
    }

    @IBOutlet weak var clipingView: UITableView!
    @IBOutlet weak var clearScrollView: UIScrollView!
    @IBOutlet weak var clearScreen: UIButton!
    
    private var cancelButton:         UIButton!
    private var titleField:           UITextField!
    private var genreButton:          UIButton!
    private var addGenreButton:       UIButton!
    private var decideAddGenreButton: UIButton!
    private var genreField:           UITextField!
    private var decideButton:         UIButton!
    
    // 状態
    private var isAddGenre: Bool = false
    private var genreButtonImage: Dictionary<String, UIImage>!
    private var selectVC:  SelectViewController!
    private var viewModel: ClipingViewModel!
    private var appDelegate: AppDelegate!
    private var selectedGenre: Genre!
    private var genreList:   Array<Genre>!
    private var selectedTFFieldTag: Int!
    var clipDic: Dictionary<String, Any?>!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        appDelegate = UIApplication.shared.delegate as? AppDelegate
        let genreDao: GenreDao = appDelegate.daoFactory.getDao(daoRoute: DaoRoutes.genre) as! GenreDao
        let clipDao: ClipDao = appDelegate.daoFactory.getDao(daoRoute: DaoRoutes.clip) as! ClipDao
        viewModel = ClipingViewModel(genreDao: genreDao, clipDao: clipDao)
        
        // Viewを透明に
        self.view.backgroundColor = UIColor.clear
       // clearScrollView.backgroundColor = UIColor.clear
        
        clipingView.delegate   = self
        clipingView.dataSource = self
        clipingView.isEditing = false
        clipingView.separatorStyle = .none
        clipingView.isScrollEnabled = false
        clipingView.allowsSelection = false
        
        clearScreen.addTarget(self, action: #selector(close(_:)), for: .touchDown)
        
        cancelButton = UIButton()
        cancelButton.setTitle("キャンセル", for: .normal)
        cancelButton.setTitleColor(UIColor.systemBlue, for: .normal)
        cancelButton.addTarget(self, action: #selector(close(_:)), for: .touchDown)
        
        titleField = UITextField()
        titleField.delegate = self
        titleField.tag = TextFieldTag.title.rawValue
        
        genreButton = UIButton()
        genreButton.setTitle("ジャンルを選択", for: .normal)
        genreButton.addTarget(self, action: #selector(selectGenre(_:)), for: .touchDown)
        genreButton.titleLabel?.textColor = UIColor.black
        genreButton.layer.cornerRadius = 10
        genreButton.backgroundColor = UIColor.gray
        genreButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        
        genreButtonImage = Dictionary<String, UIImage>()
        let plus = UIImage(systemName: "plus.square")?.resize(size: CGSize(width: 30, height: 30))
        plus?.withTintColor(UIColor.systemBlue)
        genreButtonImage["plus.square"] = plus
        
        let clear = UIImage(systemName: "clear")?.resize(size:CGSize(width: 30, height: 30))
        clear?.withTintColor(UIColor.red)
        genreButtonImage["clear"] = clear
            
        addGenreButton = UIButton()
        addGenreButton.setImage(genreButtonImage["plus.square"], for: .normal)
        addGenreButton.addTarget(self, action: #selector(addGenre(_:)), for: .touchDown)
        
        decideAddGenreButton = UIButton()
        decideAddGenreButton.setImage(genreButtonImage["plus.square"], for: .normal)
        decideAddGenreButton.addTarget(self, action: #selector(setGenre(_:)), for: .touchDown)
        decideAddGenreButton.isHidden = true
        
        genreField = UITextField()
        genreField.delegate = self
        genreField.isHidden = true
        genreField.tag = TextFieldTag.genre.rawValue
        
        decideButton = UIButton()
        decideButton.setTitle("OK", for: .normal)
        decideButton.titleLabel?.textColor = UIColor.white
        decideButton.layer.cornerRadius = 10
        decideButton.backgroundColor = UIColor.blue
        decideButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        decideButton.addTarget(self, action: #selector(setClip(_:)), for: .touchDown)
        
        selectVC = self.storyboard?.instantiateViewController(identifier: "SelectViewController") as? SelectViewController
        selectVC.modalPresentationStyle = .custom
        selectVC.transitioningDelegate = self
        selectVC.delegate = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        titleField.text = clipDic["name"] as? String
        
        // テキストビューの対策(高さ)
        let notification = NotificationCenter.default
        notification.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        notification.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardDidHideNotification, object: nil)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        clipingView.frame = CGRect(x: 0, y: self.view.frame.height / 2, width: self.view.frame.width, height: self.view.frame.height / 2)
    }
    
    deinit {
        let notification = NotificationCenter.default
        notification.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        notification.removeObserver(self, name: UIResponder.keyboardDidHideNotification, object: nil)
    }
    
    @objc private func close(_ :UIButton){
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc private func selectGenre(_ : UIButton){
        genreList = viewModel.getGenres()
        if genreList.isEmpty {
            let alert = UIAlertController(title: "ジャンルなし", message: "新しくジャンルを追加してください。", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true)
            return
        }
        selectVC.reloadSelectView()
        self.present(selectVC!, animated: true)
    }
    
    @objc func addGenre(_ :UIButton){
        changeGenreState()
    }
    
    @objc private func setGenre(_ : UIButton){
        if genreField.text!.isEmpty {
            let alert = UIAlertController(title: "未入力", message: "ジャンルを入力してください。", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true)
            return
        }else{
            HUD.flash(.progress, delay: 0.0)
            let date = Date()
            viewModel.setGenre(dic: [
                "name": genreField.text,
                "createdAt": date,
                "updatedAt": date
            ])
            genreField.text = ""
            selectedGenre = viewModel.getGenres().last
            genreButton.setTitle(selectedGenre.name, for: .normal)
            clipDic["genreId"] = selectedGenre.genreId
            changeGenreState()
            HUD.hide()
        }
    }
    
    @objc private func setClip(_ :UIButton){
        HUD.flash(.progress, delay: 0.0)
        if clipDic["genreId"] == nil {
            clipDic["genreId"] = 0
        }
        viewModel.setClip(dic: clipDic)
        HUD.hide()
        let alert = UIAlertController(title: "クリップ完了", message: "記事をクリップしました。", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            self.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0, execute: {
                let userDefault = UserDefaults.standard
                let count = userDefault.value(forKey: "clipCount") as! Int
                let newCount = count + 1
                userDefault.set(newCount, forKey: "clipCount")
                let review = userDefault.value(forKey: "reviewed") as! Bool
                if newCount % 5 == 0 && !review {
                    SKStoreReviewController.requestReview()
                }
            })
        })
    }
    
    // キーボードが出現する時
    @objc private func keyboardWillShow(notification: Notification?){
        let rect = (notification?.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue
        let duration: TimeInterval? = notification?.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double
        
        // textFieldごとに判定
        var textFieldOffset: CGFloat = 0
        switch selectedTFFieldTag {
        case TextFieldTag.title.rawValue:
            textFieldOffset = titleField.frame.maxY
            break
        case TextFieldTag.genre.rawValue:
            textFieldOffset = genreField.frame.maxY
            break
        default:
            break
        }
        
        UIView.animate(withDuration: duration!, delay: 0.0, options: .curveEaseIn, animations: {
            () in
            self.clearScrollView.transform = CGAffineTransform(translationX: 0, y: -((rect?.size.height)! - textFieldOffset))
        }, completion: nil)
        
    }
    
    // キーボードが隠れるとき
    @objc private func keyboardWillHide(notification: Notification?){
        UIView.animate(withDuration: 0.05, delay: 0.0, options: .curveEaseInOut, animations: {
            self.clearScrollView.transform = CGAffineTransform.identity
        })
    }
    
    private func changeGenreState(){
        let change = !isAddGenre
        isAddGenre = change
        genreButton.isHidden = isAddGenre
        genreField.isHidden = !isAddGenre
        decideAddGenreButton.isHidden = !isAddGenre
        
        if isAddGenre {
            addGenreButton.setImage(genreButtonImage["clear"], for: .normal)
        }else{
            addGenreButton.setImage(genreButtonImage["plus.square"], for: .normal)
        }
    }
}

extension ClipingViewController: SelectViewDelegate{
    func setSelectArray() -> Array<String>? {
        return genreList.map{ return $0.name }
    }
    
    func setStartIndex() -> Int? {
        if selectedGenre != nil{
            let index = genreList.firstIndex(of: selectedGenre)
            return index
        }
        return 0
    }
    
    func setClosure(index: Int!){
        self.selectedGenre = self.genreList[index!]
        self.clipDic["genreId"] = self.selectedGenre.genreId
        self.genreButton.setTitle(self.selectedGenre.name, for: .normal)
    }
}

extension ClipingViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ClipingViewCell.cellCount.rawValue
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var height: CGFloat
        switch indexPath.row{
        case ClipingViewCell.cancel.rawValue:
            height = 40
            break
        case ClipingViewCell.title.rawValue:
            height = 70
            break
        case ClipingViewCell.genre.rawValue:
            height = 70
            break
        case ClipingViewCell.decide.rawValue:
            height = 90
            break
        default:
            height = 0
            break
        }
        return height
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "clipingViewCell", for: indexPath)
        for subView in cell.subviews{
            subView.removeFromSuperview()
        }
        
        let marginX:      CGFloat = 20
        let widgetHeight: CGFloat = 20
        
        switch indexPath.row{
        case ClipingViewCell.cancel.rawValue:
            let width: CGFloat = 90
            cancelButton.frame = CGRect(x: self.view.frame.width - width - marginX, y: 10, width: width, height: widgetHeight)
            cell.addSubview(cancelButton)
            break
        case ClipingViewCell.title.rawValue:
            titleField.frame = CGRect(x: marginX, y: 25, width: self.view.frame.width - 2 * marginX , height: widgetHeight)
            titleField.addBottomBorder(height: 0.5, color: UIColor.gray)
            cell.addSubview(titleField)
            break
        case ClipingViewCell.genre.rawValue:
            genreButton.frame = CGRect(x: marginX, y: 20, width: self.view.frame.width - marginX * 2 - 40, height: 30)
            genreField.frame = CGRect(x: marginX, y: 20, width: self.view.frame.width - marginX * 2 - 80, height: 30)
            genreField.addBottomBorder(height: 0.5, color: UIColor.gray)
            decideAddGenreButton.frame = CGRect(x: genreField.frame.maxX + 10, y: 20, width: 30, height: 30)
            addGenreButton.frame = CGRect(x: genreButton.frame.maxX + 10, y: 20, width: 30, height: 30)
            
            cell.addSubview(genreButton)
            cell.addSubview(addGenreButton)
            cell.addSubview(decideAddGenreButton)
            cell.addSubview(genreField)
            break
        case ClipingViewCell.decide.rawValue:
            decideButton.frame = CGRect(x: marginX, y: 20, width: self.view.frame.width - marginX * 2, height: 50)
            cell.addSubview(decideButton)
            break
        default:
            break
        }
        
        return cell
    }
}


// MARK: - UITextFieldDelegate

extension ClipingViewController: UITextFieldDelegate{
    
    // キーボードタップ時
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.selectedTFFieldTag = textField.tag
    }
    
    // エンター押下時
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    // TODO: 字数チェック
    
}

// MARK: - UITransitioningDelegate
extension ClipingViewController: UIViewControllerTransitioningDelegate{
    
    // 自動的にモーダル表示ができるように設計
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        
        return TransitionController(presentedViewController: presented, presenting: presenting)
    }
}
