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
}
