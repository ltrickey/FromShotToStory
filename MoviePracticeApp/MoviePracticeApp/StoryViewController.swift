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
import Photos
import MobileCoreServices
import AVKit

class StoryViewController: UIViewController, UINavigationControllerDelegate {
    
    var shotNames = [String]()
    var imageNames = [String]()
    
    var takes = [Take]()
    
    //getting everything from local data
    var data = DataStore.myTakes
    
    // assets for editing.
    var firstTake: AVAsset?
    var secondTake: AVAsset?
    var thirdTake: AVAsset?
    var fourthTake: AVAsset?
    
    var takeArray: [AVAsset]?
    var videoSize: CGSize = CGSize(width: 0.0, height: 0.0)

    @IBOutlet var myStoriesButton: UIBarButtonItem!

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var putItTogetherButton: UIButton!
    
    @IBOutlet weak var selectShotsLabel: UILabel!
    
    @IBOutlet var instructionsStackView: UIStackView!
    
    @IBOutlet var largeStoryLabel: UILabel!
    @IBOutlet var exampleStackView: UIStackView!
    @IBOutlet var exampleOne: UILabel!
    @IBOutlet var exampleTwo: UILabel!
    @IBOutlet var exampleThree: UILabel!
    @IBOutlet var exampleFour: UILabel!
    
    @IBOutlet weak var selectShotsEncouragement: UILabel!
    
    @IBOutlet weak var storyToTryButton: UIBarButtonItem!
    
    @IBOutlet weak var shotsStackView: UIStackView!
    
    @IBOutlet weak var firstShotDropDown: UIBarButtonItem!
    @IBOutlet weak var secondShotDropDown: UIBarButtonItem!
    @IBOutlet weak var thirdShotDropDown: UIBarButtonItem!
    @IBOutlet weak var fourthShotDropDown: UIBarButtonItem!
    
    //image views
    @IBOutlet weak var firstShotImageView: UIImageView!
    @IBOutlet weak var secondShotImageView: UIImageView!
    @IBOutlet weak var thirdShotImageView: UIImageView!
    @IBOutlet weak var fourthShotImageView: UIImageView!
    
    let storyDropDown = DropDown()

    let firstShotDropDownMenu = DropDown()
    let secondShotDropDownMenu = DropDown()
    let thirdShotDropDownMenu = DropDown()
    let fourthShotDropDownMenu = DropDown()
    
    var stories = ["Jess is having a terrible day", "Dustin is enjoying the beautiful weather", "Lila gets distracted","A new school is very scary", "Sleep is my favorite activity", "Julia is trying to impress her teacher so she can get an A in class", "Dylan can’t wait for school to be over so he can go to Disneyland"]
    
