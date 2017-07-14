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
    
    
    @IBOutlet weak var savedShotImageView: UIImageView!
    
    @IBOutlet weak var deleteButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
//        // Create a UIButton
//        deleteButton = UIButton(frame: CGRect(x: frame.size.width/10, y: frame.size.width/16, width: frame.size.width/4, height: frame.size.width/4))
//        
////        // Set the UIButton's image property
////        deleteButtonImg = UIImage(named: "delete-icon")!
////        deleteButton.setImage(deleteButtonImg, forState: UIControlState.Normal)
//        
        deleteButton.isHidden = true
        deleteButton.backgroundColor = UIColor.white

        // Add the UIButton to the collection view
        contentView.addSubview(deleteButton)

    }
    
}
