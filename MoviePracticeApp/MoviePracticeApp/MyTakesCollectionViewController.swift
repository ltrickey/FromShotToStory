//
//  MyTakesCollectionViewController.swift
//  MoviePracticeApp
//
//  Created by Lynn Trickey on 7/10/17.
//  Copyright © 2017 Lynn Trickey. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit
import Photos

class MyTakesCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout, UIGestureRecognizerDelegate {
    
    //MARK: properties
    
    var takes = [Take]()
    
    private let reuseIdentifier = "Cell"
    
    fileprivate let itemsPerRow: CGFloat = 3
    
    fileprivate let sectionInsets = UIEdgeInsets(top: 50.0, left: 20.0, bottom: 50.0, right: 20.0)
    
    // variable of Shot Name, sent from shot view.
    var shotName : String?
    
    // get takes from local data - could be nil if never saved before.
    var data = DataStore.myTakes

    // the array of shot URLs - not filled until viewDidLoad
    var shotsTaken: [Take] = []
    
    var editModeEnabled = false
    var tapGesture = UITapGestureRecognizer()
    
    var isPresentingInModal : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let shotName = shotName {
            if data.allTakesSaved[shotName] != nil {
                shotsTaken = (data.allTakesSaved[shotName]!)
            }
        }
        // Register cell classes
        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        // Depending on style of presentation (modal or push presentation), this nav button will be different
        
        var editButton = UIBarButtonItem()
        
        if presentingViewController is UINavigationController {
            isPresentingInModal = true
        }
        
        if isPresentingInModal {
            //set up edit button on nav bar to be select & Done
            editButton = UIBarButtonItem(title: "Select", style: UIBarButtonItemStyle.plain, target: self, action: #selector(MyTakesCollectionViewController.dismissPopUp(_:)))
            let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.plain, target: self, action: #selector(MyTakesCollectionViewController.dismissPopUp(_:)))
            self.navigationItem.leftBarButtonItem = cancelButton
        } else {
            //set up edit button on nav bar to be edit/delete
            editButton = UIBarButtonItem(title: "Edit", style: UIBarButtonItemStyle.plain, target: self, action: #selector(MyTakesCollectionViewController.deleteTakes(_:)))
        }
        
        self.navigationItem.rightBarButtonItem = editButton
        
        
        //set up tap to play
        tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapToPlay(_:)))

        collectionView?.addGestureRecognizer(self.tapGesture)

        self.tapGesture.delegate = self
        self.tapGesture.isEnabled = true
        
