//
//  Weather+CoreDataProperties.swift
//  
//
//  Created by Андрей Дорош on 06.08.17.
//
//

import Foundation
import CoreData


extension Weather {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Weather> {
        return NSFetchRequest<Weather>(entityName: "Weather")
    }

    @NSManaged public var cityName: String?
    @NSManaged public var lat: Double
    @NSManaged public var lng: Double
    @NSManaged public var temp: String?
    @NSManaged public var desc: String?

}
