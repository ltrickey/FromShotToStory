//
//  StoryBoardViewController.swift
//  MoviePracticeApp
//
//  Created by Lynn Trickey on 7/18/17.
//  Copyright © 2017 Lynn Trickey. All rights reserved.
//

import UIKit

class StoryBoardViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    var location = CGPoint(x: 0, y: 0)
    
    @IBOutlet weak var firstShot: ShotChoiceImageView!
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch: UITouch! = touches.first as! UITouch
        
        location = touch.location(in: self.view)
        
        firstShot.center = location
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch: UITouch! = touches.first as! UITouch
        
        location = touch.location(in: self.view)
        
        firstShot.center = location

    }
    var imagePicker: UIImagePickerController!
//    var FirstShot:ShotChoiceImageView = ShotChoiceImageView(imageIcon: UIImage(named: "filmStrip"), location: CGPoint(x: 80, y: 330))

    
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.view.addSubview(FirstShotLocationA)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
        firstShot.center = CGPoint(x: 160, y: 330)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
