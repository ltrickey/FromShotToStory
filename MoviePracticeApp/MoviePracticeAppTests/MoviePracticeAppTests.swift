//
//  MoviePracticeAppTests.swift
//  MoviePracticeAppTests
//
//  Created by Lynn Trickey on 7/3/17.
//  Copyright © 2017 Lynn Trickey. All rights reserved.
//

import XCTest
@testable import MoviePracticeApp

class MoviePracticeAppTests: XCTestCase {
    
   //MARK: Shot Class Tests
    
    // confirm it returns a Shot object with good data
    func testShotInitializationSucceeds() {
        
        // Shot with no photo or video
        let noPhotoShot = Shot.init(name: "Close Up", photo: nil, video: nil, description: "A close up shot")
        XCTAssertNotNil(noPhotoShot)
        
        // Shot with just video string
        let videoShot = Shot.init(name: "Close Up", photo: nil, video: "string.nowhere", description: "A close up shot")
        XCTAssertNotNil(videoShot)
        
    }
    
    func testShotInitializationFails() {
        // Shot with no name should return nil
        let noNameShot = Shot.init(name: "", photo: nil, video: nil, description: "A close up shot")
        XCTAssertNil(noNameShot)
        
        // Shot with no desc should return nil
        let noDescShot = Shot.init(name: "No Description", photo: nil, video: nil, description: "")
        XCTAssertNil(noDescShot)
        
        //Shot should have EITHER photo or Video, not both?  TO WRITE IN FUTURE. 
    }
    
    
    //MARK: Take Class Tests
    
    func testTakeInitializationSucceeds() {
        
        let url = URL(string: "https://www.apple.com")
        let thumbnail = UIImage(named: "CloseUpShot" )
        
        // Take created with no thumbnail.
        let noThumbnail = Take.init(url: url!, thumbnail: nil)
        XCTAssertNotNil(noThumbnail)
        
        // Shot with just video string
        let both = Take.init(url: url!, thumbnail: thumbnail)
        XCTAssertNotNil(noThumbnail)
        XCTAssertNotNil(both)
        
    }

    
}
