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
    var allTakesSaved = DataStore.myTakes
    
    var firstTake: AVAsset?
    var secondTake: AVAsset?
    var thirdTake: AVAsset?
    var fourthTake: AVAsset?
    
    var takeArray: [AVAsset]?
    var videoSize: CGSize = CGSize(width: 0.0, height: 0.0)


    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var putItTogetherButton: UIButton!
    
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

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadShotData()
        
        putItTogetherButton.isHidden = true
        shotsStackView.isHidden = true
        
        // story stuff
        self.selectShotsLabel.isHidden = true
        self.selectShotsExample.isHidden = true
        self.selectShotsEncouragement.isHidden = true
        self.activityIndicator.isHidden = true
        
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
            self.firstShotDropDown.title = item
            self.firstShotImageView.image = UIImage(named: self.imageNames[index])
            self.firstShotImageView.layer.setValue(item, forKey: "shot")
            self.firstShotImageView.layer.setValue("first", forKey: "sender")
            
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
            self.secondShotImageView.layer.setValue(item, forKey: "shot")
            self.secondShotImageView.layer.setValue("second", forKey: "sender")
       
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
                self.thirdShotImageView.layer.setValue(item, forKey: "shot")
                self.thirdShotImageView.layer.setValue("third", forKey: "sender")

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
                self.fourthShotImageView.layer.setValue(item, forKey: "shot")
                self.fourthShotImageView.layer.setValue("fourth", forKey: "sender")
                
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
        
        let alert = UIAlertController(title: "Select Take", message:
            "Choose Existing or Shoot new Take", preferredStyle: UIAlertControllerStyle.alert)
        
        let goToMyTakes : UIAlertAction = UIAlertAction(title: "Choose from My Takes", style: UIAlertActionStyle.default, handler: {(action:UIAlertAction!)-> Void in
            self.performSegue(withIdentifier: "My Takes", sender: sender)
        })
        
        let openCamera : UIAlertAction = UIAlertAction(title: "Record new Take", style: UIAlertActionStyle.default, handler: {(action:UIAlertAction!)-> Void in
             _ = self.startCameraFromViewController(self, withDelegate: self)        })
        
        alert.addAction(goToMyTakes)
        alert.addAction(openCamera)
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default,handler: nil))

        alert.popoverPresentationController?.sourceView = self.view
        alert.popoverPresentationController?.sourceRect = self.view.bounds
        // this is the center of the screen currently but it can be any point in the view
        self.present(alert, animated: true, completion: nil)
        
    }
    
    //Mark: -ACTIONS
    @IBAction func unwindToStoryView(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.source as? MyTakesCollectionViewController {
            //get video and thumbnail
            let videoAsset = getVideoFromLocalIdentifier(id: sourceViewController.takeToPassID)
            let thumbnail = getAssetThumbnail(asset: videoAsset)
            
            let senderName = sourceViewController.senderName
            if senderName == "first" {
                // put take in first position.
                firstShotImageView.image = thumbnail

                PHImageManager.default().requestAVAsset(forVideo: videoAsset, options: nil, resultHandler: {(avAsset: AVAsset?, audioMix: AVAudioMix?, info: [AnyHashable : Any]?) -> Void in
                    self.firstTake = avAsset!
                    print("first Asset Loaded")
                })
 

            } else if senderName == "second" {
                // put take in second position.
                secondShotImageView.image = thumbnail

                PHImageManager.default().requestAVAsset(forVideo: videoAsset, options: nil, resultHandler: {(avAsset: AVAsset?, audioMix: AVAudioMix?, info: [AnyHashable : Any]?) -> Void in
                    self.secondTake = avAsset!
                    print("second Asset Loaded")
                })
                
            } else if senderName == "third" {
                // put take in second position.
                thirdShotImageView.image = thumbnail
                
                PHImageManager.default().requestAVAsset(forVideo: videoAsset, options: nil, resultHandler: {(avAsset: AVAsset?, audioMix: AVAudioMix?, info: [AnyHashable : Any]?) -> Void in
                    self.thirdTake = avAsset!
                    print("third Asset Loaded")
                })

                
            } else if senderName == "fourth" {
                // put take in second position.
                fourthShotImageView.image = thumbnail
                
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
            
            print(takeArray)
            // 1 - Create AVMutableComposition object. This object will hold your AVMutableCompositionTrack instances.
            let myMutableComposition = AVMutableComposition()
            
            // 2 - Add Video tracks
            var totalTime = kCMTimeZero
            
            for videoAsset in takeArray! {
                print(videoAsset)
                let videoTrack = myMutableComposition.addMutableTrack(withMediaType: AVMediaTypeVideo, preferredTrackID: Int32(kCMPersistentTrackID_Invalid))
                let audioTrack:AVMutableCompositionTrack = myMutableComposition.addMutableTrack(withMediaType: AVMediaTypeAudio, preferredTrackID: CMPersistentTrackID())

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
                        
                        // 6 - Get last video saved & add it to my data.
                        let localid = self.fetchLastVideoSaved()
                        let asset = self.getVideoFromLocalIdentifier(id: localid)
                        
                        // get thumbnail here??
                        let takeToSave = Take(localid: localid, thumbnail: nil)
                        self.allTakesSaved.saveTake(shot: "Story", take: takeToSave)
                        

                        let alertController = UIAlertController(title: "Your video was successfully saved", message: nil, preferredStyle: .alert)
                        // add action to watch now!
                        let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                        let playNewVideoAction = UIAlertAction(title: "Play New Story Video", style: .default, handler: {(action:UIAlertAction!)-> Void in
                            self.playVideo(view: self, videoAsset: asset)})
                        
                        alertController.addAction(playNewVideoAction)
                        alertController.addAction(defaultAction)
                        
                        //hide activity animator
                        self.activityIndicator.stopAnimating()
                        self.activityIndicator.isHidden = true
                        
                        self.present(alertController, animated: true, completion: nil)
                    } else{
                        print("video error: \(String(describing: error))")
                        
                    }
                }
            }
        } else {
            let alertController = UIAlertController(title: "Choose four takes in order to put them together!", message: nil, preferredStyle: .alert)
            // add action to watch now!
            let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(defaultAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }



    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: self)
        
        let sender = sender as! UITapGestureRecognizer
        let navController = segue.destination as! UINavigationController
        let myTakesCollectionViewController = navController.topViewController as! MyTakesCollectionViewController
        
        let shotName = sender.view?.layer.value(forKey: "shot")
        let senderName = sender.view?.layer.value(forKey: "sender")

        myTakesCollectionViewController.shotName = shotName as? String
        myTakesCollectionViewController.senderName = senderName as! String

    }
    
    //MARK: - Camera Methonds
    func startCameraFromViewController(_ viewController: UIViewController, withDelegate delegate: UIImagePickerControllerDelegate & UINavigationControllerDelegate) -> Bool {
        if UIImagePickerController.isSourceTypeAvailable(.camera) == false {
            return false
        }
        
        let cameraController = UIImagePickerController()
        cameraController.sourceType = .camera
        cameraController.mediaTypes = [kUTTypeMovie as NSString as String]
        cameraController.allowsEditing = false
        cameraController.delegate = delegate
        
        present(cameraController, animated: true, completion: nil)
        return true
    }
    
    func video(_ videoPath: NSString, didFinishSavingWithError error: NSError?, contextInfo info: AnyObject) {
        var title = "Success"
        var message = "Video was saved!"
        
        //Saving it in my Database too!
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

        })
        let secondShot : UIAlertAction = UIAlertAction(title: "Insert as Second Shot", style: UIAlertActionStyle.default, handler: {(action:UIAlertAction!)-> Void in
            self.addToSecondShot(take: takeToSave)

        })
        let thirdShot : UIAlertAction = UIAlertAction(title: "Insert as Third Shot", style: UIAlertActionStyle.default, handler: {(action:UIAlertAction!)-> Void in
            self.addToThirdShot(take: takeToSave)
 
        })
        let fourthShot : UIAlertAction = UIAlertAction(title: "Insert as Fourth Shot", style: UIAlertActionStyle.default, handler: {(action:UIAlertAction!)-> Void in
            self.addToFourthShot(take: takeToSave)
 
        })
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        // add four different actions to put in diff locations.
        alert.addAction(firstShot)
        alert.addAction(secondShot)
        alert.addAction(thirdShot)
        alert.addAction(fourthShot)
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: nil))

        alert.popoverPresentationController?.sourceView = self.view
        alert.popoverPresentationController?.sourceRect = self.view.bounds
        
        present(alert, animated: true, completion: nil)
    }
    
    func addToFirstShot(take: Take) {
        // add take image to specific target.
        //how do I tell which take is froooom?
        firstShotImageView.image = take.thumbnail
    }

    func addToSecondShot(take: Take) {
        secondShotImageView.image = take.thumbnail
    }

    func addToThirdShot(take: Take) {
        thirdShotImageView.image = take.thumbnail
    }

    func addToFourthShot(take: Take) {
        fourthShotImageView.image = take.thumbnail
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



