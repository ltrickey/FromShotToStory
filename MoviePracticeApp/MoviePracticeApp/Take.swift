//
//  Take.swift
//  MoviePracticeApp
//
//  Created by Lynn Trickey on 7/11/17.
//  Copyright © 2017 Lynn Trickey. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation

class Take {
    
    //MARK: Properties
    let url: URL
    let thumbnail: UIImage?
    
    //MARK: initialization
    
    init(url: URL, thumbnail: UIImage?) {
        
        self.url = url
        self.thumbnail = thumbnail
    }
    
}
