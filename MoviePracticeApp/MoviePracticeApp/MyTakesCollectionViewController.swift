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

    
    override func viewDidLoad() {
        super.viewDidLoad()

        shotsTaken = (data.allTakesSaved[shotName!]!)

        // Register cell classes
        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
                
        let editButton = UIBarButtonItem(title: "Edit", style: UIBarButtonItemStyle.plain, target: self, action: #selector(MyTakesCollectionViewController.deleteTakes(_:)))
        
        tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapToPlay(_:)))

        self.navigationItem.rightBarButtonItem = editButton
        
        loadTakes()
        

        collectionView?.addGestureRecognizer(self.tapGesture)

        self.tapGesture.delegate = self
        self.tapGesture.isEnabled = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - ACTIONS
    
    func tapToPlay(_ recognizer: UITapGestureRecognizer)  {
        if recognizer.state == UIGestureRecognizerState.ended {
            let tapLocation = recognizer.location(in: self.collectionView)
            if let tapIndexPath = self.collectionView?.indexPathForItem(at: tapLocation) {
                print(tapIndexPath)
                print(tapIndexPath[1])
                
                let takeToPlay = shotsTaken[tapIndexPath[1]]
                
                let videoAsset = getVideoToPlayFromLocalIdentifier(id: takeToPlay.localid)
                
                playVideo (view: self, videoAsset: videoAsset)
            }
        }
    }
    
    // MARK: The navigation bar's Edit button functions
    func deleteTakeCell(sender:UIButton) {
        
        print("delete button pushed")
        // Put the index number of the delete button the use tapped in a variable
        let i: Int = (sender.layer.value(forKey: "index")) as! Int
                
        // Remove an object from the collection view's dataSource

        let takeToDelete = shotsTaken[i]

        data.deleteTake(shot: self.shotName!, take: takeToDelete)
        
        // Refresh the collection view - this deletes the button.  Maybe add to array and then when edit done remove all?
        let indexPath = [0, i] as IndexPath
        self.collectionView?.reloadItems(at: [indexPath])
    }
    
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
                cell.deleteButton.isHidden = false // Hide all of the delete buttons
            }
        } else {
            // renable tap gesture for playing video
            //disable tap gesture recognizer for playing video
            tapGesture.isEnabled = true
            
            //relaod collection
            self.collectionView?.reloadData()
            
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



    // MARK: UICollectionViewDataSource
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if shotsTaken.count > 0 {
            return shotsTaken.count
        } else {
            return 1
        }
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> MyTakesCollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "savedShotCell", for: indexPath) as! MyTakesCollectionViewCell
    
        
        if takes.isEmpty {
            // create a new cell template that just says "No shots to display
            cell.backgroundColor = UIColor.white
            self.navigationItem.title = "No Takes Saved"

        } else {
        
        // Configure the cell
         cell.backgroundColor = UIColor.black
            
        // Fetches the appropriate take for the data source layout.
        let take = takes[indexPath.item]

        cell.savedShotImageView?.image = take.thumbnail
        cell.savedShotImageView?.isUserInteractionEnabled = true
        
        // Give the delete button an index number
        cell.deleteButton.layer.setValue(indexPath.row, forKey: "index")
        
        // Add an action function to the delete button
//        #selector(tap(gestureReconizer:))
        cell.deleteButton.addTarget(self, action: #selector(self.deleteTakeCell), for: UIControlEvents.touchUpInside)
        }
        return cell
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
                print("this is the take object>>>>>>")
                print(take)
                
                let asset = getVideoToPlayFromLocalIdentifier(id: take.localid)
                
                let thumbnail = getAssetThumbnail(asset: asset)
                take.thumbnail =  thumbnail
                takes.append(take)
            }

        }
        
    }
    
    private func getVideoToPlayFromLocalIdentifier(id: String) -> PHAsset {
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
