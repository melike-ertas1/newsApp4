//
//  NewsTableViewCell.swift
//  NewsApp
//
//  Created by melike ertaş on 7.12.2021.
//

import UIKit

class NewsTableViewCell: UITableViewCell {
 
    @IBOutlet var view: RoundedView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var newsImage: RoundedImageView!
    @IBOutlet var contentLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)


    }

}
