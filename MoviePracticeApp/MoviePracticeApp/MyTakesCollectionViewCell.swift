//
//  MyTakesCollectionViewCell.swift
//  MoviePracticeApp
//
//  Created by Lynn Trickey on 7/10/17.
//  Copyright © 2017 Lynn Trickey. All rights reserved.
//

import UIKit

class MyTakesCollectionViewCell: UICollectionViewCell {
    
    //MARK: properties
    
    
    @IBOutlet weak var savedShotImageView: UIImageView?
    
    @IBOutlet weak var deleteButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        deleteButton.isHidden = true
        deleteButton.backgroundColor = UIColor.white

        // Add the UIButton to the collection view
        contentView.addSubview(deleteButton)

    }
    
}
