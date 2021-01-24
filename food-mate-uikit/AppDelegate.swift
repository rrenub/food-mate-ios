//
//  AppDelegate.swift
//  food-mate-uikit
//
//  Created by Ruben Delgado on 28/12/2020.
//

import UIKit
import CoreData

@main
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        checkDataStore()
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "FoodMateDataModel")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func checkDataStore() {
        do {
            let foodCount = try persistentContainer.viewContext.count(for: Food.fetchRequest())
            print("Lista de comida: \(foodCount)")
            uploadFoodList()
        } catch {
            
        }
    }
    
    func uploadFoodList() {
        if let path = Bundle.main.path(forResource: "food", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                guard let json = try JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]] else { return }
                print(json)
                let foodlist : [Food] = json.compactMap { [weak self] in
                    guard
                        let name = $0["name"] as? String,
                        let type = $0["type"] as? String,
                        let carbs = $0["carbs"] as? String,
                        let fats = $0["carbs"] as? String,
                        let prots = $0["prots"] as? String,
                        let calories = $0["calories"] as? String
                        else { return nil }
                    
                    let food = Food(context: self!.persistentContainer.viewContext)
                    food.id = UUID()
                    food.name = name
                    food.type = type
                    food.carbs = Double(carbs)!
                    food.fats = Double(fats)!
                    food.prots = Double(prots)!
                    food.calories = Double(calories)!
                    return food
                }
                
                print(foodlist)
            } catch {
                
            }
        }
    }
}

