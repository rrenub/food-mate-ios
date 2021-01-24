//
//  DetailDiaryViewController.swift
//  food-mate-uikit
//
//  Created by Ruben Delgado on 29/12/2020.
//

import UIKit

class DetailDiaryViewController: UIViewController {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    @IBOutlet weak var foodName: UILabel!
    @IBOutlet weak var foodType: UILabel!
    
    @IBOutlet weak var carbsLabel: UILabel!
    @IBOutlet weak var protsLabel: UILabel!
    @IBOutlet weak var fatsLabel: UILabel!
    @IBOutlet weak var caloriesLabel: UILabel!
    @IBOutlet weak var quantityInput: UITextField!
    
    @IBAction func deleteButton(_ sender: Any) {
        context.delete(food!)
        do {
            try self.context.save();
        } catch  {
            
        }
        performSegue(withIdentifier: "unwindBorrar", sender: self)
    }
    
    var food : DiaryFood?

    override func viewDidLoad() {
        super.viewDidLoad()
        foodName.text = food?.name
        foodType.text = food?.foodType
        carbsLabel.text = String(food!.carbs)
        protsLabel.text = String(food!.prots)
        fatsLabel.text = String(food!.fats)
        caloriesLabel.text = String(food!.calories)
        quantityInput.placeholder = String(food!.quantity)
        
        // Do any additional setup after loading the view.
    }
    
    func initFood(food : DiaryFood) {
        self.food = food
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "unwindEditar") {
            let inicio = segue.destination as! ViewController
            food!.quantity = Double(quantityInput.text!)!
            do {
                try self.context.save();
                inicio.fetchFoodDiary(date: Date())
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
