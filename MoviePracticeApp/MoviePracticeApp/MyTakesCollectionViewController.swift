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
    
    var editModeEnabled = false
    
    //MARK: properties
    
    @IBOutlet weak var editButton: UIBarButtonItem!
    
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
        
        // get takes from local data - could be nil if never saved before.
        let alltakesSaved = NSKeyedUnarchiver.unarchiveObject(withFile: Take.ArchiveURL.path) as? [String: [URL]]
        
        shotsTaken = (alltakesSaved?[shotName!])!
    
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
    
    //MARK: - ACTIONS
    
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
    
    // MARK: The navigation bar's Edit button functions
    func deleteTakeCell(sender:UIButton) {
        // Put the index number of the delete button the use tapped in a variable
        let i: Int = (sender.layer.value(forKey: "index")) as! Int
        // Remove an object from the collection view's dataSource
        shotsTaken.remove(at: i)
        //NEED TO THEN UPDATE THIS to LOCAL STORAGE!
        
        // Refresh the collection view
        self.collectionView!.reloadData()
    }

    @IBAction func editTakes(_ sender: UIBarButtonItem) {
        if(editModeEnabled == false) {
            // Put the collection view in edit mode
            editButton.title = "Done"
            self.editButton.style = .done
            editModeEnabled = true
            
            // Loop through the collectionView's visible cells
            for item in self.collectionView!.visibleCells as [UICollectionViewCell] {
                var indexPath: NSIndexPath = self.collectionView!.indexPath(for: item as UICollectionViewCell)! as NSIndexPath
                var cell: MyTakesCollectionViewCell = self.collectionView!.cellForItem(at: indexPath as IndexPath) as! MyTakesCollectionViewCell
                cell.deleteButton.isHidden = false // show all of the delete buttons
            }
        } else {
            // Take the collection view out of edit mode
            editButton.style = .plain
            editButton.title = "Edit"
            editModeEnabled = false
            
            // Loop through the collectionView's visible cells
            for item in self.collectionView!.visibleCells as [UICollectionViewCell] {
                var indexPath: NSIndexPath = self.collectionView!.indexPath(for: item as UICollectionViewCell)! as NSIndexPath
                var cell: MyTakesCollectionViewCell = self.collectionView!.cellForItem(at: indexPath as IndexPath) as! MyTakesCollectionViewCell
                cell.deleteButton.isHidden = false // show all of the delete buttons
            }
        }
    }
    
    
//    @IBAction func trashTake(_ sender: Any) {
//        var deletedTakes:[Take] = []
//        
//        let indexpaths = collectionView?.indexPathsForSelectedItems()
//        
//        if let indexpaths = indexpaths {
//            
//            for item  in indexpaths {
//                let cell = collectionView!.cellForItemAtIndexPath(item as! NSIndexPath)
//                
//                collectionView?.deselectItemAtIndexPath(item as? NSIndexPath, animated: true)
//                
////                // fruits for section
////                let sectionfruits = dataSource.fruitsInGroup(item.section)
////                deletedFruits.append(sectionfruits[item.row])
////            }
////            
////            dataSource.deleteItems(deletedFruits)
////            
////            collectionView?.deleteItemsAtIndexPaths(indexpaths)
//        }
//    }
//    

    // MARK: - Editing
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        collectionView?.allowsMultipleSelection = editing
//        deleteCellToolBar.isHidden = !editing
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
        
        if self.navigationItem.rightBarButtonItem!.title == "Edit" {
            cell.deleteButton.isHidden = true
        } else {
            cell.deleteButton.isHidden = false
        }
        
        // Give the delete button an index number
        cell.deleteButton.layer.setValue(indexPath.row, forKey: "index")
        
        // Add an action function to the delete button
        cell.deleteButton.addTarget(self, action: "deleteTakeCell:", for: UIControlEvents.touchUpInside)
        
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
