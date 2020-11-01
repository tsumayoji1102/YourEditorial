//
//  FavoriteEditorialViewController.swift
//  yourEditorial
//
//  Created by 塩見陵介 on 2020/10/26.
//

import UIKit

enum SortMode: Int{
    case createdAt = 0
    case newsPaper
}

final class FavoriteEditorialViewController: UIViewController {

    @IBOutlet weak var editorialView: UITableView!
    var sortMode: SortMode!
        
    override func viewDidLoad() {
        super.viewDidLoad()
            
        editorialView.delegate = self
        editorialView.dataSource = self
        editorialView.tableFooterView = UIView()
            
    }
        
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        editorialView.frame = self.view.bounds
    }
}

extension FavoriteEditorialViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
        
}
