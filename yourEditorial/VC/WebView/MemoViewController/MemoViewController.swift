//
//  MemoViewController.swift
//  yourEditorial
//
//  Created by 塩見陵介 on 2021/02/07.
//

import UIKit

protocol MemoViewDelegate: AnyObject{
    func getMemo(_ memo: String)
}

class MemoViewController: UIViewController {
    
    enum memoViewCell: Int{
        case title = 0
        case memo
        case decide
        case memoViewCellCount
    }
    
    @IBOutlet weak var clearScrollView: UIScrollView!
    @IBOutlet weak var clearScreen: UIButton!
    @IBOutlet weak var memoView: UITableView!
    
    private var memoTextView: UITextView!
    private var decideButton: UIButton!
    
    private var memoViewHeight: CGFloat = 400
    
    weak var delegate: MemoViewDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        memoView.delegate   = self
        memoView.dataSource = self
        memoView.isEditing = false
        memoView.separatorStyle = .none
        memoView.isScrollEnabled = false
        memoView.allowsSelection = false
        
        memoTextView = UITextView()
        memoTextView.font = UIFont.systemFont(ofSize: 20)
        memoTextView.layer.cornerRadius = 10
        memoTextView.layer.borderWidth = 0.5
        memoTextView.layer.borderColor = UIColor.lightGray.cgColor
        memoTextView.delegate = self
        
        clearScreen.addTarget(self, action: #selector(returnScreen(_:)), for: .allTouchEvents)
        
        decideButton = UIButton()
        decideButton.setTitle("OK", for: .normal)
        decideButton.titleLabel?.textColor = UIColor.white
        decideButton.layer.cornerRadius = 10
        decideButton.backgroundColor = UIColor.blue
        decideButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        decideButton.addTarget(self, action: #selector(setMemo(_:)), for: .touchDown)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        memoView.frame = CGRect(x: 0, y: self.view.frame.height - memoViewHeight, width: self.view.frame.width, height: memoViewHeight)
    }
    
    @objc func setMemo(_ button: UIButton){
        delegate?.getMemo(memoTextView.text)
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func returnScreen(_ button: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }

}

extension MemoViewController: UITextViewDelegate{
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        return true
    }
}

extension MemoViewController: UITableViewDelegate, UITableViewDataSource{
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return memoViewCell.memoViewCellCount.rawValue
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "memoViewCell", for: indexPath)
        
        let marginX: CGFloat = 20
        
        switch indexPath.row{
        case memoViewCell.title.rawValue:
            let label = UILabel(frame: CGRect(x: marginX, y: marginX * 2 / 3, width: 100, height: 20))
            label.font = UIFont.boldSystemFont(ofSize: 20)
            label.text = "メモ"
            cell.addSubview(label)
            break
        case memoViewCell.memo.rawValue:
            memoTextView.frame = CGRect(x: marginX, y: marginX / 3, width: self.view.frame.width - marginX * 2, height: 300 - marginX * 2)
            cell.contentView.addSubview(memoTextView)
            break
        case memoViewCell.decide.rawValue:
            decideButton.frame = CGRect(x: marginX, y: 20, width: self.view.frame.width - marginX * 2, height: 50)
            cell.contentView.addSubview(decideButton)
            break
        default:
            break
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case memoViewCell.title.rawValue:
            return 40
        case memoViewCell.memo.rawValue:
            return 270
        case memoViewCell.decide.rawValue:
            return 90
        default:
            return 0
        }
    }
    
}
