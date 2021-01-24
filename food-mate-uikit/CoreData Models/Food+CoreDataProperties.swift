//
//  Food+CoreDataProperties.swift
//  food-mate-uikit
//
//  Created by Ruben Delgado on 31/12/2020.
//
//

import Foundation
import CoreData


extension Food {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Food> {
        return NSFetchRequest<Food>(entityName: "Food")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var carbs: Double
    @NSManaged public var prots: Double
    @NSManaged public var fats: Double
    @NSManaged public var calories: Double
    @NSManaged public var type: String?
    @NSManaged public var name: String?

}

extension Food : Identifiable {

}
