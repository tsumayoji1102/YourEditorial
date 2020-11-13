//
//  ClipingViewController.swift
//  yourEditorial
//
//  Created by 塩見陵介 on 2020/11/07.
//

import UIKit

class ClipingViewController: UIViewController {

    @IBOutlet weak var clipingView: UITableView!
    var clip: Clip!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        clipingView.delegate   = self
        clipingView.dataSource = self
        clipingView.isEditing = false
        clipingView.isScrollEnabled = false
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        clipingView.frame = CGRect(x: 0, y: self.view.frame.height / 2, width: self.view.frame.width, height: self.view.frame.height / 2)
    }
}

extension ClipingViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.view.frame.height / 6
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "clipingViewCell", for: indexPath)
        
        return cell
    }
}
