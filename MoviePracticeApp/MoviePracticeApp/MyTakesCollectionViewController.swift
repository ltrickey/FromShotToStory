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

class MyTakesCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    //MARK: properties
    
    var takes = [Take]()
    
    private let reuseIdentifier = "Cell"
    
    fileprivate let itemsPerRow: CGFloat = 3
    
    fileprivate let sectionInsets = UIEdgeInsets(top: 50.0, left: 20.0, bottom: 50.0, right: 20.0)

    
    // variable of Shot Name, sent from shot view.
    var shotName : String?
    
    // the array of shot URLs - not filled until viewDidLoad
    var shotsTaken: [URL] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        shotsTaken = shotTypesTried[shotName!]!

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // MARK: - Navigation

    func prepare(for segue: UIStoryboardSegue, sender: MyTakesCollectionViewCell?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
     
        let destination = segue.destination as! AVPlayerViewController
        print("This is the senter object")
        print(sender)
//        let url = shotsTaken[indexPath.item]

     
//        if let movieURL = url {
//            destination.player = AVPlayer(url: movieURL)
//        }
  
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
        
        // Fetches the appropriate meal for the data source layout.
        let filePath = shotsTaken[indexPath.item]
        print("filepath >>>")
        print(filePath)
        
//        let fileURL = NSURL(string: filePathString)
//        print("filepath URL >>>")
//        print(fileURL)
        
        do {
            let asset = AVURLAsset(url: filePath as URL , options: nil)
            let imgGenerator = AVAssetImageGenerator(asset: asset)
            imgGenerator.appliesPreferredTrackTransform = true
            let cgImage = try imgGenerator.copyCGImage(at: CMTimeMake(0, 1), actualTime: nil)
            let thumbnail = UIImage(cgImage: cgImage)
            
            
            cell.savedShotThumbnail.image = thumbnail
            
        } catch let error {
            print("*** Error generating thumbnail: \(error.localizedDescription)")
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

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */


    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }


    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */
    
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
                
//                cell.savedShotThumbnail.image = thumbnail
                
                take = Take(url: url, thumbnail: thumbnail)
                takes.append(take)
                
            } catch let error {
                print("*** Error generating thumbnail: \(error.localizedDescription)")
            }
           
        }
        
    }
}
