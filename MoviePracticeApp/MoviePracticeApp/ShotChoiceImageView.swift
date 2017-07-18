//
//  ShotChoiceImageView.swift
//  MoviePracticeApp
//
//  Created by Lynn Trickey on 7/18/17.
//  Copyright © 2017 Lynn Trickey. All rights reserved.
//

import UIKit

class ShotChoiceImageView: UIImageView {

    
    var lastLocation:CGPoint?
    var panRecognizer:UIPanGestureRecognizer?
    
    init(imageIcon: UIImage?, location: CGPoint) {
        super.init(image: imageIcon)
        self.isUserInteractionEnabled = true
        
        self.lastLocation = location
        self.panRecognizer = UIPanGestureRecognizer(target:self, action: Selector("detectPan:"))
        self.center = location
        self.gestureRecognizers = [panRecognizer!]
        self.frame = CGRect(x: location.x, y: location.y, width: 20.0, height: 30.0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
//        fatalError("init(coder:) has not been implemented")
    }
    
    func detectPan(recognizer:UIPanGestureRecognizer) {
        let translation  = recognizer.translation(in: self.superview!)
        let newX = (lastLocation?.x)! + translation.x
        let newY = (lastLocation?.y)! + translation.y
        self.center = CGPoint(x: newX, y: newY)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // Promote the touched view
        self.superview?.bringSubview(toFront: self)
        
        // Remember original location
        lastLocation = self.center
    }
    
}
