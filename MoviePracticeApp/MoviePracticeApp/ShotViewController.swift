
//
//  ShotViewController.swift
//  MoviePracticeApp
//
//  Created by Lynn Trickey on 7/3/17.
//  Copyright © 2017 Lynn Trickey. All rights reserved.
//

import UIKit
import MobileCoreServices
import Photos
import QuartzCore
import SwiftyGif

// save shot URLS after they've been done here.
// shot name string, urls of shots array of strings.
// Is this a problem with a global variable?


class ShotViewController: UIViewController, UINavigationControllerDelegate {
    
    //MARK: Properties
    
    //getting everything from local data
    var allTakesSaved = DataStore.myTakes

    @IBOutlet weak var shotDescLabel: UILabel!
    @IBOutlet weak var shotDescriptionHeight: NSLayoutConstraint!

    @IBOutlet weak var shotImageView: UIImageView!
    @IBOutlet weak var replayGifButton: UIButton!
    @IBOutlet weak var myShotsButton: UIButton!
    @IBOutlet weak var tryItButton: UIButton!
    @IBOutlet weak var buttonStackView: UIStackView!
    @IBOutlet weak var buttonStackBottom: NSLayoutConstraint!
   
    // set optional shot variable 
    var shot: Shot?
    
    //Set up gifManager to be used later
    let gifManager = SwiftyGifManager(memoryLimit:20)
    
    //connecting touch up inside from button to record video.
    @IBAction func record(_ sender: UIButton) {
        // added _ = to say we're not saving the result from this in this function.
        _ = startCameraFromViewController(self, withDelegate: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.bringSubview(toFront: shotDescLabel)
                
        // Set up views with existing Shot.
        if let shot = shot {
            navigationItem.title = shot.name
            shotDescLabel.text = shot.description
            if shot.gif != nil {
                replayGifButton.isHidden = false
                let btnImage = UIImage(named: "replay")
                replayGifButton.setImage(btnImage , for: UIControlState.normal)
                let gif = UIImage(gifName: shot.gif!)
                shotImageView.setGifImage(gif, manager: gifManager, loopCount: 1)
            } else {
                shotImageView.image = shot.photo
                replayGifButton.isHidden = true
            }
        }
        
        //add borders to buttons 
        let white = UIColor.white.cgColor
        tryItButton.layer.cornerRadius = 10; // this value vary as per your desire
        tryItButton.clipsToBounds = true
        myShotsButton.layer.cornerRadius = 10; // this value vary as per your desire
        myShotsButton.clipsToBounds = true
        tryItButton.layer.borderWidth = 4.0
        myShotsButton.layer.borderWidth = 4.0
        tryItButton.layer.borderColor = white
        myShotsButton.layer.borderColor = white
        
        if shot!.tried == false {
            myShotsButton.isHidden = true
        }
        
    }
    
    @IBAction func replayGif(_ sender: UIButton) {
        print("replay pushed")
        let gif = UIImage(gifName: (shot?.gif!)!)
        shotImageView.setGifImage(gif, manager: gifManager, loopCount: 1)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
       
        //change layout of description label based on orientation.
        switch UIDevice.current.orientation{
        case .portrait:
            shotDescriptionHeight.constant = 550 as CGFloat
            buttonStackBottom.constant = 75 as CGFloat
        case .portraitUpsideDown:
            shotDescriptionHeight.constant = 550 as CGFloat
            buttonStackBottom.constant = 75 as CGFloat
        case .landscapeLeft:
            shotDescriptionHeight.constant = 500 as CGFloat
            buttonStackBottom.constant = 30 as CGFloat
        case .landscapeRight:
            shotDescriptionHeight.constant = 500 as CGFloat
            buttonStackBottom.constant = 30 as CGFloat
        default:
            shotDescriptionHeight.constant = 500 as CGFloat
            buttonStackBottom.constant = 75 as CGFloat
        }
    }

    
    func startCameraFromViewController(_ viewController: UIViewController, withDelegate delegate: UIImagePickerControllerDelegate & UINavigationControllerDelegate) -> Bool {
        if UIImagePickerController.isSourceTypeAvailable(.camera) == false {
            return false
        }
        
        let cameraController = UIImagePickerController()
        cameraController.sourceType = .camera
        cameraController.mediaTypes = [kUTTypeMovie as NSString as String]
        cameraController.allowsEditing = false
        cameraController.videoMaximumDuration = 30
        cameraController.delegate = delegate
        
        present(cameraController, animated: true, completion: nil)
        return true
    }
    
    func video(_ videoPath: NSString, didFinishSavingWithError error: NSError?, contextInfo info: AnyObject) {
        var title = "Success"
        var message = "Video was saved!  Great Job!  Click on 'My Takes' to watch back your take, then try again.  You can try giving your actor some different direction, or get closer or further away from your subject."
        
        //Saving it in my Database too!
        let localid = fetchLastVideoSaved()
        let asset = getVideoFromLocalIdentifier(id: localid)
        let thumbnail =  getAssetThumbnail(asset: asset)

        let takeToSave = Take(localid: localid, thumbnail: thumbnail)
        allTakesSaved.saveTake(shot: (shot?.name)!, take: takeToSave)
        
        if let _ = error {
            title = "Error"
            message = "Video failed to save"
        }
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    // MARK: - Navigation
    
    // send the data of this shot along when myShots button is clicked.

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        guard let myTakesCollectionViewController = segue.destination as? MyTakesCollectionViewController else {
            fatalError("Unexpected destination: \(segue.destination)")
        }

       myTakesCollectionViewController.shotName = (shot?.name)!
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
}

// MARK: - UIImagePickerControllerDelegate

extension ShotViewController: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let mediaType = info[UIImagePickerControllerMediaType] as! NSString
        
        dismiss(animated: true, completion: nil)
        
        // Handle a movie capture
        if mediaType == kUTTypeMovie {
            
          // took away GUARD statement here b/c of errors
            let path = (info[UIImagePickerControllerMediaURL] as! URL).path
            
            if UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(path) {
                UISaveVideoAtPathToSavedPhotosAlbum(path, self, #selector(ShotViewController.video(_:didFinishSavingWithError:contextInfo:)), nil)
                
                myShotsButton.isHidden = false
            }
        }
    }
}



