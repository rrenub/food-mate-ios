//
//  SearchFoodViewController.swift
//  food-mate-uikit
//
//  Created by Ruben Delgado on 29/12/2020.
//

import UIKit

class SearchFoodViewController: UIViewController {
    
    var foodList : [Food] = []
    var filteredFood : [Food] = []
    var chosenFood : Food?
    
    let searchController = UISearchController(searchResultsController: nil)
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func onInputBarcode(_ sender: Any) {
        performSegue(withIdentifier: "inputBarcode", sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view
        
        //populateData()
        fetchFoodList()
        
        // 1
        searchController.searchResultsUpdater = self
        // 2
        searchController.obscuresBackgroundDuringPresentation = false
        // 3
        searchController.searchBar.placeholder = "Buscar alimento"
        // 4
        navigationItem.searchController = searchController
        // 5
        definesPresentationContext = true
        
        searchController.searchBar.scopeButtonTitles = FoodModel.FoodType.allCases
          .map { $0.rawValue }
        searchController.searchBar.delegate = self
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        if let indexPath = tableView.indexPathForSelectedRow {
          tableView.deselectRow(at: indexPath, animated: true)
        }
        
        for food in self.foodList {
            print(food)
        }
    }
    
    func populateData() {
        let food = Food(context: context)
        food.id = UUID()
        food.name = "Leche"
        food.calories = 200
        food.carbs = 200
        food.prots = 200
        food.fats = 200
        food.type = "Bebida"
        
        do {
            try self.context.save();
        } catch  {
            
        }
    }
    
    func fetchFoodList() {
        do {
            foodList = try context.fetch(Food.fetchRequest());
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        } catch {
            
        }
    }
    
    var isSearchBarEmpty: Bool {
      return searchController.searchBar.text?.isEmpty ?? true
    }
    
    var isFiltering: Bool {
        let searchBarScopeIsFiltering =
            searchController.searchBar.selectedScopeButtonIndex != 0
          return searchController.isActive &&
            (!isSearchBarEmpty || searchBarScopeIsFiltering)
    }
    
    func filterContentForSearchText(_ searchText: String,
                                    category: FoodModel.FoodType? = nil) {
        filteredFood = foodList.filter { (food: Food) -> Bool in
            let doesCategoryMatch = category == .todos || food.type == category?.rawValue
            
            if isSearchBarEmpty {
              return doesCategoryMatch
            } else {
              return doesCategoryMatch && food.name!.lowercased()
                .contains(searchText.lowercased())
            }
          }
          
          tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "onFoodSelected") {
            let detail = segue.destination as! FoodAddDiaryViewController
            let indexPath = tableView.indexPathForSelectedRow
            if isFiltering {
              chosenFood = filteredFood[indexPath!.row]
            } else {
              chosenFood = foodList[indexPath!.row]
            }
            detail.initFoodData(food: chosenFood!)
        }
    }
}

extension SearchFoodViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering {
            return filteredFood.count
        }
        
        return foodList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell",
                                                 for: indexPath)
        let food : Food
        if isFiltering {
            food = filteredFood[indexPath.row]
        } else {
            food = foodList[indexPath.row]
        }
        
        cell.textLabel?.text = food.name
        return cell
    }
}

extension SearchFoodViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isFiltering {
            chosenFood = filteredFood[indexPath.row]
        } else {
            chosenFood = foodList[indexPath.row]
        }
        performSegue(withIdentifier: "onFoodSelected", sender: self)
    }
}

extension SearchFoodViewController: UISearchResultsUpdating {
  func updateSearchResults(for searchController: UISearchController) {
    let searchBar = searchController.searchBar
      let category = FoodModel.FoodType(rawValue:
        searchBar.scopeButtonTitles![searchBar.selectedScopeButtonIndex])
      filterContentForSearchText(searchBar.text!, category: category)
  }
}

extension SearchFoodViewController: UISearchBarDelegate {
  func searchBar(_ searchBar: UISearchBar,
      selectedScopeButtonIndexDidChange selectedScope: Int) {
    let category = FoodModel.FoodType(rawValue:
      searchBar.scopeButtonTitles![selectedScope])
    filterContentForSearchText(searchBar.text!, category: category)
  }
}
