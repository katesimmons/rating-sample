//
//  ViewController.swift
//  rating-sample
//
//  Created by Kate Simmons on 2/14/16.
//  Copyright © 2016 Kate Simmons. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    
    //outlets
    @IBOutlet weak var segmentedControls: UISegmentedControl!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var timesWornLabel: UILabel!
    @IBOutlet weak var lastWornLabel: UILabel!
    @IBOutlet weak var favoriteLabel: UILabel!
    

    
    var managedContext: NSManagedObjectContext!
    
    //keep track
    var currentBowtie: Bowtie!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //1- Call plist
        insertSampleData()
        
        
        //2- We create a fetchrequest.
        let request = NSFetchRequest(entityName:"Bowtie")
        let firstTitle = segmentedControls.titleForSegmentAtIndex(0)
        
        request.predicate = NSPredicate(format: "searchKey == %@", firstTitle!)
        
        //3- We are handle array of Bowtie objects.
        do {
            //6- Keep track currently selected.
            let results =
            try managedContext.executeFetchRequest(request) as! [Bowtie] 
            
            currentBowtie = results.first
            populate(currentBowtie)
            
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)") }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //actions
    @IBAction func wear(sender: AnyObject) {
        //this method takes the currently selected bow tie and increments its timesworn attribute by one.
        let times = currentBowtie.timesWorn!.integerValue
        
        //Unbox the integer
        currentBowtie.timesWorn = NSNumber(integer: (times + 1))
        //Update lastWorn date.
        currentBowtie.lastWorn = NSDate()
        
        
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save \(error), \(error.userInfo)")
        }
        
        populate(currentBowtie)
        print("the times worn went up")
        
    }
    
    @IBAction func rate(sender: AnyObject) {
    }

    @IBAction func segmentedControl(sender: UISegmentedControl) {
    }
    
    //insert sample data
    func insertSampleData() {
        let fetchRequest = NSFetchRequest(entityName: "Bowtie")
        
        fetchRequest.predicate =
            NSPredicate(format: "searchKey != nil")
        
        let count = managedContext.countForFetchRequest(fetchRequest,
            error: nil)
        
        if count > 0 {return }
        
        let path = NSBundle.mainBundle().pathForResource("SampleData",
            ofType: "plist")
        let dataArray = NSArray(contentsOfFile: path!)!
        
        for dict : AnyObject in dataArray {
            
            let entity = NSEntityDescription.entityForName("Bowtie",
                inManagedObjectContext: managedContext)
            
            let bowtie = Bowtie(entity: entity!,
                insertIntoManagedObjectContext: managedContext)
            
            let btDict = dict as! NSDictionary
            
            bowtie.name = btDict["name"] as? String
            bowtie.searchKey = btDict["searchKey"] as? String
            bowtie.rating = btDict["rating"] as? NSNumber
            let tintColorDict = btDict["tintColor"] as? NSDictionary
            bowtie.tintColor = colorFromDict(tintColorDict!)
            
            let imageName = btDict["imageName"] as? String
            let image = UIImage(named:imageName!)
            let photoData = UIImagePNGRepresentation(image!)
            bowtie.photoData = photoData
            
            bowtie.lastWorn = btDict["lastWorn"] as? NSDate
            bowtie.timesWorn = btDict["timesWorn"] as? NSNumber
            bowtie.isFavorite = btDict["isFavorite"] as? NSNumber
        }
    }
    
    func colorFromDict(dict: NSDictionary) -> UIColor {
        let red = dict["red"] as! NSNumber
        let green = dict["green"] as! NSNumber
        let blue = dict["blue"] as! NSNumber
        
        let color = UIColor(red: CGFloat(red)/255.0,
            green: CGFloat(green)/255.0,
            blue: CGFloat(blue)/255.0,
            alpha: 1)
        
        return color
    }
    
    //populate
    func populate(bowtie: Bowtie) {
        imageView.image = UIImage(data:bowtie.photoData!)
        nameLabel.text = bowtie.name
        ratingLabel.text = "Rating: \(bowtie.rating!.doubleValue)/5"
        
        timesWornLabel.text =
        "\(bowtie.timesWorn!.integerValue)"
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = .ShortStyle
        dateFormatter.timeStyle = .NoStyle
        
        lastWornLabel.text =
            dateFormatter.stringFromDate(bowtie.lastWorn!)
        
        favoriteLabel.hidden = !bowtie.isFavorite!.boolValue
        
        view.tintColor = bowtie.tintColor as! UIColor
    }

    
}

