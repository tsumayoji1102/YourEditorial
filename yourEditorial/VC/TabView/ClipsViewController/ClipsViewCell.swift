//
//  ClipsViewCell.swift
//  yourEditorial
//
//  Created by 塩見陵介 on 2020/11/19.
//

import UIKit

class ClipsViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel:     UILabel!
    @IBOutlet weak var newsPaperLabel: UILabel!
    @IBOutlet weak var dateLabel:      UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        titleLabel.frame = CGRect(x: 15, y: 15, width: self.contentView.frame.width - 60, height: 20)
        titleLabel.font = UIFont.boldSystemFont(ofSize: 18)
        
        newsPaperLabel.frame = CGRect(x: 20, y: self.contentView.frame.height - 40, width: 100, height: 15)
        newsPaperLabel.font = UIFont.systemFont(ofSize: 15)
        dateLabel.frame = CGRect(x: self.contentView.frame.width - 160, y: self.contentView.frame.height - 40, width: 130, height: 15)
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
        
        let createdAt = DateFormat.getDateyyyyMMddToString(date: clip.createdAt!)
        self.dateLabel.text = createdAt
    }

}
