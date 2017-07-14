//
//  Take.swift
//  MoviePracticeApp
//
//  Created by Lynn Trickey on 7/11/17.
//  Copyright © 2017 Lynn Trickey. All rights reserved.
//

import UIKit
import os.log

class Take :NSObject, NSCoding {
    
    //MARK: Properties
    
    let localid: String
    var thumbnail: UIImage? = nil
    
    init(localid: String, thumbnail: UIImage?) {
        self.localid = localid
        self.thumbnail = thumbnail
    }
    
    
    //MARK: Types
    struct PropertyKey {
        static let localid = "localid"
        static let thumbnail = "thumbnail"
    }
    
    //MARK: NSCoding
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(localid, forKey: PropertyKey.localid)
        aCoder.encode(thumbnail, forKey: PropertyKey.thumbnail)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        guard let localid = aDecoder.decodeObject(forKey: PropertyKey.localid) as? String else {
            os_log("Unable to decode the local ID for a Take object.", log: OSLog.default, type: .debug)
            return nil
        }
        
        let thumbnail = aDecoder.decodeObject(forKey: PropertyKey.thumbnail) as? UIImage
        
        // Must call designated initializer.
        self.init(localid: localid, thumbnail:thumbnail)

    }
}
