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
        loadShotData()
        sortShots()
        self.tableView.reloadData()
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Shot Types"
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
        
        guard let shotViewController = segue.destination as? ShotViewController else {
            fatalError("Unexpected destination: \(segue.destination)")
        }
        
        guard let selectedCell = sender as? UITableViewCell else {
            fatalError("Unexpected sender: \(String(describing: sender))")
        }
        
        guard let indexPath = tableView.indexPath(for: selectedCell) else {
            fatalError("The selected cell is not being displayed by the table")
        }
        
        let selectedShot = shots[indexPath.row]
        shotViewController.shot = selectedShot
    }

    
    //MARK: Private Methods
    
    private func loadShotData() {
        
        shots.removeAll()
        
        //gets filepath of .csv file
        let filePath:String = Bundle.main.path(forResource: "shotData", ofType: "csv")!
        
        let stream = InputStream(fileAtPath: filePath)!
        let csv = try! CSVReader(stream: stream)
        
        //if shot has been tried, change bool value to true.
        //load my takes from local storage through DataStore
        let myTakes = DataStore.myTakes
        
        while let row = csv.next() {
            let shotName = row[0]
            let shotImageName = row[1]
            let shotImage = UIImage(named: shotImageName)!
            let shotDescription = row[2]
            
            var shotGif: String?
            let isIndexValid = row.indices.contains(3)
            if isIndexValid {
                shotGif = row[3]
            }
            
            guard let shotObject = Shot(name: shotName, photo: shotImage, gif: shotGif, description: shotDescription) else {
                    fatalError("Unable to instansiate shot")
                }
            
            if myTakes.allTakesSaved[shotObject.name] != nil {
                shotObject.tried = true
            }
            shots.append(shotObject)
        }
    }
    
    // method to sort data in table cell.  Should only be called after data has been retrieved.
    private func sortShots () {
        self.shots.sort(by: { !$0.tried && $1.tried })
    }
}