    var examples = [[""]]


    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if data.allTakesSaved["Story"] == nil || data.allTakesSaved["Story"]! == [] {
            self.navigationItem.rightBarButtonItem = nil
        } else {
            self.navigationItem.rightBarButtonItem = self.myStoriesButton
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadShotData()
        loadStoryExamples()
        
        storyToTryButton.setTitleTextAttributes([ NSFontAttributeName: UIFont(name: "Arial Rounded MT Bold", size: 20)!], for: UIControlState.normal)

        
        // hide everything
        instructionsStackView.isHidden = true
        shotsStackView.isHidden = true
        exampleStackView.isHidden = true
        selectShotsEncouragement.isHidden = true
        
        activityIndicator.isHidden = true
        putItTogetherButton.isHidden = true
        
        //set up drop downs
        setupStoryDropDownMenu()
        setupfirstShotDropDownMenu()
        setupSecondShotDropDownMenu()
        setupThirdShotDropDownMenu()
        setupFourthShotDropDownMenu()
        
        // appearance
        DropDown.appearance().textFont = UIFont.systemFont(ofSize: 20)
        
        
        //setup labels on image views
        
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
            
            //show rest of page
            self.instructionsStackView.isHidden = false
            self.shotsStackView.isHidden = false
            self.exampleStackView.isHidden = false
            self.selectShotsEncouragement.isHidden = false
            
            //fill out labels
            self.storyToTryButton.title = item
            self.largeStoryLabel.text = item
            self.exampleOne.text = self.examples[index][1]
            self.exampleTwo.text = self.examples[index][2]
            self.exampleThree.text = self.examples[index][3]
            self.exampleFour.text = self.examples[index][4]

            self.shotsStackView.isHidden = false
            self.putItTogetherButton.isHidden = false
        }
    }
    
    func setupfirstShotDropDownMenu() {
        // The view to which the drop down will appear on
        firstShotDropDownMenu.anchorView = firstShotDropDown as UIBarButtonItem
        
        // The list of items to display. Can be changed dynamically
        firstShotDropDownMenu.dataSource = self.shotNames

        // Action triggered on selection
        firstShotDropDownMenu.selectionAction = { [unowned self] (index, item) in
            self.firstTake = nil
            self.firstShotDropDown.title = item
            self.firstShotImageView.image = UIImage(named: self.imageNames[index])
            self.firstShotImageView.layer.setValue(item, forKey: "shot")
            self.firstShotImageView.layer.setValue("first", forKey: "sender")
            
            //setup tap gesture recognizer on Image
            self.firstShotImageView.isUserInteractionEnabled = true
            //now you need a tap gesture recognizer
            //note that target and action point to what happens when the action is recognized.
            let firstTapRecognizer = UITapGestureRecognizer(target: self,  action:#selector(self.imageTapped(_:)))
            
            //add label
            let height = self.firstShotImageView.bounds.size.height
            let width = self.firstShotImageView.bounds.size.width
            
            let label = UILabel(frame: CGRect(x: 0, y: (height - 30), width: width, height: 30))
            label.font = UIFont.boldSystemFont(ofSize: 20)
            
            // and set the text color & background
            label.textColor = .white
            label.backgroundColor = .gray
            
            label.textAlignment = .center
            label.text = "Click to Select Take"
            label.tag = 1
            
            self.firstShotImageView.addSubview(label)
            self.firstShotImageView.bringSubview(toFront: label)
            self.firstShotImageView.layer.borderWidth = 0.0;


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
            self.secondTake = nil
            self.secondShotDropDown.title = item
            self.secondShotImageView.image = UIImage(named: self.imageNames[index])
            self.secondShotImageView.layer.setValue(item, forKey: "shot")
            self.secondShotImageView.layer.setValue("second", forKey: "sender")
       
            //setup tap gesture recognizer on Image
            self.secondShotImageView.isUserInteractionEnabled = true
            //now you need a tap gesture recognizer
            //note that target and action point to what happens when the action is recognized.
            let secondTapRecognizer = UITapGestureRecognizer(target: self, action:#selector(self.imageTapped(_:)))
            
            //add label
            let height = self.secondShotImageView.bounds.size.height
            let width = self.secondShotImageView.bounds.size.width
            
            let label = UILabel(frame: CGRect(x: 0, y: (height - 30), width: width, height: 30))
            label.font = UIFont.boldSystemFont(ofSize: 20)
            
            // and set the text color & background
            label.textColor = .white
            label.backgroundColor = .gray
            
            label.textAlignment = .center
            label.text = "Click to Select Take"
            label.tag = 2
            
            self.secondShotImageView.addSubview(label)
            self.secondShotImageView.bringSubview(toFront: label)
            self.secondShotImageView.layer.borderWidth = 0.0;

            
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
                self.thirdTake = nil
                self.thirdShotDropDown.title = item
                self.thirdShotImageView.image = UIImage(named: self.imageNames[index])
                self.thirdShotImageView.layer.setValue(item, forKey: "shot")
                self.thirdShotImageView.layer.setValue("third", forKey: "sender")

                //setup tap gesture recognizer on Image
                self.thirdShotImageView.isUserInteractionEnabled = true
                //now you need a tap gesture recognizer
                //note that target and action point to what happens when the action is recognized.
                let thirdTapRecognizer = UITapGestureRecognizer(target: self, action:#selector(self.imageTapped(_:)))
                
                //add label
                let height = self.thirdShotImageView.bounds.size.height
                let width = self.thirdShotImageView.bounds.size.width
                
                let label = UILabel(frame: CGRect(x: 0, y: (height - 30), width: width, height: 30))
                label.font = UIFont.boldSystemFont(ofSize: 20)
                
                // and set the text color & background
                label.textColor = .white
                label.backgroundColor = .gray
                
                label.textAlignment = .center
                label.text = "Click to Select Take"
                label.tag = 3
                
                self.thirdShotImageView.addSubview(label)
                self.thirdShotImageView.bringSubview(toFront: label)
                self.thirdShotImageView.layer.borderWidth = 0.0;
                
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
                self.fourthTake = nil
                self.fourthShotDropDown.title = item
                self.fourthShotImageView.image = UIImage(named: self.imageNames[index])
                self.fourthShotImageView.layer.setValue(item, forKey: "shot")
                self.fourthShotImageView.layer.setValue("fourth", forKey: "sender")
                
                //setup tap gesture recognizer on Image
                self.fourthShotImageView.isUserInteractionEnabled = true
                //now you need a tap gesture recognizer
                //note that target and action point to what happens when the action is recognized.
                let fourthTapRecognizer = UITapGestureRecognizer(target: self, action:#selector(self.imageTapped(_:)))
                
                //add label
                let height = self.fourthShotImageView.bounds.size.height
                let width = self.fourthShotImageView.bounds.size.width
                
                let label = UILabel(frame: CGRect(x: 0, y: (height - 30), width: width, height: 30))
                label.font = UIFont.boldSystemFont(ofSize: 20)
                
                // and set the text color & background
                label.textColor = .white
                label.backgroundColor = .gray
                
                label.textAlignment = .center
                label.text = "Click to Select Take"
                
                label.tag = 4
                
                //remove border if already set
                self.firstShotImageView.layer.borderWidth = 0.0;
                
                self.fourthShotImageView.addSubview(label)
                self.fourthShotImageView.bringSubview(toFront: label)
                self.fourthShotImageView.layer.borderWidth = 0.0;
                
                //Add the recognizer to your view.
                self.fourthShotImageView.addGestureRecognizer(fourthTapRecognizer)
                
                self.fourthShotImageView.isHidden = false
            }
            
        }
    
    //Image Tap Functions
    
    func imageTapped(_ sender: UITapGestureRecognizer) {
        
        let alert = UIAlertController(title: "Select Take", message: nil, preferredStyle: UIAlertControllerStyle.alert)
        
        let goToMyTakes : UIAlertAction = UIAlertAction(title: "Choose from My Takes", style: UIAlertActionStyle.default, handler: {(action:UIAlertAction!)-> Void in
            self.performSegue(withIdentifier: "My Takes", sender: sender)
        })
        
        let openCamera : UIAlertAction = UIAlertAction(title: "Record New", style: UIAlertActionStyle.default, handler: {(action:UIAlertAction!)-> Void in
             _ = self.startCameraFromViewController(self, withDelegate: self)        })
        
        //check and see if image clicked has takes associated with it.
        //if it does show goToMyTakes, else no.
        let shot = sender.view?.layer.value(forKey: "shot") as! String

        if data.allTakesSaved[shot] != nil && data.allTakesSaved[shot]! != [] {
            alert.addAction(goToMyTakes)
        }
        
        alert.addAction(openCamera)
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default,handler: nil))

        alert.popoverPresentationController?.sourceView = self.view
        alert.popoverPresentationController?.sourceRect = self.view.bounds

        self.present(alert, animated: true, completion: nil)
    }
    
    //Mark: -ACTIONS
    @IBAction func unwindToStoryView(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.source as? MyTakesCollectionViewController {
            
            //show/hide my stories button
            if data.allTakesSaved["Story"] == nil || data.allTakesSaved["Story"]! == [] {
                self.navigationItem.rightBarButtonItem = nil
            } else {
                self.navigationItem.rightBarButtonItem = self.myStoriesButton
            }
            
            //get video and thumbnail
            let videoAsset = getVideoFromLocalIdentifier(id: sourceViewController.takeToPassID)
            let thumbnail = getAssetThumbnail(asset: videoAsset)
            
            let senderName = sourceViewController.senderName
            if senderName == "first" {

                //hide label view!
                let views = self.firstShotImageView.subviews
                for view in views {
                  view.isHidden = true
                }
                
                firstShotImageView.image = thumbnail
                firstShotImageView.layer.borderWidth = 3.0;
                firstShotImageView.layer.borderColor = UIColor.green.cgColor
                


                PHImageManager.default().requestAVAsset(forVideo: videoAsset, options: nil, resultHandler: {(avAsset: AVAsset?, audioMix: AVAudioMix?, info: [AnyHashable : Any]?) -> Void in
                    self.firstTake = avAsset!
                    print("first Asset Loaded")
                })
 
            } else if senderName == "second" {
                
                //hide label view!
                let views = self.secondShotImageView.subviews
                for view in views {
                    view.isHidden = true
                }
                
                // put take in second position.
                secondShotImageView.image = thumbnail
                secondShotImageView.layer.borderWidth = 3.0;
                secondShotImageView.layer.borderColor = UIColor.green.cgColor

                PHImageManager.default().requestAVAsset(forVideo: videoAsset, options: nil, resultHandler: {(avAsset: AVAsset?, audioMix: AVAudioMix?, info: [AnyHashable : Any]?) -> Void in
                    self.secondTake = avAsset!
                    print("second Asset Loaded")
                })
                
            } else if senderName == "third" {
                
                //hide label view!
                let views = self.thirdShotImageView.subviews
                for view in views {
                    view.isHidden = true
                }
                
                // put take in second position.
                thirdShotImageView.image = thumbnail
                thirdShotImageView.layer.borderWidth = 3.0;
                thirdShotImageView.layer.borderColor = UIColor.green.cgColor
                
                PHImageManager.default().requestAVAsset(forVideo: videoAsset, options: nil, resultHandler: {(avAsset: AVAsset?, audioMix: AVAudioMix?, info: [AnyHashable : Any]?) -> Void in
                    self.thirdTake = avAsset!
                    print("third Asset Loaded")
                })
                
            } else if senderName == "fourth" {
                
                //hide label view!
                let views = self.fourthShotImageView.subviews
                for view in views {
                    view.isHidden = true
                }
                
                // put take in second position.
                fourthShotImageView.image = thumbnail
                fourthShotImageView.layer.borderWidth = 3.0;
                fourthShotImageView.layer.borderColor = UIColor.green.cgColor
                
                PHImageManager.default().requestAVAsset(forVideo: videoAsset, options: nil, resultHandler: {(avAsset: AVAsset?, audioMix: AVAudioMix?, info: [AnyHashable : Any]?) -> Void in
                    self.fourthTake = avAsset!
                    print("fourth Asset Loaded")

                })
                
            }
        }
    }
    
    //MARK: --edit all together Actions!
    @IBAction func editTogether(_ sender: Any) {
        if (firstTake != nil && secondTake != nil && thirdTake != nil && fourthTake != nil) {
            self.activityIndicator.isHidden = false
            self.activityIndicator.startAnimating()
            
            //put all takes in array
            takeArray = [firstTake!, secondTake!, thirdTake!, fourthTake!]
            
            // 1 - Create AVMutableComposition object. This object will hold your AVMutableCompositionTrack instances.
            let myMutableComposition = AVMutableComposition()
            
            // 2 - Add Video tracks
            var totalTime = kCMTimeZero
            let videoTrack:AVMutableCompositionTrack = myMutableComposition.addMutableTrack(withMediaType: AVMediaTypeVideo, preferredTrackID: kCMPersistentTrackID_Invalid)
            let audioTrack:AVMutableCompositionTrack = myMutableComposition.addMutableTrack(withMediaType: AVMediaTypeAudio, preferredTrackID: kCMPersistentTrackID_Invalid)
            
            for videoAsset in takeArray! {
                print(videoAsset)

                do {
                    try videoTrack.insertTimeRange(CMTimeRangeMake(kCMTimeZero, videoAsset.duration),
                                                   of: videoAsset.tracks(withMediaType: AVMediaTypeVideo)[0],
                                                   at: totalTime)
                    //videoSize = videoTrack.naturalSize

                } catch let error as NSError {
                    print("error: \(error)")
                }
                
                do {
                    try audioTrack.insertTimeRange(CMTimeRangeMake(kCMTimeZero, videoAsset.duration),
                                                   of: videoAsset.tracks(withMediaType: AVMediaTypeAudio)[0],
                                                   at: totalTime)
                } catch let error as NSError {
                    print("error: \(error)")
                }
                
                totalTime = CMTimeAdd(totalTime, videoAsset.duration)
                print(totalTime)
            }
            
            
            // 4 - Get path
            
            let documentDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .long
            dateFormatter.timeStyle = .short
            let date = dateFormatter.string(from: NSDate() as Date)
            let savePath = (documentDirectory as NSString).appendingPathComponent("mergeVideo-\(date).mov")
            let url = NSURL(fileURLWithPath: savePath)
            
            // 5 - Create exporter
            let exporter = AVAssetExportSession(asset: myMutableComposition, presetName: AVAssetExportPresetHighestQuality)
            exporter!.outputURL = url as URL
            exporter!.outputFileType = AVFileTypeQuickTimeMovie
            exporter!.shouldOptimizeForNetworkUse = true
            exporter!.exportAsynchronously {
                PHPhotoLibrary.shared().performChanges({
                    PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: exporter!.outputURL!)
                }) { saved, error in
                    if saved {
                        
                        //hide activity animator
                        self.activityIndicator.isHidden = true
                        self.activityIndicator.stopAnimating()
                        //show my stories button
                        self.navigationItem.rightBarButtonItem = self.myStoriesButton
                        
                        // 6 - Get last video saved & add it to my data.
                        let localid = self.fetchLastVideoSaved()
                        let asset = self.getVideoFromLocalIdentifier(id: localid)
                        let thumbnail = self.getAssetThumbnail(asset: asset)
                        
                        // get thumbnail here??
                        let takeToSave = Take(localid: localid, thumbnail: thumbnail)
                        self.data.saveTake(shot: "Story", take: takeToSave)
                        
                        let alertController = UIAlertController(title: "Your video was successfully saved", message: nil, preferredStyle: .alert)
                        // add action to watch now!
                        let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                        let playNewVideoAction = UIAlertAction(title: "Play New Story Video", style: .default, handler: {(action:UIAlertAction!)-> Void in
                            self.playVideo(view: self, videoAsset: asset)})
                        
                        alertController.addAction(playNewVideoAction)
                        alertController.addAction(defaultAction)
                        
                        self.present(alertController, animated: true, completion: nil)
                        
                    } else{
                        print("video error: \(String(describing: error))")
                        
                    }
                }
            }
        } else {
            let alertController = UIAlertController(title: "Make sure you've selected Takes for each Shot!", message: nil, preferredStyle: .alert)
            // add action to watch now!
            let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(defaultAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }



    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: self)
        
        if segue.identifier == "My Takes" {
            // add this in so this is only if a photo has been tapped.  If the button has been tapped, do it differently.
            let sender = sender as! UITapGestureRecognizer
            let navController = segue.destination as! UINavigationController
            let myTakesCollectionViewController = navController.topViewController as! MyTakesCollectionViewController
            
            let shotName = sender.view?.layer.value(forKey: "shot")
            let senderName = sender.view?.layer.value(forKey: "sender")
            
            myTakesCollectionViewController.shotName = shotName as? String
            myTakesCollectionViewController.senderName = senderName as! String
        } else {
            let myTakesCollectionViewController = segue.destination as! MyTakesCollectionViewController
            myTakesCollectionViewController.shotName = "Story"
        }
    }
    
    //MARK: - Camera Methonds
    func startCameraFromViewController(_ viewController: UIViewController, withDelegate delegate: UIImagePickerControllerDelegate & UINavigationControllerDelegate) -> Bool {
        if UIImagePickerController.isSourceTypeAvailable(.camera) == false {
            return false
        }
        
        let cameraController = UIImagePickerController()
        cameraController.sourceType = .camera
        cameraController.mediaTypes = [kUTTypeMovie as NSString as String]
        cameraController.videoMaximumDuration = 30
        cameraController.allowsEditing = false
        cameraController.delegate = delegate
        
        present(cameraController, animated: true, completion: nil)
        return true
    }
    
    func video(_ videoPath: NSString, didFinishSavingWithError error: NSError?, contextInfo info: AnyObject) {
        var title = "Success"
        var message = "Your Take was saved!"
        
        let localid = fetchLastVideoSaved()
        
        let asset = getVideoFromLocalIdentifier(id: localid)
        let thumbnail = getAssetThumbnail(asset: asset)
        
        let takeToSave = Take(localid: localid, thumbnail: thumbnail)
        
        //NOT ABLE TO TELL WHERE THIS CAME FROM.
        
        if let _ = error {
            title = "Error"
            message = "Video failed to save"
        }
        let firstShot : UIAlertAction = UIAlertAction(title: "Insert as First Shot", style: UIAlertActionStyle.default, handler: {(action:UIAlertAction!)-> Void in
            self.addToFirstShot(take: takeToSave)
            PHImageManager.default().requestAVAsset(forVideo: asset, options: nil, resultHandler: {(avAsset: AVAsset?, audioMix: AVAudioMix?, info: [AnyHashable : Any]?) -> Void in
                self.firstTake = avAsset!
                print("first Asset Loaded")
            })

        })
        let secondShot : UIAlertAction = UIAlertAction(title: "Insert as Second Shot", style: UIAlertActionStyle.default, handler: {(action:UIAlertAction!)-> Void in
            self.addToSecondShot(take: takeToSave)
            PHImageManager.default().requestAVAsset(forVideo: asset, options: nil, resultHandler: {(avAsset: AVAsset?, audioMix: AVAudioMix?, info: [AnyHashable : Any]?) -> Void in
                self.secondTake = avAsset!
                print("second Asset Loaded")
            })

        })
        let thirdShot : UIAlertAction = UIAlertAction(title: "Insert as Third Shot", style: UIAlertActionStyle.default, handler: {(action:UIAlertAction!)-> Void in
            self.addToThirdShot(take: takeToSave)
            PHImageManager.default().requestAVAsset(forVideo: asset, options: nil, resultHandler: {(avAsset: AVAsset?, audioMix: AVAudioMix?, info: [AnyHashable : Any]?) -> Void in
                self.thirdTake = avAsset!
                print("third Asset Loaded")
            })
 
        })
        let fourthShot : UIAlertAction = UIAlertAction(title: "Insert as Fourth Shot", style: UIAlertActionStyle.default, handler: {(action:UIAlertAction!)-> Void in
            self.addToFourthShot(take: takeToSave)
            PHImageManager.default().requestAVAsset(forVideo: asset, options: nil, resultHandler: {(avAsset: AVAsset?, audioMix: AVAudioMix?, info: [AnyHashable : Any]?) -> Void in
                self.fourthTake = avAsset!
                print("fourth Asset Loaded")
            })
 
        })
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        // add four different actions to put in diff locations.
        if firstShotImageView.image != nil {
            alert.addAction(firstShot)
        }
        if secondShotImageView.image != nil {
            alert.addAction(secondShot)
        }
        if thirdShotImageView.image != nil {
            alert.addAction(thirdShot)
        }
        if fourthShotImageView.image != nil {
            alert.addAction(fourthShot)
        }
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: nil))

        alert.popoverPresentationController?.sourceView = self.view
        alert.popoverPresentationController?.sourceRect = self.view.bounds
        
        present(alert, animated: true, completion: nil)
    }
    
    func addToFirstShot(take: Take) {
        // add take image to specific target.
        //how do I tell which take is froooom?
        firstShotImageView.image = take.thumbnail
        firstShotImageView.layer.borderWidth = 3.0;
        firstShotImageView.layer.borderColor = UIColor.green.cgColor
        
        //hide label view!
        let views = self.firstShotImageView.subviews
        for view in views {
            view.isHidden = true
        }
    }

    func addToSecondShot(take: Take) {
        secondShotImageView.image = take.thumbnail
        secondShotImageView.layer.borderWidth = 3.0;
        secondShotImageView.layer.borderColor = UIColor.green.cgColor
        
        //hide label view!
        let views = self.secondShotImageView.subviews
        for view in views {
            view.isHidden = true
        }
    }

    func addToThirdShot(take: Take) {
        thirdShotImageView.image = take.thumbnail
        thirdShotImageView.layer.borderWidth = 3.0;
        thirdShotImageView.layer.borderColor = UIColor.green.cgColor
        
        //hide label view!
        let views = self.thirdShotImageView.subviews
        for view in views {
            view.isHidden = true
        }
    }

    func addToFourthShot(take: Take) {
        fourthShotImageView.image = take.thumbnail
        fourthShotImageView.layer.borderWidth = 3.0;
        fourthShotImageView.layer.borderColor = UIColor.green.cgColor
        
        //hide label view!
        let views = self.fourthShotImageView.subviews
        for view in views {
            view.isHidden = true
        }
    }

    //MARK: - Private method
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
    
    private func loadStoryExamples() {
        
        //gets filepath of .csv file
        let filePath:String = Bundle.main.path(forResource: "shotSuggestions", ofType: "csv")!
        
        let stream = InputStream(fileAtPath: filePath)!
        let csv = try! CSVReader(stream: stream)
        
        examples.remove(at: 0)
        
        while let row = csv.next() {
            examples.append(row)
        }
    }
    
    private func getVideoFromLocalIdentifier(id: String) -> PHAsset {
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate",
                                                         ascending: false)]
        let assetArray = PHAsset.fetchAssets(withLocalIdentifiers: [id], options: fetchOptions)
        let videoAsset = assetArray[0]
        
        return videoAsset
    }
    
    private func getAssetThumbnail(asset: PHAsset) -> UIImage {
        let manager = PHImageManager.default()
        let option = PHImageRequestOptions()
        var thumbnail = UIImage()
        option.isSynchronous = true
        manager.requestImage(for: asset, targetSize: CGSize(width: 100, height: 100), contentMode: .aspectFit, options: option, resultHandler: {(result, info)->Void in
            thumbnail = result!
        })
        return thumbnail
    }
    
    private func fetchLastVideoSaved() -> String {
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate",
                                                         ascending: false)]
        let allVideo = PHAsset.fetchAssets(with: .video, options: fetchOptions)
        
        let lastVideoSaved = allVideo.firstObject
        
        let identifier = lastVideoSaved?.localIdentifier
        
        return identifier!
    }
    
    private func playVideo(view: UIViewController, videoAsset: PHAsset) {
        guard (videoAsset.mediaType == .video) else {
            print("Not a valid video media type")
            return
        }
        PHCachingImageManager().requestAVAsset(forVideo: videoAsset, options: nil) { (asset, audioMix, args) in
            let asset = asset as! AVURLAsset
            DispatchQueue.main.async {
                let player = AVPlayer(url: asset.url)
                let playerViewController = AVPlayerViewController()
                playerViewController.player = player
                view.present(playerViewController, animated: true) {
                    playerViewController.player!.play()
                }
            }
        }
    }
    
    private func getAVAssetfromPHAsset(asset: PHAsset) -> AVAsset {
        var avAssetToReturn = AVFoundation.AVAsset()
        PHImageManager.default().requestAVAsset(forVideo: asset, options: nil, resultHandler: {(avAsset: AVAsset?, audioMix: AVAudioMix?, info: [AnyHashable : Any]?) -> Void in
            avAssetToReturn = avAsset!
        })
        
        return avAssetToReturn
    }

}


// MARK: - UIImagePickerControllerDelegate

extension StoryViewController: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let mediaType = info[UIImagePickerControllerMediaType] as! NSString
        
        dismiss(animated: true, completion: nil)
        
        // Handle a movie capture
        if mediaType == kUTTypeMovie {
            
            // took away GUARD statement here b/c of errors
            let path = (info[UIImagePickerControllerMediaURL] as! URL).path
            
            if UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(path) {
                UISaveVideoAtPathToSavedPhotosAlbum(path, self, #selector(ShotViewController.video(_:didFinishSavingWithError:contextInfo:)), nil)
                
            }
            
        }
    }
}



