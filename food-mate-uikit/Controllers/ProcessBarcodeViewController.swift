//
//  ProcessBarcodeViewController.swift
//  food-mate-uikit
//
//  Created by Ruben Delgado on 03/01/2021.
//

import UIKit

class ProcessBarcodeViewController: UIViewController {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    var barcode : String?
    var foodInfo: [String: Any] = [:]
    var mealSelected : String?
    var meals = ["Desayuno", "Almuerzo", "Aperitivos", "Cena"]

    
    var name : String?
    var carbs, fats, prots, calories : Double?
    
    let networking = NetworkingService.shared
    
    @IBOutlet weak var foodName: UILabel!
    @IBOutlet weak var carbsLabel: UILabel!
    @IBOutlet weak var protsLabel: UILabel!
    @IBOutlet weak var fatsLabel: UILabel!
    @IBOutlet weak var caloriesLabel: UILabel!
    @IBOutlet weak var mealPicker: UIPickerView!
    @IBOutlet weak var quantityInput: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(barcode!)
        //barcode = "737628064502"
        self.title = "Añadir alimento"
        // Do any additional setup after loading the view
        
        let group = DispatchGroup()

        // Group our requests:
        group.enter()
        fetchFoodInformation {
          group.leave()
        }
        
        group.notify(queue: .main) {
          // Update UI
            if(self.name != nil && self.fats != nil && self.carbs != nil && self.prots != nil && self.calories != nil) {
                self.initLabels()
            } else {
                print("NO HAY SUFICIENTE INFORMACIÓN")
                self.showAlert(
                  withTitle: "No se encontró el alimento",
                  message: "El alimento no se encontraba en la base de datos. Puede añadirlo manualmente")
            }
        }
        
        self.mealPicker.delegate = self
        self.mealPicker.dataSource = self
    }
    
    func initBarcode(barcode : String) {
        self.barcode = barcode
    }
    
    func initLabels() {
        foodName.text = name
        carbsLabel.text = "\(carbs!) gr." as String
        fatsLabel.text = "\(fats!) gr." as String
        protsLabel.text = "\(prots!) gr." as String
        caloriesLabel.text = "\(calories!) kcal." as String
    }
    
    func fetchFoodInformation(completionHandler: @escaping () -> Void) {
        let urlPath = "https://world.openfoodfacts.org/api/v0/product/\(barcode ?? "737628064502").json"

            self.networking.request(urlPath) { (result) in
            switch result {
            case .success(let data):
                do {
                    guard let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] else { return }
                    print(json)
                    
                    if let nestedProduct = json["product"] as? [String: Any] {
                        if let nombre = nestedProduct["product_name"] as? String{
                            print(nombre)
                            self.name = nombre
                        }
                        if let nestedNutriments = nestedProduct["nutriments"] as? [String: Any] {
                            if let fats = nestedNutriments["fat_100g"] as? Double{
                                print(fats)
                                self.fats = fats
                            }
                            if let prots = nestedNutriments["proteins_100g"] as? Double{
                                print(prots)
                                self.prots = prots
                            }
                            if let cals = nestedNutriments["energy-kcal_100g"] as? Double{
                                print(cals)
                                self.calories = cals
                            }
                            if let carbs = nestedNutriments["carbohydrates_100g"] as? Double{
                                print(carbs)
                                self.carbs = carbs
                            }
                        }
                    }
                } catch {
                    print("Error: \(error)")
                }
            case .failure(let error): print("Error: \(error)")
                
            }
                completionHandler()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "unwindAddBC") {
            let ventanaInicio = segue.destination as! ViewController
            let newDiaryFood = DiaryFood(context: context)
            newDiaryFood.id = UUID()
            newDiaryFood.name = name
            newDiaryFood.meal = mealSelected
            newDiaryFood.foodType = "All"
            newDiaryFood.quantity = Double(quantityInput.text!)!
            newDiaryFood.carbs = carbs!
            newDiaryFood.prots = prots!
            newDiaryFood.fats = fats!
            newDiaryFood.calories = calories!
            newDiaryFood.date = Date()
            
            let foodDB = Food(context: context)
            foodDB.id = UUID()
            foodDB.name = name
            foodDB.calories = calories!
            foodDB.carbs = carbs!
            foodDB.prots = prots!
            foodDB.fats = fats!
            foodDB.type = "All"
                
            print(newDiaryFood)
            do {
                try self.context.save();
                ventanaInicio.fetchFoodDiary(date: Date());
            } catch  {
                
            }
        }
    }
    
    private func showAlert(withTitle title: String, message: String) {
      DispatchQueue.main.async {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Volver al inicio", style: .default) { action -> Void in
            self.performSegue(withIdentifier: "unwindBadBarcode", sender: self)
        })
        self.present(alertController, animated: true)
      }
    }

}

extension ProcessBarcodeViewController : UIPickerViewDelegate, UIPickerViewDataSource {
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
