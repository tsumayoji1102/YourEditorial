//
//  ClipsViewCell.swift
//  yourEditorial
//
//  Created by 塩見陵介 on 2020/11/19.
//

import UIKit

final class ClipsViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel:     UILabel!
    @IBOutlet weak var newsPaperLabel: UILabel!
    @IBOutlet weak var dateLabel:      UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        let size = self.contentView.frame
        titleLabel.frame = CGRect(x: 15, y: 15, width: size.width - 30, height: 20)
        titleLabel.font = UIFont.boldSystemFont(ofSize: 18)
        
        newsPaperLabel.frame = CGRect(x: 20, y: self.contentView.frame.height - 40, width: 100, height: 15)
        newsPaperLabel.font = UIFont.systemFont(ofSize: 15)
        dateLabel.frame = CGRect(x: size.width - 130, y: size.height - 40, width: 130, height: 15)
        dateLabel.textColor = UIColor.lightGray
        dateLabel.font = UIFont.systemFont(ofSize: 15)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setClip(clip: Clip){
        self.titleLabel.text     = clip.name
        self.newsPaperLabel.text = clip.newsPaper
        
        let createdAt = DateFormat.dateToString(date: clip.createdAt!, format: "yyyy年MM月dd日")
        self.dateLabel.text = createdAt
    }

}
