//
//  ShotTableViewController.swift
//  MoviePracticeApp
//
//  Created by Lynn Trickey on 7/5/17.
//  Copyright © 2017 Lynn Trickey. All rights reserved.
//

import UIKit

class ShotTableViewController: UITableViewController {
    
    //MARK: Properties
    
    var shots = [Shot]()

    override func viewDidLoad() {
        super.viewDidLoad()
        loadShots()
        print(shots)
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
        
        // Table view cells are reused and should be dequeued using a cell identifier.
        let cellIdentifier = "ShotTableViewCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? ShotTableViewCell  else {
            fatalError("The dequeued cell is not an instance of ShotTableViewCell.")
        }
        
        // Fetches the appropriate meal for the data source layout.
        let shot = shots[indexPath.row]
        
        cell.nameLabel.text = shot.name
        cell.photoImageView.image = shot.photo
        cell.descriptionLabel.text = shot.description

        return cell
    }


    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    //MARK: Private Methods
    
    private func loadShots() {
        
        let description = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Suspendisse commodo arcu vel arcu ornare interdum. Nullam sed tempus purus, id bibendum leo. In sed pellentesque elit. Nulla facilisis tincidunt est ac malesuada. Integer ligula nunc, cursus in accumsan et, tempor nec quam. Maecenas in volutpat sapien, sit amet semper ligula. Integer vel ligula leo. Donec eget augue sed felis congue eleifend in eu nisi. Vestibulum libero justo, efficitur at tincidunt nec, malesuada vitae dui."
        
        let shotData = [
            "Establishing": [UIImage(named: "establishingShot")!, description],
            "Extreme Close Up": [UIImage(named: "extremeCloseUpShot")!, description],
            "Front Angle": [UIImage(named: "frontAngleShot")!, description],
            "High Angle": [UIImage(named: "highAngleShot")!, description],
            "Insert": [UIImage(named: "insertShot")!, description],
            "Low Angle": [UIImage(named: "lowAngleShot")!, description],
            "Medium": [UIImage(named: "mediumShot")!, description],
            "Over the Shoulder": [UIImage(named: "overTheShoulderShot")!, description],
            "Point of View": [UIImage(named: "pointOfViewShot")!, description],
            "Profile": [UIImage(named: "profileAngleShot")!, description],
            "Three Quarter Angle": [UIImage(named: "threeQuarterAngleShot")!, description],
            "Wide": [UIImage(named: "wideShot")!, description]
        ]
        
        
        for (name, data) in shotData {
            
            guard let shot = Shot(name: name, photo: (data[0] as! UIImage), video: nil, description: (data[1] as! String)) else {
                fatalError("Unable to instansiate shot" + name)
            }
            
            shots.append(shot)
        }
        
    }
    
}
