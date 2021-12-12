//
//  RoundedView.swift
//  NewsApp
//
//  Created by melike ertaş on 8.12.2021.
//

import UIKit

class RoundedView: UIView {

    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.cornerRadius = 6
        self.layer.shadowRadius = 6
        self.layer.shadowOffset = .zero
        self.layer.shadowOpacity = 0.3
        self.layer.shadowColor = UIColor.lightGray.cgColor
        self.layer.borderColor = UIColor.lightGray.cgColor
//        self.layer.borderWidth = 1
//        self.contentMode = .scaleAspectFill
        

    }

}
