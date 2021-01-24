//
//  ViewController.swift
//  food-mate-uikit
//
//  Created by Ruben Delgado on 28/12/2020.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    
    var DiaryModel : DiaryModel?
    
    @IBOutlet weak var caloriesLabel: UILabel!
    @IBOutlet weak var fatsLabel: UILabel!
    @IBOutlet weak var protsLabel: UILabel!
    @IBOutlet weak var carbsLabel: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func unwindInicio(_ seg: UIStoryboardSegue) {
        self.fetchFoodDiary(date: currentDay!)
    }
    
    @IBAction func onNextDayButton(_ sender: Any) {
        currentDay = Calendar.current.date(byAdding: .day, value: 1, to: currentDay!)
        setDateTitle(date: currentDay!)
        fetchFoodDiary(date: currentDay!)
    }
    
    @IBAction func onPastDayButton(_ sender: Any) {
        currentDay = Calendar.current.date(byAdding: .day, value: -1, to: currentDay!)
        setDateTitle(date: currentDay!)
        fetchFoodDiary(date: currentDay!)
    }
    
    var currentDay : Date?
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var foodList : [DiaryFood]?
    
    var meals = [Meal]()
    
    var foodDetail : DiaryFood?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        currentDay = Date()
        self.setDateTitle(date: currentDay!)
        
        //populateMockData()
        fetchFoodDiary(date: currentDay!)
        
        tableView.dataSource = self
        tableView.delegate = self
        self.tableView.contentInset = UIEdgeInsets(top: 20,left: 0,bottom: 0,right: 0)
    }
    
    func setDateTitle(date : Date) {
        let dayFormatter = DateFormatter()
        dayFormatter.dateStyle = .long
        dayFormatter.locale = Locale(identifier: "es")
        self.title = dayFormatter.string(from: currentDay!)
    }
    
    func refreshTable() {
        //if(!(self.foodList!.isEmpty)) {
            let groups = Dictionary(grouping: self.foodList!) { (food) in
                return food.meal
            }
            
            
            
            self.meals = groups.map { (key, values) in
                return Meal(name: key ?? "Comidas", foodList: values)
            }
            
            print("MEALS :::::::::::: ")
            for meal in meals {
                print(meal)
            }
            print(":::::::::::: ")
             
            
            meals = meals.sorted{ $0.name < $1.name }
        //}
    }
    
    func fetchFoodDiary(date : Date) {
        foodList = self.DiaryModel?.fetchDiaryFood(date: currentDay!)
        DispatchQueue.main.async {
            self.calcNutrients();
            self.refreshTable()
            self.tableView.reloadData();
        }
    }
    
    func calcNutrients() {
        var totalCarbs = 0.0
        var totalFats = 0.0
        var totalProts = 0.0
        var totalCalories = 0.0
        for food in foodList! {
            totalCalories += calcGramsPer100(nutrient: food.calories, quantity: food.quantity)
            totalCarbs += calcGramsPer100(nutrient: food.carbs, quantity: food.quantity)
            totalFats += calcGramsPer100(nutrient: food.fats, quantity: food.quantity)
            totalProts += calcGramsPer100(nutrient: food.prots, quantity: food.quantity)
        }
        DispatchQueue.main.async {
            self.carbsLabel.text = "\(totalCarbs) gr."
            self.fatsLabel.text = "\(totalFats) gr."
            self.protsLabel.text = "\(totalProts) gr."
            self.caloriesLabel.text = "\(totalCalories) kcal"
        }
    }
    
    func calcGramsPer100(nutrient : Double, quantity : Double) -> Double {
        return (nutrient * quantity) / 100.0
    }
    
    func populateMockData() {
        let platano = DiaryFood(context: context)
        platano.id = UUID()
        platano.foodType = "\(FoodModel.FoodType.fruta.rawValue)"
        platano.name = "Platano"
        platano.meal = "Desayuno"
        platano.quantity = 40
        platano.carbs = 20
        platano.prots = 20
        platano.fats = 20
        platano.calories = 20
        platano.date = Date()
        
        do {
            try self.context.save();
        } catch  {
            
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "detailDiary") {
            let detailView = segue.destination as! DetailDiaryViewController
            detailView.food = foodDetail
        }
    }
}

extension ViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.meals.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let meal = meals[section]
        return meal.name
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let meal = meals[section]
        return meal.foodList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "foodCell", for: indexPath) as! FoodDailyTableViewCell;
        
        let pos = indexPath.row
        let mealsection = meals[indexPath.section]
        let fooditem = mealsection.foodList[pos]
        
        cell.foodName.text = fooditem.name;
        cell.quantity.text = String(fooditem.quantity) + " gr";

        return cell;
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let pos = indexPath.row
        let mealsection = meals[indexPath.section]
        foodDetail = mealsection.foodList[pos]
        performSegue(withIdentifier: "detailDiary", sender: self)
    }
}

class FoodDailyTableViewCell : UITableViewCell {
    
    @IBOutlet weak var foodName: UILabel!
    
    @IBOutlet weak var quantity: UILabel!
    
}

