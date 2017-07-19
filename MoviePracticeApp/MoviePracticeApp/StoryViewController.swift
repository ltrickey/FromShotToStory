//
//  StoryViewController.swift
//  MoviePracticeApp
//
//  Created by Lynn Trickey on 7/18/17.
//  Copyright © 2017 Lynn Trickey. All rights reserved.
//

import UIKit

class StoryViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
    
    let shots = ["Close Up", "Establishing"]
    let images = ["closeUpShot", "establishing"]

    @IBOutlet weak var shotTypesCollectionView: UICollectionView!
    
    @IBOutlet weak var selectStoryTextField: UITextField!
    
    @IBOutlet weak var selectStoryPicker: UIPickerView!
    
    @IBOutlet weak var selectShotsLabel: UILabel!
    @IBOutlet weak var selectShotsExample: UILabel!
    @IBOutlet weak var selectShotsEncouragement: UILabel!
    
    @IBOutlet weak var firstShotPickerView: UIPickerView!
    @IBOutlet weak var firstShotTextField: UITextField!
    @IBOutlet weak var firstShotImageView: UIImageView!
    
    var list = ["", "Jess is having a terrible day.", "Dustin is enjoying the beautiful weather.", "Lila gets distracted.","A new school is very scary", "Sleep is my favorite activity", "Julia is trying to impress her teacher so she can get an A in class.", "Dylan can’t wait for school to be over so he can go to Disneyland."]
    
    var examples = ["", "An insert shot of Jess's foot stepping in some mud.", "A tilt shot from the beautiful sky to down to Dustin's smiling face to show him enjohing the weather.", "A Point of View Shot of point of what is distracting Lila.", "A tracking shot of someone walking down the hall at a new school.", "A close up of someone not being able to keep their eyes open.",  "An over the shoulder shot as Julia turns in her paper to her teacher.", "An extreme close up of dylan's eyes as he watches the clock."]

    override func viewDidLoad() {
        super.viewDidLoad()

        // story stuff
        self.selectStoryPicker.isHidden = true
        self.selectShotsLabel.isHidden = true
        self.selectShotsExample.isHidden = true
        self.selectShotsEncouragement.isHidden = true
        
        //shot view stuff
        self.firstShotTextField.isHidden = true
        self.firstShotPickerView.isHidden = true
        self.firstShotImageView.isHidden = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    public func numberOfComponents(in pickerView: UIPickerView) -> Int{
        return 1
    }
    
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        
        if pickerView == selectStoryPicker {
           return list.count
        } else {
        return shots.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        self.view.endEditing(true)
        
        if pickerView == selectStoryPicker {
            return list[row]
        } else {
            return shots[row]
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if pickerView == selectStoryPicker {
            self.selectStoryTextField.text = self.list[row]
            self.selectStoryPicker.isHidden = true
            
            if row != 0 {
                self.selectShotsLabel.isHidden = false
                self.selectShotsExample.isHidden = false
                self.selectShotsEncouragement.isHidden = false
                self.selectShotsExample.text = examples[row]
                self.firstShotTextField.isHidden = false
            }
        } else {
            self.firstShotPickerView.isHidden = true
            self.firstShotImageView.isHidden = false
            self.firstShotImageView.image = UIImage(named: images[row])
        }
        
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == self.selectStoryTextField {
            self.selectStoryPicker.isHidden = false
            self.selectShotsLabel.isHidden = true
            self.selectShotsExample.isHidden = true
            //if you dont want the users to se the keyboard type:
            
            textField.endEditing(true)
            
        } else if textField == self.firstShotTextField {
            self.firstShotPickerView.isHidden = false
            self.firstShotImageView.isHidden = true
            //if you dont want the users to se the keyboard type:
            
            textField.endEditing(true)
        }
        
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
