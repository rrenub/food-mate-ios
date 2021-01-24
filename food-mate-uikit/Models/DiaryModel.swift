//
//  DiaryModel.swift
//  food-mate-uikit
//
//  Created by Ruben Delgado on 10/01/2021.
//
import UIKit
import Foundation
import CoreData

protocol DiaryModel {
    func fetchDiaryFood(date : Date) -> [DiaryFood]?
}

class DiaryModelImpl : DiaryModel {
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    func fetchDiaryFood(date: Date) -> [DiaryFood]? {
        let request = DiaryFood.fetchRequest() as NSFetchRequest<DiaryFood>
        
        var calendar = Calendar.current
        calendar.timeZone = NSTimeZone.local
        
        let dateFrom = calendar.startOfDay(for: date) // eg. 2016-10-10 00:00:00
        print(dateFrom.debugDescription)
        let dateTo = calendar.date(byAdding: .day, value: 1, to: dateFrom)
        print(dateTo!.debugDescription)
        
        let fromPredicate = NSPredicate(format: "date >= %@", dateFrom as NSDate)
        let toPredicate = NSPredicate(format: "date < %@", dateTo! as NSDate)
        let datePredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [fromPredicate, toPredicate])
        request.predicate = datePredicate
        
        let foodList = try! context.fetch(request) as [DiaryFood]?;
        
        return foodList
    }
}
