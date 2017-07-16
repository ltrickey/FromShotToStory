//
//  ShotTableViewController.swift
//  MoviePracticeApp
//
//  Created by Lynn Trickey on 7/5/17.
//  Copyright © 2017 Lynn Trickey. All rights reserved.
//

import UIKit
import CSV

class ShotTableViewController: UITableViewController {
    
    //MARK: Properties
    
    var shots = [Shot]()
    
    // should rerender shot objects every time about to see table.
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        print("reloading data")
        self.tableView.reloadData()
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // read in .txt and turn int into a string
        let shotData: String? = readDataFromFile(file: "shotData")
        
        if shotData != nil {
            loadShots(data: (shotData)!)
        } else {
            print("shot data is nil!")
        }
        
        navigationItem.title = "Shot List"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shots.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Fetches the appropriate shot for the data source layout.
        let shot = shots[indexPath.row]
        
        // change cell layout if shot has been tried.
        if shot.tried == false {

            let cellIdentifier = "ShotTableViewCell"
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? ShotTableViewCell  else {
                fatalError("The dequeued cell is not an instance of ShotTableViewCell.")
            }
            
            cell.nameLabel.text = shot.name
            cell.photoImageView.image = shot.photo
            
            return cell
        } else {
            let cellIdentifier = "TriedShotTableViewCell"
        
            guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? TriedShotTableViewCell  else {
                fatalError("The dequeued cell is not an instance of TriedShotTableViewCell.")
            }

            cell.nameLabel.text = shot.name
            cell.photoImageView.image = shot.photo
            
            return cell
        }

    }

    // MARK: - Navigation

    // send the data along when clicked.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        guard let ShotViewController = segue.destination as? ShotViewController else {
            fatalError("Unexpected destination: \(segue.destination)")
        }
        
        guard let selectedCell = sender as? UITableViewCell else {
            fatalError("Unexpected sender: \(String(describing: sender))")
        }
        
        guard let indexPath = tableView.indexPath(for: selectedCell) else {
            fatalError("The selected cell is not being displayed by the table")
        }
        
        let selectedShot = shots[indexPath.row]
        ShotViewController.shot = selectedShot
    }

    
    //MARK: Private Methods
    
    private func loadShots(data: String) {
        
        shots.removeAll()
        
        let rows = data.components(separatedBy: "\n")
        for row in rows {
            let data = row.components(separatedBy: ";")
            guard let shotObject = Shot(name: data[0], photo: UIImage(named: data[0])!, video: nil, description: data[1]) else {
                fatalError("Unable to instansiate shot")
            }
            
            shots.append(shotObject)
            
        }
    }
        
//        let description = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Suspendisse commodo arcu vel arcu ornare interdum. Nullam sed tempus purus, id bibendum leo. In sed pellentesque elit. Nulla facilisis tincidunt est ac malesuada. Integer ligula nunc, cursus in accumsan et, tempor nec quam."
//        
//        
//        struct shotData  {
//            var name : String
//            var photo : UIImage
//            var description : String
//            
//            init(name: String, photo: UIImage, description : String)
//            {
//                self.name = name
//                self.photo = photo
//                self.description = description
//            }
//        }
//        
//        var shotList = [shotData]()
//        
//        shotList.append(shotData(name: "Establishing", photo: UIImage(named: "establishingShot")!, description : description))
//        
//        shotList.append(shotData(name: "Wide", photo: UIImage(named: "wideShot")!, description : description))
//        
//        shotList.append(shotData(name: "Medium", photo: UIImage(named: "mediumShot")!, description : description))
//        
//        shotList.append(shotData(name: "Close Up", photo: UIImage(named: "closeUpShot")!, description: description))
//        
//        shotList.append(shotData(name: "Extreme Close Up", photo: UIImage(named: "extremeCloseUpShot")!, description : description))
//        
//        shotList.append(shotData(name: "Over the Shoulder", photo: UIImage(named: "overTheShoulderShot")!, description : description))
//        
//        shotList.append(shotData(name: "Point of View", photo: UIImage(named: "pointOfViewShot")!, description : description))
//        
//        shotList.append(shotData(name: "Insert", photo: UIImage(named: "insertShot")!, description : description))
//        
//        shotList.append(shotData(name: "Low", photo: UIImage(named: "lowAngleShot")!, description : description))
//        
//         shotList.append(shotData(name: "High", photo: UIImage(named: "highAngleShot")!, description : description))
//        
//        shotList.append(shotData(name: "Front", photo: UIImage(named: "frontAngleShot")!, description : description))
//       
//        shotList.append(shotData(name: "Three Quarter", photo: UIImage(named: "threeQuarterAngleShot")!, description : description))
//        
//        shotList.append(shotData(name: "Profile", photo: UIImage(named: "profileAngleShot")!, description : description))
//        
//        
//        
//        for (shot) in shotList {
//            guard let shotObject = Shot(name: shot.name, photo: shot.photo, video: nil, description: shot.description) else {
//                fatalError("Unable to instansiate shot")
//            }
//            
//            //if shot has been tried, change bool value to true.
//            //load my takes from local storage through DataStore
//            let myTakes = DataStore.myTakes
//            
//            print(myTakes)
//            
//            if myTakes.allTakesSaved[shotObject.name] != nil {
//                shotObject.tried = true
//            }
//            
//            shots.append(shotObject)
//        }
//        
//    }
    
    func readDataFromFile(file:String) -> String? {
        
        //gets filepath of .txt file
        let filePath:String = Bundle.main.path(forResource: "shotData", ofType: "txt")!
        
        print("filePath is >>>>> ")
        print(filePath)
        
        //tries to read it in as a string
        do {
            let contents = try? String(contentsOfFile: filePath)
            return contents
            print("the contents of this file is >>>")
            print(contents!)
        } catch {
            print("File Read Error for file \(filePath)")
            return nil
        }

        
    }
    

}
