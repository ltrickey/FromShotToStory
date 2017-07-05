//
//  Shot.swift
//  MoviePracticeApp
//
//  Created by Lynn Trickey on 7/5/17.
//  Copyright © 2017 Lynn Trickey. All rights reserved.
//

import UIKit

class Shot {
    
    //MARK: Properties
    // Making them constants b/c shouldn't be changed by kids.
    
    let name: String
    let photo: UIImage?
    let video: String? // using Youtube API?  String or no?
    let description: String
    
    
    //MARK: Initialization
    
    init(name: String, photo: UIImage?, video: String?, description: String) {
        
        self.name = name
        self.photo = photo
        self.video = video
        self.description = description
    }
    
}
