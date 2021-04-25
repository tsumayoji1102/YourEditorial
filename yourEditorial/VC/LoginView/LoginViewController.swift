//
//  LoginViewController.swift
//  yourEditorial
//
//  Created by 塩見陵介 on 2021/04/24.
//

import UIKit

class LoginViewController: UIViewController {
    
    enum LoginViewTag: Int {
        case IdField = 0
        case passwordField
        case decide
        case guest
        case google
        case twitter
        case facebook
        case tagCount
    }

    @IBOutlet weak private var loginView: UITableView!
    
    private var loginIdLabel:        UILabel!
    private var loginIdField:        UITextField!
    private var loginPasswordLabel:  UILabel!
    private var loginPasswordField:  UITextField!
    private var loginButton:         UIButton!
    private var guestButton:         UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.systemGroupedBackground
        
        loginView.delegate = self
        loginView.dataSource = self
        loginView.isScrollEnabled = false
        loginView.allowsSelection = false
        
        let labelDefaultFont = UIFont.boldSystemFont(ofSize: 15)
        let textFieldDefaultFont = UIFont.boldSystemFont(ofSize: 20)
        
        loginIdField = UITextField()
        loginIdField.font = textFieldDefaultFont
        loginIdField.backgroundColor = UIColor.systemGray
        loginIdLabel = UILabel()
        loginIdLabel.text = "ログインID"
        loginIdLabel.font = labelDefaultFont
        
        loginPasswordField = UITextField()
        loginPasswordField.font = textFieldDefaultFont
        loginPasswordField.backgroundColor = UIColor.systemGray
        loginPasswordField.isSecureTextEntry = true
        loginPasswordLabel = UILabel()
        loginPasswordLabel.text = "パスワード"
        loginPasswordLabel.font = labelDefaultFont
        
        loginButton = UIButton()
        loginButton.setTitle("ログイン", for: .normal)
        loginButton.backgroundColor = .systemBlue
        loginButton.titleLabel?.textColor = .white
        loginButton.addTarget(self, action: #selector(tapLoginButton(_:)), for: .allTouchEvents)
        
        guestButton = UIButton()
        guestButton.setTitle("ゲストで登録", for: .normal)
        guestButton.titleLabel?.textColor = .systemBlue
        
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        loginView.frame = CGRect(x: 50, y: 50, width: self.view.frame.width - 50 * 2, height: self.view.frame.height - 50 * 2)
    }
    
    @objc func tapLoginButton(_ :UIButton){
        let mainNaviVC = self.storyboard?.instantiateViewController(identifier: "HomeNaviVC") as! HomeNavigationController
        self.present(mainNaviVC, animated: true, completion: nil)
    }
}

extension LoginViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return LoginViewTag.tagCount.rawValue
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "LoginViewCell", for: indexPath)
        
        let cellWidth = loginView.frame.width
        
        switch indexPath.row {
        case LoginViewTag.IdField.rawValue:
            loginIdLabel.frame = CGRect(x: 25, y: 10, width: 100, height: 20)
            loginIdField.frame = CGRect(x: 25, y: loginIdLabel.frame.maxY + 10, width: cellWidth - 25 * 2, height: 40)
            cell.contentView.addSubview(loginIdLabel)
            cell.contentView.addSubview(loginIdField)
            break
        case LoginViewTag.passwordField.rawValue:
            loginPasswordLabel.frame = CGRect(x: 25, y: 10, width: 100, height: 20)
            loginPasswordField.frame = CGRect(x: 25, y: loginPasswordLabel.frame.maxY + 10, width: cellWidth - 25 * 2, height: 40)
            cell.contentView.addSubview(loginPasswordLabel)
            cell.contentView.addSubview(loginPasswordField)
            break
        case LoginViewTag.decide.rawValue:
            loginButton.frame = CGRect(x: 50, y: 10, width: cellWidth - 50 * 2, height: 50)
            cell.contentView.addSubview(loginButton)
            break
        case LoginViewTag.guest.rawValue:
            guestButton.frame = CGRect(x: 30, y: 10, width: cellWidth - 30 * 2, height: 30)
            cell.contentView.addSubview(guestButton)
            break
        case LoginViewTag.google.rawValue:
            break
        case LoginViewTag.twitter.rawValue:
            break
        case LoginViewTag.facebook.rawValue:
            break
        default:
            break
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case LoginViewTag.IdField.rawValue:
            return 100
        case LoginViewTag.passwordField.rawValue:
            return 100
        case LoginViewTag.decide.rawValue:
            return 70
        case LoginViewTag.guest.rawValue:
            return 50
        case LoginViewTag.google.rawValue:
            return 80
        case LoginViewTag.twitter.rawValue:
            return 80
        case LoginViewTag.facebook.rawValue:
            return 80
        default:
            return 0
        }
    }
    
    
}
