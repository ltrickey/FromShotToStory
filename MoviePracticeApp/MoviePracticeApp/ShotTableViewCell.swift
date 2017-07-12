//
//  ShotTableViewCell.swift
//  MoviePracticeApp
//
//  Created by Lynn Trickey on 7/5/17.
//  Copyright © 2017 Lynn Trickey. All rights reserved.
//

import UIKit

class ShotTableViewCell: UITableViewCell {
    
    //MARK: Properties
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var photoImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = UIColor.lightGray
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        self.backgroundColor = UIColor.gray
    }

}
