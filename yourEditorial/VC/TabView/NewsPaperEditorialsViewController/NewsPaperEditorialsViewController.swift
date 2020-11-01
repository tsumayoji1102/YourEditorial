//
//  NewsPaperEditorialsViewController.swift
//  yourEditorial
//
//  Created by 塩見陵介 on 2020/10/19.
//

import UIKit
import PKHUD

final class NewsPaperEditorialsViewController: UIViewController {

    @IBOutlet weak var editorialView: UITableView!
    
    private var nationWideNewsPapers: Array<NewsPaper> = []
    private var localNewsPapers:  Array<NewsPaper> = []
    private var blockNewsPapers:  Array<NewsPaper> = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        editorialView.delegate = self
        editorialView.dataSource = self
        editorialView.tableFooterView = UIView()
        
        nationWideNewsPapers = Constraints.newsPapers.filter{ newspaper in
            return newspaper.group == NewsPaper.groups.nationWide
        }
        blockNewsPapers = Constraints.newsPapers.filter{ newspaper in
            return newspaper.group == NewsPaper.groups.block
        }
        localNewsPapers = Constraints.newsPapers.filter{ newspaper in
            return newspaper.group == NewsPaper.groups.local
        }
        
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        editorialView.frame = self.view.bounds
    }
}

extension NewsPaperEditorialsViewController: UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return NewsPaper.groups.groupsCount.rawValue
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header: UIView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 60))
        header.backgroundColor = UIColor.gray
        
        let label: UILabel = UILabel(frame: CGRect(x: 20, y: 5, width: 200, height: 30))
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textColor = UIColor.white
        header.addSubview(label)
        switch section {
        case NewsPaper.groups.nationWide.rawValue:
            label.text = "全国紙"
            break
        case NewsPaper.groups.block.rawValue:
            label.text = "ブロック紙"
            break
        case NewsPaper.groups.local.rawValue:
            label.text = "地方紙(47NEWS)"
        default:
            break
        }
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case NewsPaper.groups.nationWide.rawValue:
            return nationWideNewsPapers.count
        case NewsPaper.groups.block.rawValue:
            return blockNewsPapers.count
        case NewsPaper.groups.local.rawValue:
            return localNewsPapers.count
        default:
            return 0
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "newsPaperEditorialCell",for: indexPath)
        for subView in cell.contentView.subviews{
            subView.removeFromSuperview()
        }
        
        let titleLabel: UILabel = UILabel(frame: CGRect(x: 30, y: 15, width: 120, height: 30))
        
        var newsPaper: NewsPaper
        switch indexPath.section {
        case NewsPaper.groups.nationWide.rawValue:
            newsPaper = nationWideNewsPapers[indexPath.row]
        case NewsPaper.groups.block.rawValue:
            newsPaper = blockNewsPapers[indexPath.row]
        case NewsPaper.groups.local.rawValue:
            newsPaper = localNewsPapers[indexPath.row]
        default:
            newsPaper = NewsPaper(name: "", url: "", group: NewsPaper.groups.nationWide)
        }
        
        titleLabel.text = newsPaper.name
        cell.contentView.addSubview(titleLabel)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let parentContoller = self.parent as! HomeViewController
        let webVC: WebViewController! = self.storyboard?.instantiateViewController(identifier: "webKitViewController")
        
        var newsPaper: NewsPaper
        switch indexPath.section {
        case NewsPaper.groups.nationWide.rawValue:
            newsPaper = nationWideNewsPapers[indexPath.row]
        case NewsPaper.groups.block.rawValue:
            newsPaper = blockNewsPapers[indexPath.row]
        case NewsPaper.groups.local.rawValue:
            newsPaper = localNewsPapers[indexPath.row]
        default:
            newsPaper = NewsPaper(name: "", url: "", group: NewsPaper.groups.nationWide)
        }
        
        webVC!.newsPaper = newsPaper
        
        parentContoller.show(webVC!, sender: nil)
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        
    }
    
    
    
}
