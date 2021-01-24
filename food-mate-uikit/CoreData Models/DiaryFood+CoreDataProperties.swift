//
//  DiaryFood+CoreDataProperties.swift
//  food-mate-uikit
//
//  Created by Ruben Delgado on 31/12/2020.
//
//

import Foundation
import CoreData


extension DiaryFood {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DiaryFood> {
        return NSFetchRequest<DiaryFood>(entityName: "DiaryFood")
    }

    @NSManaged public var name: String?
    @NSManaged public var quantity: Double
    @NSManaged public var carbs: Double
    @NSManaged public var prots: Double
    @NSManaged public var fats: Double
    @NSManaged public var calories: Double
    @NSManaged public var id: UUID?
    @NSManaged public var meal: String?
    @NSManaged public var foodType: String?
    @NSManaged public var date: Date?

}

extension DiaryFood : Identifiable {

}
