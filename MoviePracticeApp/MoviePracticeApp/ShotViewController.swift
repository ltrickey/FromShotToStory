
//
//  ShotViewController.swift
//  MoviePracticeApp
//
//  Created by Lynn Trickey on 7/3/17.
//  Copyright © 2017 Lynn Trickey. All rights reserved.
//

import UIKit
import MobileCoreServices

// save shot URLS after they've been done here.
// shot name string, urls of shots array of strings.
// Is this a problem with a global variable?
var shotTypesTried = [String: [String]]()

class ShotViewController: UIViewController {
    
    //MARK: Properties
    
    // setting this up to access later after saving.
    var videoPath : String = ""
    
    @IBOutlet weak var shotDescLabel: UILabel!
    @IBOutlet weak var shotImageView: UIImageView!
    @IBOutlet weak var myShotsButton: UIButton!
    
    // set optional shot variable 
    var shot: Shot?
    
    //connecting touch up inside from button to record video.
    @IBAction func record(_ sender: UIButton) {
        // added _ = to say we're not capturing result.  
        _ = startCameraFromViewController(self, withDelegate: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set up views with existing Shot.
        if let shot = shot {
            navigationItem.title = shot.name
            shotImageView.image = shot.photo
            shotDescLabel.text = shot.description
        }
        
        if shot!.tried == false {
            myShotsButton.isHidden = true
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
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
        var message = "Video was saved"
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
        
        guard let MyShotsCollectionViewController = segue.destination as? MyShotsCollectionViewController else {
            fatalError("Unexpected destination: \(segue.destination)")
        }

        
        MyShotsCollectionViewController.shotName = (shot?.name)!
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
            
            // Save url of video?
            self.videoPath = path
            
            if UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(path) {
                UISaveVideoAtPathToSavedPhotosAlbum(path, self, #selector(ShotViewController.video(_:didFinishSavingWithError:contextInfo:)), nil)
                
                myShotsButton.isHidden = false
                
                // add to saved shots global
                if shotTypesTried[(shot?.name)!] != nil {
                    shotTypesTried[(shot?.name)!]!.append(self.videoPath)
                } else {
                    shotTypesTried[(shot?.name)!] = [self.videoPath]
                }
                
            }
        }
    }
}

// MARK: - UINavigationControllerDelegate

extension ShotViewController: UINavigationControllerDelegate {
}


