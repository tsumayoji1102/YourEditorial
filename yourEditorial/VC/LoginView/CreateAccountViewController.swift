//
//  CreateAccountPageViewController.swift
//  yourEditorial
//
//  Created by 塩見陵介 on 2021/06/20.
//

import UIKit

class CreateAccountViewController: UIViewController {
    
    enum TableViewTag: Int {
        case createAccount
        case sendAuth
    }
    
    enum CreateAccountTag: Int {
        case mailAddress
        case password
        case send
        case cellCount
    }
    
    enum SendAuthTag: Int {
        case sendAuthMessage
        case decide
        case cellCount
    }
    
    private var navigationBar:     UINavigationBar!
    private var createAccountView: UITableView!
    private var sendAuthView:      UITableView!
    
    private var sendAuthFlg = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationBar = UINavigationBar()
        navigationBar.backgroundColor = .systemGroupedBackground
        navigationBar.items = [UINavigationItem(title: "アカウント作成")]
        
        createAccountView = UITableView()
        createAccountView.delegate = self
        createAccountView.dataSource = self
        createAccountView.isScrollEnabled = !sendAuthFlg
        createAccountView.tag = TableViewTag.createAccount.rawValue
        
        sendAuthView = UITableView()
        sendAuthView.delegate = self
        sendAuthView.dataSource = self
        sendAuthView.isScrollEnabled = sendAuthFlg
        sendAuthView.tag = TableViewTag.sendAuth.rawValue
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        navigationBar.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 55)
        self.view.addSubview(navigationBar)
        
        let tableViewFrame = CGRect(x: 0, y: 55, width: self.view.frame.width, height: self.view.frame.height - 55)
        
        createAccountView.frame = tableViewFrame
        self.view.addSubview(createAccountView)
        
        sendAuthView.frame = tableViewFrame
        self.view.addSubview(sendAuthView)
    }
}

extension CreateAccountViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch tableView.tag {
        case TableViewTag.createAccount.rawValue:
            return CreateAccountTag.cellCount.rawValue
        case TableViewTag.sendAuth.rawValue:
            return SendAuthTag.cellCount.rawValue
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch tableView.tag {
        case TableViewTag.createAccount.rawValue:
            let cell = tableView.dequeueReusableCell(withIdentifier: "test", for: indexPath)
            return cell
        case TableViewTag.sendAuth.rawValue:
            let cell = tableView.dequeueReusableCell(withIdentifier: "test2", for: indexPath)
            return cell
        default:
            let cell = UITableViewCell()
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch tableView.tag {
        case TableViewTag.createAccount.rawValue:
            switch indexPath.row {
            case CreateAccountTag.mailAddress.rawValue:
                return 80
            case CreateAccountTag.password.rawValue:
                return 80
            case CreateAccountTag.send.rawValue:
                return 80
            default:
                return 0
            }
        case TableViewTag.sendAuth.rawValue:
            switch indexPath.row {
            case SendAuthTag.sendAuthMessage.rawValue:
                return 120
            case SendAuthTag.decide.rawValue:
                return 80
            default:
                return 0
            }
        default:
            return 0
        }
    }
}
