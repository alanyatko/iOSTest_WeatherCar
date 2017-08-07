//
//  Car+CoreDataProperties.swift
//  
//
//  Created by Андрей Дорош on 05.08.17.
//
//

import Foundation
import CoreData


extension Car {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Car> {
        return NSFetchRequest<Car>(entityName: "Car")
    }

    @NSManaged public var carId: Int32
    @NSManaged public var condition: String?
    @NSManaged public var desc: String?
    @NSManaged public var engine: String?
    @NSManaged public var images: NSObject?
    @NSManaged public var name: String?
    @NSManaged public var price: String?
    @NSManaged public var transmission: String?

}
