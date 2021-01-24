//
//  FoodAddViewController.swift
//  food-mate-uikit
//
//  Created by Ruben Delgado on 29/12/2020.
//

import UIKit

class FoodAddViewController: UIViewController {

    @IBOutlet weak var productNameInput: UITextField!
    
    @IBOutlet weak var typeFood: UIPickerView!
    @IBOutlet weak var meal: UIPickerView!
    
    @IBOutlet weak var carbsInput: UITextField!
    @IBOutlet weak var fatsInput: UITextField!
    @IBOutlet weak var protsInput: UITextField!
    @IBOutlet weak var calInput: UITextField!
    @IBOutlet weak var quantityInput: UITextField!
    
    var mealSelected : String?
    var foodTypeSelected : String?
    
    var foodTypes = FoodModel.FoodType.allCases
    var meals = ["Desayuno", "Almuerzo", "Aperitivos", "Cena"]
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.typeFood.delegate = self
        self.typeFood.dataSource = self
        self.meal.delegate = self
        self.meal.dataSource = self
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //if(segue.identifier == "unwindInicio") {
        let ventanaInicio = segue.destination as! ViewController
        let newDiaryFood = DiaryFood(context: context)
        newDiaryFood.id = UUID()
        newDiaryFood.name = productNameInput.text
        newDiaryFood.meal = mealSelected
        newDiaryFood.foodType = foodTypeSelected
        newDiaryFood.quantity = Double(quantityInput.text!)!
        newDiaryFood.carbs = Double(carbsInput.text!)!
        newDiaryFood.prots = Double(protsInput.text!)!
        newDiaryFood.fats = Double(fatsInput.text!)!
        newDiaryFood.calories = Double(calInput.text!)!
        newDiaryFood.date = Date()
        
        let foodDB = Food(context: context)
        foodDB.id = UUID()
        foodDB.name = productNameInput.text
        foodDB.calories = Double(calInput.text!)!
        foodDB.carbs = Double(carbsInput.text!)!
        foodDB.prots = Double(protsInput.text!)!
        foodDB.fats = Double(fatsInput.text!)!
        foodDB.type = foodTypeSelected
            
        print(newDiaryFood)
        do {
            try self.context.save();
            ventanaInicio.fetchFoodDiary(date: Date());
        } catch  {
            
        }
        //}
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

extension FoodAddViewController : UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView.tag == 1 {
            return foodTypes.count
        } else {
            return meals.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView.tag == 1 {
            return foodTypes[row].rawValue
        } else {
            return meals[row]
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView.tag == 1 {
            foodTypeSelected = foodTypes[row].rawValue
        } else {
            mealSelected = meals[row]

        }
    }
}

