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

class MyTakesCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout, UIGestureRecognizerDelegate {
    
    //MARK: properties
        
    var takes = [Take]()
    
    private let reuseIdentifier = "Cell"
    
    fileprivate let itemsPerRow: CGFloat = 3
    
    fileprivate let sectionInsets = UIEdgeInsets(top: 50.0, left: 20.0, bottom: 50.0, right: 20.0)
    
    // variable of Shot Name, sent from shot view.
    var shotName : String?
    
    // the array of shot URLs - not filled until viewDidLoad
    var shotsTaken: [URL] = []
    
    func tapToPlay(_ recognizer: UITapGestureRecognizer)  {
        if recognizer.state == UIGestureRecognizerState.ended {
            let tapLocation = recognizer.location(in: self.collectionView)
                if let tapIndexPath = self.collectionView?.indexPathForItem(at: tapLocation) {
                    print(tapIndexPath)
                    print(tapIndexPath[1])
                            
                        let url = shotsTaken[tapIndexPath[1]]
                    
                        // Create an AVPlayer, passing it the HTTP Live Streaming URL.
                        let player = AVPlayer(url: url)
                    
                        // Create a new AVPlayerViewController and pass it a reference to the player.
                        let controller = AVPlayerViewController()
                        controller.player = player
                    
                        // Modally present the player and call the player's play() method when complete.
                        present(controller, animated: true) {
                            player.play()
                        }
        
                    }
                }
            }

    override func viewDidLoad() {
        super.viewDidLoad()
        shotsTaken = shotTypesTried[shotName!]!

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        loadTakes()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapToPlay(_:)))
        collectionView?.addGestureRecognizer(tapGesture)
        tapGesture.delegate = self
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // MARK: - Navigation

//    func prepare(for segue: UIStoryboardSegue, sender: MyTakesCollectionViewCell?) {
//        // Get the new view controller using [segue destinationViewController].
//        // Pass the selected object to the new view controller.
//     
//        let destination = segue.destination as! AVPlayerViewController
//        
//        let cell = sender!
//        
//        let indexPath = self.collectionView!.indexPath(for: cell)
//        
//        let index = indexPath?.item
//        
//        let destinationURL = shotsTaken[index!]
//        
//        print("This is the selected cell INDEEXXXX!!! >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>")
//        print(index)
//        let url = shotsTaken[index!]
//        
//        destination.player = AVPlayer(url: url)
//
//    }

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
    
//    var urltoPass: URL!
//    
//    func collectionView(_ collectionView: UICollectionView, didSelectRowAtIndexPath indexPath: NSIndexPath!) {
//        
//        // Get Take object associated with cell.
//        let indexPath = collectionView.indexPathsForSelectedItems;
//        let currentCell = collectionView.cellForRowAtIndexPath(indexPath!) as UITableViewCell!;
//        
//        urltoPass = currentCell.url
//        performSegueWithIdentifier("openPlayer", sender: self)
//        
//    }


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
        
        takes.removeAll()
        
        for url in shotsTaken {
            var take : Take
            
            do {
                let asset = AVURLAsset(url: url as URL , options: nil)
                let imgGenerator = AVAssetImageGenerator(asset: asset)
                imgGenerator.appliesPreferredTrackTransform = true
                let cgImage = try imgGenerator.copyCGImage(at: CMTimeMake(0, 1), actualTime: nil)
                let thumbnail = UIImage(cgImage: cgImage)
                
                take = Take(url: url, thumbnail: thumbnail)
                takes.append(take)
                
            } catch let error {
                print("*** Error generating thumbnail: \(error.localizedDescription)")
            }
           
        }
        
    }
    
    // don't think I actually need this.
//    private func prepareToPlay(url: URL) {
//        let url = url
//        // Create asset to be played
//        
//        var asset = AVAsset(url: url)
//        
//        let assetKeys = [
//            "playable",
//            "hasProtectedContent"
//        ]
//        // Create a new AVPlayerItem with the asset and an
//        // array of asset keys to be automatically loaded
//        let playerItem = AVPlayerItem(asset: asset,
//                                  automaticallyLoadedAssetKeys: assetKeys)
//        
//        // Register as an observer of the player item's status property
//        playerItem.addObserver(self,
//                               forKeyPath: #keyPath(AVPlayerItem.status),
//                               options: [.old, .new],
//                               context: &playerItemContext)
//        
//        // Associate the player item with the player
//        let player = AVPlayer(playerItem: playerItem)
//        
//        return player
//    }
}
