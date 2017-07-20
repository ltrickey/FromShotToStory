//
//  StoryViewController.swift
//  MoviePracticeApp
//
//  Created by Lynn Trickey on 7/18/17.
//  Copyright © 2017 Lynn Trickey. All rights reserved.
//

import UIKit
import DropDown
import CSV

class StoryViewController: UIViewController {
    
    var shotNames = [String]()
    var imageNames = [String]()
    
    @IBOutlet weak var selectShotsLabel: UILabel!
    @IBOutlet weak var selectShotsExample: UILabel!
    @IBOutlet weak var selectShotsEncouragement: UILabel!
    
    @IBOutlet weak var storyToTryButton: UIBarButtonItem!
    
    
    @IBOutlet weak var shotsStackView: UIStackView!
    
    @IBOutlet weak var firstShotDropDown: UIBarButtonItem!
    @IBOutlet weak var secondShotDropDown: UIBarButtonItem!
    @IBOutlet weak var thirdShotDropDown: UIBarButtonItem!
    @IBOutlet weak var fourthShotDropDown: UIBarButtonItem!
    
    @IBOutlet weak var firstShotImageView: UIImageView!
    @IBOutlet weak var secondShotImageView: UIImageView!
    @IBOutlet weak var thirdShotImageView: UIImageView!
    @IBOutlet weak var fourthShotImageView: UIImageView!
    
    let storyDropDown = DropDown()

    let firstShotDropDownMenu = DropDown()
    let secondShotDropDownMenu = DropDown()
    let thirdShotDropDownMenu = DropDown()
    let fourthShotDropDownMenu = DropDown()
    
    var stories = ["", "Jess is having a terrible day.", "Dustin is enjoying the beautiful weather.", "Lila gets distracted.","A new school is very scary", "Sleep is my favorite activity", "Julia is trying to impress her teacher so she can get an A in class.", "Dylan can’t wait for school to be over so he can go to Disneyland."]
    
    var examples = ["", "An insert shot of Jess's foot stepping in some mud.", "A tilt shot from the beautiful sky to down to Dustin's smiling face to show him enjohing the weather.", "A Point of View Shot of point of what is distracting Lila.", "A tracking shot of someone walking down the hall at a new school.", "A close up of someone not being able to keep their eyes open.",  "An over the shoulder shot as Julia turns in her paper to her teacher.", "An extreme close up of dylan's eyes as he watches the clock."]

