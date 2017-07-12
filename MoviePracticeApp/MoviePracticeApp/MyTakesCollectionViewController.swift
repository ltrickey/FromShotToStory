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
    
//    // action when cell is tapped.
//    @IBAction func playVideo(_ sender: UITapGestureRecognizer) {
//        
//        print("name of view that was tapped >>>>")
//        let cell = (sender.view!)
//        print(self.collectionView!.indexPath(for: cell as! UICollectionViewCell))
//        
//        guard let url = URL(string: "https://devimages.apple.com.edgekey.net/samplecode/avfoundationMedia/AVFoundationQueuePlayer_HLS2/master.m3u8") else {
//            return
//        }
//        // Create an AVPlayer, passing it the HTTP Live Streaming URL.
//        let player = AVPlayer(url: url)
//        
//        // Create a new AVPlayerViewController and pass it a reference to the player.
//        let controller = AVPlayerViewController()
//        controller.player = player
//        
//        // Modally present the player and call the player's play() method when complete.
//        present(controller, animated: true) {
//            player.play()
//        }
//    }
    
       override func viewDidLoad() {
        super.viewDidLoad()
        shotsTaken = shotTypesTried[shotName!]!

        // Register cell classes
        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        loadTakes()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // MARK: - Navigation
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        print("Selected cell >>>>")
        print(indexPath)
        performSegue(withIdentifier: "sendCellDetails", sender: indexPath)
        
    }

    func prepare(for segue: UIStoryboardSegue, sender: Any) {
        
        if segue.identifier == "sendCellDetails" {
            guard let playTakeViewController = segue.destination as? PlayTakeViewController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            
            let indexPath = self.collectionView?.indexPathsForSelectedItems

            
            playTakeViewController.cellIndex = sender as! [IndexPath]
            
        }
     
        
//        print("name of cell that was tapped >>>>")
//        let cell = (sender!)
//        print(self.collectionView!.indexPath(for: cell as! UICollectionViewCell))
        
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
    
}
