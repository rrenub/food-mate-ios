//
//  InputBarcodeViewController.swift
//  food-mate-uikit
//
//  Created by Ruben Delgado on 03/01/2021.
//

import UIKit

class InputBarcodeViewController: UIViewController {

    @IBOutlet weak var barcodeInput: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.title = "Escanear producto"
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "searchBarcode") {
            let nextView = segue.destination as! ProcessBarcodeViewController
            nextView.initBarcode(barcode: barcodeInput.text!)
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
