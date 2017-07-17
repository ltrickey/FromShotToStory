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
    let gif: String? // using Youtube API?  String or no?
    let description: String
    var tried: Bool
    
    //MARK: Initialization
    
    init?(name: String, photo: UIImage?, gif: String?, description: String) {
        
        // return nill if no name or description
        guard !name.isEmpty else { return nil }
        
        guard !description.isEmpty else { return nil }
        
        
        self.name = name
        self.photo = photo
        self.gif = gif
        self.description = description
        self.tried = false
    }
    
}
