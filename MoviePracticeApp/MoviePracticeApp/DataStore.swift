//
//  DataStore.swift
//  MoviePracticeApp
//
//  Created by Lynn Trickey on 7/13/17.
//  Copyright © 2017 Lynn Trickey. All rights reserved.
//

import Foundation

class DataStore: NSObject, NSCoding {
    
    static let myTakes = loadData()
    
    var allTakesSaved = [String:[Take]]()
    
    private override init() {
        self.allTakesSaved = [String: [Take]]();
    }
    
    required init(coder decoder: NSCoder) {
        self.allTakesSaved = (decoder.decodeObject(forKey: "allTakesSaved") as? [String: [Take]])!
    }
    
    func encode(with coder: NSCoder) {
        coder.encode(allTakesSaved, forKey: "allTakesSaved")
    }
    
    static var filePath: String {
        //1 - manager lets you examine contents of a files and folders in your app; creates a directory to where we are saving it
        let manager = FileManager.default
        //2 - this returns an array of urls from our documentDirectory and we take the first path
        let url = manager.urls(for: .documentDirectory, in: .userDomainMask).first
        print("this is the url path in the documentDirectory \(String(describing: url))")
        //3 - creates a new path component and creates a new file called "Data" which is where we will store our Data array.
        return (url!.appendingPathComponent("Data").path)
    }
    
    func saveTake(shot: String, take: Take) {
        if var shotArr = DataStore.myTakes.allTakesSaved[shot] {
            shotArr.append(take)
            DataStore.myTakes.allTakesSaved[shot] = shotArr
        } else {
            DataStore.myTakes.allTakesSaved[shot] = [take]
        }
        NSKeyedArchiver.archiveRootObject(self, toFile: DataStore.filePath)
    }
    
    func deleteTake(shot: String, take: Take) {
        if var shotArr = DataStore.myTakes.allTakesSaved[shot] {
            print("original shot array")
            print(DataStore.myTakes.allTakesSaved[shot])
            
            //remove shot from array
            shotArr = shotArr.filter{$0 != take}
            
            //save it back in shot arr
            DataStore.myTakes.allTakesSaved[shot] = shotArr
            
            //just to make sure it's been deleted.
            print("new shot array")
            print(DataStore.myTakes.allTakesSaved[shot])
            
            print(DataStore.myTakes.allTakesSaved)
        } else {
            print("THAT SHOT IS NOT IN YOUR ARRAY AND CANNOT BE DELETED !")
        }
        NSKeyedArchiver.archiveRootObject(self, toFile: DataStore.filePath)
    }
    
    private static func loadData() -> DataStore {
        if let data = NSKeyedUnarchiver.unarchiveObject(withFile: filePath) as? DataStore {
            return data
        } else {
            return DataStore()
        }
    }
}
