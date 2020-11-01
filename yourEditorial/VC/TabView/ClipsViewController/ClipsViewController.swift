//
//  ClipsViewController.swift
//  yourEditorial
//
//  Created by 塩見陵介 on 2020/10/26.
//

import UIKit
import RealmSwift

final class ClipsViewController: UIViewController {
    
    @IBOutlet weak var clipsView: UITableView!
    
    private var appDelegate: AppDelegate!
    private var viewModel: ClipsViewModel!
    private var clipList: Array<Clip> = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        appDelegate = UIApplication.shared.delegate as? AppDelegate
        let clipDao: ClipDao = appDelegate.daoFactory.getDao(daoRoute: DaoRoutes.clip) as! ClipDao
        viewModel = ClipsViewModel(clipDao: clipDao)
        
        clipsView.delegate = self
        clipsView.dataSource = self
        clipsView.tableFooterView = UIView()
    }
    
    override func viewWillAppear(_ animated: Bool){
        super.viewWillAppear(true)
        clipList = viewModel.getClips()
        
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        clipsView.frame = self.view.bounds
    }

}

extension ClipsViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "clipsViewCell",for: indexPath)
        
        return cell
    }
    
    
}
