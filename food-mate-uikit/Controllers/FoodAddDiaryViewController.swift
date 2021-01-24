//
//  FoodAddDiaryViewController.swift
//  food-mate-uikit
//
//  Created by Ruben Delgado on 29/12/2020.
//

import UIKit

class FoodAddDiaryViewController: UIViewController {
    
    
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var food : Food?
    var mealSelected : String?
    
    @IBAction func onDeleteButton(_ sender: Any) {
        
    }
    
    @IBOutlet weak var foodName: UILabel!
    @IBOutlet weak var foodType: UILabel!
    
    @IBOutlet weak var carbsLabel: UILabel!
    @IBOutlet weak var protsLabel: UILabel!
    @IBOutlet weak var fatsLabel: UILabel!
    @IBOutlet weak var caloriesLabel: UILabel!
    
    @IBOutlet weak var meal: UIPickerView!
    
    @IBOutlet weak var quantityInput: UITextField!
    @IBAction func addFoodButton(_ sender: Any) {
        
    }
    var meals = ["Desayuno", "Almuerzo", "Aperitivos", "Cena"]

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        foodName.text = food?.name
        foodType.text = food?.type
        carbsLabel.text = "\(String(food!.carbs)) gr."
        protsLabel.text = "\(String(food!.prots)) gr."
        fatsLabel.text = "\(String(food!.fats)) gr."
        caloriesLabel.text = "\(String(food!.calories)) gr."
        
        self.meal.delegate = self
        self.meal.dataSource = self
    }
    
    func initFoodData(food : Food) {
        self.food = food
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "unwindAdd") {
            let newDiaryFood = DiaryFood(context: context)
            let inicio = segue.destination as! ViewController
            newDiaryFood.id = UUID()
            newDiaryFood.name = foodName.text
            newDiaryFood.meal = mealSelected
            newDiaryFood.foodType = food!.type
            newDiaryFood.quantity = Double(quantityInput.text!)!
            newDiaryFood.carbs = food!.carbs
            newDiaryFood.prots = food!.prots
            newDiaryFood.fats = food!.fats
            newDiaryFood.calories = food!.calories
            newDiaryFood.date = Date()
            
            print(newDiaryFood)
            
            do {
                try self.context.save();
                inicio.fetchFoodDiary(date: Date())
            } catch  {
                
            }
        }
        
        if(segue.identifier == "unwindDelete") {
            context.delete(food!)
            do {
                try self.context.save();
            } catch  {
                
            }
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
}

extension FoodAddDiaryViewController : UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return meals.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return meals[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        mealSelected = meals[row]
    }
}
