//
//  LoginViewController.swift
//  yourEditorial
//
//  Created by 塩見陵介 on 2021/04/24.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak private var loginView: UITableView!
    
    private var loginIdLabel:       UILabel!
    private var loginIdField:       UITextField!
    private var loginPasswordLabel: UILabel!
    private var loginPasswordField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loginView.delegate = self
        loginView.dataSource = self
    }
}

extension LoginViewController:UITableViewDelegate, UITableViewDataSource{
    
}