        //load take objects
        loadTakes()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: UICollectionViewDataSource
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if shotsTaken.count < 1 {
            self.navigationItem.title = "No Takes Saved"
        }
        return shotsTaken.count
    }
    
    //set up cells
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> MyTakesCollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "savedShotCell", for: indexPath) as! MyTakesCollectionViewCell
            
        // Configure the cell
        cell.backgroundColor = UIColor.black
            
        // Fetches the appropriate take for the data source layout.
        let take = takes[indexPath.item]
            
        cell.savedShotImageView?.image = take.thumbnail
        cell.savedShotImageView?.isUserInteractionEnabled = true
            
        // Set up Cell Delete button based on which view state
        
        cell.deleteButton.addTarget(self, action: #selector(self.deleteTakeCell), for: UIControlEvents.touchUpInside)
    
        return cell
    }
    
    //MARK: - ACTIONS
    
    @IBAction func unwindToStoryView (sender: UIStoryboardSegue) {
        if let source = sender.source as? StoryViewController {
        }
    }

    
    func tapToPlay(_ recognizer: UITapGestureRecognizer)  {
        if recognizer.state == UIGestureRecognizerState.ended {
            let tapLocation = recognizer.location(in: self.collectionView)
            if let tapIndexPath = self.collectionView?.indexPathForItem(at: tapLocation) {
                
                let takeToPlay = shotsTaken[tapIndexPath[1]]
                
                let videoAsset = getVideoFromLocalIdentifier(id: takeToPlay.localid)
                
                playVideo (view: self, videoAsset: videoAsset)
            }
        }
    }
    
    func dismissPopUp(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    func selectTakeCell(sender:UIButton) {
        
    }
    
    //Delete function called when delete button on cell is tapped.
    func deleteTakeCell(sender:UIButton) {
        
        //Access cell attached to button
        let cell = sender.superview?.superview as! UICollectionViewCell
        
        self.collectionView?.willRemoveSubview(cell)
        
        let cellPath = self.collectionView?.indexPath(for: cell)
        
        let i: Int = cellPath![1]

       // Remove an object from the collection view's dataSource
        let takeToDelete = shotsTaken[i]
        data.deleteTake(shot: self.shotName!, take: takeToDelete)
        
       // Remove Video Asset from Photos library
        PHPhotoLibrary.shared().performChanges( {
            let videoAsset = self.getVideoFromLocalIdentifier(id: takeToDelete.localid)
            PHAssetChangeRequest.deleteAssets([videoAsset] as NSFastEnumeration)}, completionHandler: { success, error in print("Finished deleting asset. %@", (success ? "Success" : error!))
        })
  
        // Refresh the collection view - this deletes the button.  How to delete whole cell?
        shotsTaken = (data.allTakesSaved[shotName!]!)
        print(shotsTaken)
        loadTakes()
//        self.collectionView?.reloadItems(at: [cellPath!])
        DispatchQueue.main.async {
            self.collectionView?.reloadData()
        }
        
    }

    
    // MARK: Edit function called when edit button on bar is tapped.
    func deleteTakes(_ sender: UIBarButtonItem) {
        if(editModeEnabled == false) {
            //disable tap gesture recognizer for playing video
            tapGesture.isEnabled = false
            
            // Put the collection view in edit mode
            let editButton = self.navigationItem.rightBarButtonItem
            editButton?.title = "Done"
            editButton?.style = .done
            editModeEnabled = true
            
            // Loop through the collectionView's visible cells
            for item in self.collectionView!.visibleCells as! [MyTakesCollectionViewCell] {
                let indexPath: NSIndexPath = self.collectionView!.indexPath(for: item as MyTakesCollectionViewCell)! as NSIndexPath
                let cell: MyTakesCollectionViewCell = self.collectionView!.cellForItem(at: indexPath as IndexPath) as! MyTakesCollectionViewCell!
                cell.deleteButton.isHidden = false // show all of the delete buttons
            }
        } else {
            // renable tap gesture for playing video
            tapGesture.isEnabled = true
            
            // Take the collection view out of edit mode
            let editButton = self.navigationItem.rightBarButtonItem
            editButton?.style = .plain
            editButton?.title = "Edit"
            editModeEnabled = false
            
            // Loop through the collectionView's visible cells
            for item in self.collectionView!.visibleCells as! [MyTakesCollectionViewCell] {
                let indexPath: NSIndexPath = self.collectionView!.indexPath(for: item as MyTakesCollectionViewCell)! as NSIndexPath
                let cell: MyTakesCollectionViewCell = self.collectionView!.cellForItem(at: indexPath as IndexPath) as! MyTakesCollectionViewCell!
                cell.deleteButton.isHidden = true  // Hide all of the delete buttons
            }
        }
    }
    
    // MARK: UICollectionViewDelegateFlowLayout 
    // taken from tutorial to make collection view larger

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        
        return CGSize(width: widthPerItem, height: widthPerItem)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }

    // MARK: UICollectionViewDelegate

    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }

    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }

    //MARK: Private Methods
    
    private func loadTakes() {
        if !shotsTaken.isEmpty {
            for take in shotsTaken {
                let asset = getVideoFromLocalIdentifier(id: take.localid)
                let thumbnail = getAssetThumbnail(asset: asset)
                take.thumbnail =  thumbnail
                takes.append(take)
            }
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
