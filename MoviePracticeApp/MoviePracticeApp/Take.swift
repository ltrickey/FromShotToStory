//
//  Take.swift
//  MoviePracticeApp
//
//  Created by Lynn Trickey on 7/11/17.
//  Copyright © 2017 Lynn Trickey. All rights reserved.
//

import UIKit
import os.log

class Take: NSObject {
    
    //MARK: Properties
    
    let url: URL
    let thumbnail: UIImage?
    
//    //MARK: Archiving Paths
//    
//    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
//    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("takes")
//    
//    //MARK: Types
//    struct PropertyKey {
//        static let url = "url"
//        static let thumbnail = "thumbnail"
//    }
    
    //MARK: initialization
    
    init(url: URL, thumbnail: UIImage?) {
        
//        super.init()
        self.url = url
        self.thumbnail = thumbnail
    }
    
 
//    
//    //MARK: NSCoding
//    
//    func encode(with aCoder: NSCoder) {
//        aCoder.encode(url, forKey: PropertyKey.url)
//        aCoder.encode(thumbnail, forKey: PropertyKey.thumbnail)
//    }
//    
//    required convenience init?(coder aDecoder: NSCoder) {
//        guard let url = aDecoder.decodeObject(forKey: PropertyKey.url) as? URL else {
//            os_log("Unable to decode the URL for a Take object.", log: OSLog.default, type: .debug)
//            return nil
//        }
//        
//        let thumbnail = aDecoder.decodeObject(forKey: PropertyKey.thumbnail) as? UIImage
//        
//        // Must call designated initializer.
//        self.init(url: url, thumbnail:thumbnail)
//
//    }
}
