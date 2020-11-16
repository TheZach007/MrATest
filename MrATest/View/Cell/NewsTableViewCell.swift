//
//  NewsTableViewCell.swift
//  MrATest
//
//  Created by Kevin Fachal on 16/11/20.
//

import UIKit

class NewsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var newsImage: UIImageView!
    @IBOutlet weak var newsTitleLabel: UILabel!
    @IBOutlet weak var newsDescLabel: UILabel!
    @IBOutlet weak var newsAuthorLabel: UILabel!
    @IBOutlet weak var newsDateLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
