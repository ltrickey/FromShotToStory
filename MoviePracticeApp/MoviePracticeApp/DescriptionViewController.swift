//
//  DescriptionViewController.swift
//  MoviePracticeApp
//
//  Created by Lynn Trickey on 7/26/17.
//  Copyright © 2017 Lynn Trickey. All rights reserved.
//

import UIKit

class DescriptionViewController: UIViewController {

    // MARK - Properties
    @IBOutlet weak var purposeLabel: UILabel!
    @IBOutlet weak var instructionsLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        purposeLabel.layer.cornerRadius = 10; // this value vary as per your desire
        purposeLabel.clipsToBounds = true
        instructionsLabel.layer.cornerRadius = 10; // this value vary as per your desire
        instructionsLabel.clipsToBounds = true

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
