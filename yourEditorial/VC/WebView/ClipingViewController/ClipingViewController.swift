//
//  ClipingViewController.swift
//  yourEditorial
//
//  Created by 塩見陵介 on 2020/11/07.
//

import UIKit
//import TPKeyboardAvoiding

class ClipingViewController: UIViewController {
    
    enum ClipingViewCell: Int{
        case cancel = 0
        case title
        case genre
        case decide
        case cellCount
    }

    @IBOutlet weak var clipingView: UITableView!
    //@IBOutlet weak var clearScrollView: TPKeyboardAvoidingCollectionView!
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
    private var viewModel: ClipingViewModel!
    private var appDelegate: AppDelegate!
    var clip: Clip!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        appDelegate = UIApplication.shared.delegate as? AppDelegate
        viewModel = ClipingViewModel(genreDao: appDelegate.daoFactory.getDao(daoRoute: DaoRoutes.genre) as! GenreDao)
        
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
        
        decideButton = UIButton()
        decideButton.setTitle("OK", for: .normal)
        decideButton.titleLabel?.textColor = UIColor.white
        decideButton.layer.cornerRadius = 10
        decideButton.backgroundColor = UIColor.blue
        decideButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        titleField.text = clip.name
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        clipingView.frame = CGRect(x: 0, y: self.view.frame.height / 2, width: self.view.frame.width, height: self.view.frame.height / 2)
    }
    
    @objc func close(_ :UIButton){
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func selectGenre(_ : UIButton){
        let genres: Array<Genre> = viewModel.getGenres()
        let selectVC = self.storyboard?.instantiateViewController(identifier: "SelectViewController") as? SelectViewController
        selectVC?.modalPresentationStyle = .custom
        selectVC?.transitioningDelegate = self
        selectVC?.list = genres.map{ return $0.name }
        selectVC?.closure = { index in
            let genre = genres[index!]
            self.clip.genreId = genre.genreId
            self.genreButton.setTitle(genre.name, for: .normal)
        }
        self.present(selectVC!, animated: true)
    }
    
    @objc func addGenre(_ :UIButton){
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
    
    @objc func setGenre(_ : UIButton){
        
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
