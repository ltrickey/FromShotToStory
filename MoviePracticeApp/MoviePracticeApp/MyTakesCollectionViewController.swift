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
    
    @IBOutlet weak var editButton: UIBarButtonItem!
    
    var editModeEnabled = false

    override func viewDidLoad() {
        super.viewDidLoad()
        print(shotsTaken)
        shotsTaken = (data.allTakesSaved[shotName!]!)

        // Register cell classes
        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapToPlay(_:)))
        collectionView?.addGestureRecognizer(tapGesture)
        tapGesture.delegate = self
        
        print(shotsTaken[0])
        
        loadTakes()
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
    func deletePhotoCell(sender:UIButton) {
        // Put the index number of the delete button the use tapped in a variable
        let i: Int = (sender.layer.valueForKey("index")) as Int
        // Remove an object from the collection view's dataSource
        imageFileNames.removeAtIndex(i)
        
        // Refresh the collection view
        self.collectionView!.reloadData()
    }
    
    @IBAction func deleteTakes(_ sender: UIBarButtonItem) {
        if(editModeEnabled == false) {
            // Put the collection view in edit mode
            editButton.title = "Done"
            self.editButton.style = .done
            editModeEnabled = true
            
            // Loop through the collectionView's visible cells
            for item in self.collectionView!.visibleCells as! [MyTakesCollectionViewCell] {
                var indexPath: NSIndexPath = self.collectionView!.indexPath(for: item as MyTakesCollectionViewCell)! as NSIndexPath
                var cell: MyTakesCollectionViewCell = self.collectionView.cellForItemAtIndexPath(indexPath) as MyTakesCollectionViewCell!
                cell.deleteButton.hidden = false // Hide all of the delete buttons
            }
        } else {
            // Take the collection view out of edit mode
            editButton.style = .plain
            editButton.title = "Edit"
            editModeEnabled = false
            
            // Loop through the collectionView's visible cells
            for item in self.collectionView!.visibleCells as! [MyTakesCollectionViewCell] {
                var indexPath: NSIndexPath = self.collectionView.indexPathForCell(item as MyTakesCollectionViewCell)!
                var cell: PhotoCell = self.collectionView!.cellForItemAtIndexPath(indexPath) as MyTakesCollectionViewCell!
                cell.deleteButton.hidden = true  // Hide all of the delete buttons
            }
        }
    }



    // MARK: UICollectionViewDataSource
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return shotsTaken.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> MyTakesCollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "savedShotCell", for: indexPath) as! MyTakesCollectionViewCell
        
        cell.backgroundColor = UIColor.black
        
        // Configure the cell
        
        // Fetches the appropriate take for the data source layout.
        let take = takes[indexPath.item]

        cell.savedShotImageView.image = take.thumbnail
        cell.savedShotImageView.isUserInteractionEnabled = true
        
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
        
        for take in shotsTaken {
            print("this is the take object>>>>>>")
            print(take)
            
            let asset = getVideoToPlayFromLocalIdentifier(id: take.localid)
            
            let thumbnail = getAssetThumbnail(asset: asset)
            take.thumbnail =  thumbnail
            takes.append(take)

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