    override func viewDidLoad() {
        super.viewDidLoad()
        loadShotData()
        
        shotsStackView.isHidden = true
        
        // story stuff
        self.selectShotsLabel.isHidden = true
        self.selectShotsExample.isHidden = true
        self.selectShotsEncouragement.isHidden = true
        
        //shot view stuff
        setupStoryDropDownMenu()
        setupfirstShotDropDownMenu()
        setupSecondShotDropDownMenu()
        setupThirdShotDropDownMenu()
        setupFourthShotDropDownMenu()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // Attach buttons to open drop downs    
    @IBAction func openStoryDropDown(_ sender: Any) {
        storyDropDown.show()
    }
    @IBAction func openFirstDropDown(_ sender: Any) {
        firstShotDropDownMenu.show()
    }
    @IBAction func openSecondDropDown(_ sender: Any) {
        secondShotDropDownMenu.show()
    }
    @IBAction func openThirdDropDown(_ sender: Any) {
        thirdShotDropDownMenu.show()
    }
    @IBAction func openFourthDropDown(_ sender: Any) {
        fourthShotDropDownMenu.show()
    }

    
    //Setup Drop downs
    
    func setupStoryDropDownMenu() {
        // The view to which the drop down will appear on
        
        storyDropDown.anchorView = storyToTryButton as UIBarButtonItem
        
        // The list of items to display. Can be changed dynamically
        storyDropDown.dataSource = self.stories
        
        // Action triggered on selection
        storyDropDown.selectionAction = { [unowned self] (index, item) in
            self.storyToTryButton.title = item
            self.selectShotsExample.text = self.examples[index]

            self.selectShotsLabel.isHidden = false
            self.selectShotsExample.isHidden = false
            self.selectShotsEncouragement.isHidden = false
            self.shotsStackView.isHidden = false
        }
       
    }
    
    func setupfirstShotDropDownMenu() {
        // The view to which the drop down will appear on
        firstShotDropDownMenu.anchorView = firstShotDropDown as UIBarButtonItem
        
        // The list of items to display. Can be changed dynamically
        firstShotDropDownMenu.dataSource = self.shotNames

        // Action triggered on selection
        firstShotDropDownMenu.selectionAction = { [unowned self] (index, item) in
            self.firstShotDropDown.title = item
            self.firstShotImageView.image = UIImage(named: self.imageNames[index])
            self.firstShotImageView.layer.setValue(item, forKey: "shot")
            
            //setup tap gesture recognizer on Image
            self.firstShotImageView.isUserInteractionEnabled = true
            //now you need a tap gesture recognizer
            //note that target and action point to what happens when the action is recognized.
            let firstTapRecognizer = UITapGestureRecognizer(target: self,  action:#selector(self.imageTapped(_:)))
            
            //Add the recognizer to your view.
            self.firstShotImageView.addGestureRecognizer(firstTapRecognizer)
            self.firstShotImageView.isHidden = false
        }
    }
    
    func setupSecondShotDropDownMenu() {
        // The view to which the drop down will appear on
        secondShotDropDownMenu.anchorView = secondShotDropDown as UIBarButtonItem
            
        // The list of items to display. Can be changed dynamically
        secondShotDropDownMenu.dataSource = self.shotNames
            
        // Action triggered on selection
        secondShotDropDownMenu.selectionAction = { [unowned self] (index, item) in
            self.secondShotDropDown.title = item
            self.secondShotImageView.image = UIImage(named: self.imageNames[index])
            self.secondShotImageView.layer.setValue("second", forKey: "shot")
       
            //setup tap gesture recognizer on Image
            self.secondShotImageView.isUserInteractionEnabled = true
            //now you need a tap gesture recognizer
            //note that target and action point to what happens when the action is recognized.
            let secondTapRecognizer = UITapGestureRecognizer(target: self, action:#selector(self.imageTapped(_:)))
            //Add the recognizer to your view.
            self.secondShotImageView.addGestureRecognizer(secondTapRecognizer)
            
            self.secondShotImageView.isHidden = false
        }
        
    }
        
        func setupThirdShotDropDownMenu() {
            // The view to which the drop down will appear on
            thirdShotDropDownMenu.anchorView = thirdShotDropDown as UIBarButtonItem
            
            // The list of items to display. Can be changed dynamically
            thirdShotDropDownMenu.dataSource = self.shotNames
            
            // Action triggered on selection
            thirdShotDropDownMenu.selectionAction = { [unowned self] (index, item) in
                self.thirdShotDropDown.title = item
                self.thirdShotImageView.image = UIImage(named: self.imageNames[index])
                self.thirdShotImageView.layer.setValue("third", forKey: "shot")

                //setup tap gesture recognizer on Image
                self.thirdShotImageView.isUserInteractionEnabled = true
                //now you need a tap gesture recognizer
                //note that target and action point to what happens when the action is recognized.
                let thirdTapRecognizer = UITapGestureRecognizer(target: self, action:#selector(self.imageTapped(_:)))
                //Add the recognizer to your view.
                self.thirdShotImageView.addGestureRecognizer(thirdTapRecognizer)
                
                self.thirdShotImageView.isHidden = false
            }
            
        }
        
        func setupFourthShotDropDownMenu() {
            // The view to which the drop down will appear on
            fourthShotDropDownMenu.anchorView = fourthShotDropDown as UIBarButtonItem
            
            // The list of items to display. Can be changed dynamically
            fourthShotDropDownMenu.dataSource = self.shotNames
            
            // Action triggered on selection
            fourthShotDropDownMenu.selectionAction = { [unowned self] (index, item) in
                self.fourthShotDropDown.title = item
                self.fourthShotImageView.image = UIImage(named: self.imageNames[index])
                self.fourthShotImageView.layer.setValue("fourth", forKey: "shot")
                
                //setup tap gesture recognizer on Image
                self.fourthShotImageView.isUserInteractionEnabled = true
                //now you need a tap gesture recognizer
                //note that target and action point to what happens when the action is recognized.
                let fourthTapRecognizer = UITapGestureRecognizer(target: self, action:#selector(self.imageTapped(_:)))
                
                //Add the recognizer to your view.
                self.fourthShotImageView.addGestureRecognizer(fourthTapRecognizer)
                
                self.fourthShotImageView.isHidden = false
            }
            
        }
    
    //Image Tap Functions
    
    func imageTapped(_ sender: UITapGestureRecognizer) {
        print("an image was tapped!")
        print(sender.view?.layer.value(forKey: "shot"))
//        let picker = UIImagePickerController()
//        picker.delegate = self as! UIImagePickerControllerDelegate & UINavigationControllerDelegate
//        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
//        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: {
//            action in
//            picker.sourceType = .camera
//            self.present(picker, animated: true, completion: nil)
//        }))
//        alert.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: {
//            action in
//            picker.sourceType = .photoLibrary
//            self.present(picker, animated: true, completion: nil)
//        }))
//        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        
        let alert = UIAlertController(title: "iOScreator", message:
            "Choose Existing or Shoot new Take", preferredStyle: UIAlertControllerStyle.alert)
        
        
        let goToMyTakes : UIAlertAction = UIAlertAction(title: "Choose from My Takes", style: UIAlertActionStyle.default, handler: {(action:UIAlertAction!)-> Void in
            self.performSegue(withIdentifier: "My Takes", sender: sender)
        })
        
        alert.addAction(goToMyTakes)
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default,handler: nil))

        alert.popoverPresentationController?.sourceView = self.view
        alert.popoverPresentationController?.sourceRect = self.view.bounds
        // this is the center of the screen currently but it can be any point in the view
        self.present(alert, animated: true, completion: nil)
        
    }


    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
//    func prepare(for segue: UIStoryboardSegue, sender: UITapGestureRecognizer) {
//        if segue.identifier == "My Takes One" {
//
//            guard let myTakesCollectionViewController = segue.destination as? MyTakesCollectionViewController else {
//                fatalError("Unexpected destination: \(segue.destination)")
//            }
//            
//            print(self.shotNames[self.firstIndex])
//            myTakesCollectionViewController.shotName = self.shotNames[self.firstIndex]
//        }
//        
//
//    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: self)
        
        let sender = sender as! UITapGestureRecognizer
        let navController = segue.destination as! UINavigationController
        let myTakesCollectionViewController = navController.topViewController as! MyTakesCollectionViewController
        
        let shotName = sender.view?.layer.value(forKey: "shot")

        myTakesCollectionViewController.shotName = shotName as! String

        
//        guard let myTakesCollectionViewController = segue.destination as? MyTakesCollectionViewController else {
//            fatalError("Unexpected destination: \(segue.destination)")
//        }
//        
//        myTakesCollectionViewController.shotName = self.shotNames[self.firstIndex]
    }
    
    //Private method
    private func loadShotData() {
        
        //gets filepath of .csv file
        let filePath:String = Bundle.main.path(forResource: "shotData", ofType: "csv")!
        
        let stream = InputStream(fileAtPath: filePath)!
        let csv = try! CSVReader(stream: stream)
        
        while let row = csv.next() {
            
            shotNames.append(row[0])
            imageNames.append(row[1])
        }
    }
}

extension StoryViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
        //use image here!
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
}
