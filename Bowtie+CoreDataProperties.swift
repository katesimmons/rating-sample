//
//  Bowtie+CoreDataProperties.swift
//  rating-sample
//
//  Created by Kate Simmons on 2/14/16.
//  Copyright © 2016 Kate Simmons. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Bowtie {

    @NSManaged var isFavorite: NSNumber?
    @NSManaged var lastWorn: NSDate?
    @NSManaged var name: String?
    @NSManaged var photoData: NSData?
    @NSManaged var rating: NSNumber?
    @NSManaged var searchKey: String?
    @NSManaged var timesWorn: NSNumber?
    @NSManaged var tintColor: NSObject?

}
