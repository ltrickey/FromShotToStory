//
//  ViewController.swift
//  MoviePracticeApp
//
//  Created by Lynn Trickey on 7/3/17.
//  Copyright © 2017 Lynn Trickey. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    //MARK: Properties
    
    @IBOutlet weak var shotNameLabel: UILabel!
    @IBOutlet weak var shotDescLabel: UILabel!

    @IBOutlet weak var shotImageView: UIImageView!
    
    //need to connect the TRY IT button to make an outlet.  Check the camera view to see how they did it. 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

