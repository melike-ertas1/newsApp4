//
//  FavoriteNewsTableViewCell.swift
//  NewsApp
//
//  Created by melike ertaş on 7.12.2021.
//

import UIKit

class FavoriteNewsTableViewCell: UITableViewCell {

    @IBOutlet var view: UIView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var newsImage: RoundedImageView!
    @IBOutlet var contentLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
