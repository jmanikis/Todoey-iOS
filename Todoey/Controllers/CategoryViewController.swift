//
//  TableViewController.swift
//  Todoey
//
//  Created by JC Manikis on 2021-07-12.
//  Copyright © 2021 App Brewery. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class CategoryViewController: SwipeTableViewController {
   
   let realm = try! Realm()
   var categories: Results<Category>?
   
   override func viewDidLoad() {
      super.viewDidLoad()
      tableView.separatorStyle = .none
   
      loadCategories()
   }
   
   override func viewWillAppear(_ animated: Bool) {
      guard let navBar = navigationController?.navigationBar
      else {fatalError("Navigation Controller does not exist")
      }
      
      navBar.backgroundColor = UIColor(hexString: "1D9BF6")
      navBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: ContrastColorOf(navBar.backgroundColor!, returnFlat: true)]
   }
   
   @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
      
      var textField = UITextField()
      let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
      
      let action = UIAlertAction(title: "Add", style: .default) { (action) in
         let newCategory = Category()
         newCategory.name = textField.text!
         newCategory.colorHex = UIColor.randomFlat().hexValue()
         
         self.save(category: newCategory)
      }
      
      alert.addAction(action)
      
      alert.addTextField { (field) in
         textField = field
         textField.placeholder = "Add New Category"
      }
      
      present(alert, animated: true, completion: nil)
      
   }
   
   
   
   //MARK: - TableView DataSoure Methods
   override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      return categories?.count ?? 1
   }
   
   override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      let cell = super.tableView(tableView, cellForRowAt: indexPath)
      
      if let category = categories?[indexPath.row] {
         cell.textLabel?.text = categories?[indexPath.row].name ?? "No Categories Added Yet"
         
         guard let categoryColor = UIColor(hexString: category.colorHex) else {fatalError()}
         
         cell.backgroundColor = categoryColor
         cell.textLabel?.textColor = ContrastColorOf(categoryColor, returnFlat: true)
         
      }
      
      return cell
   }
   
   //MARK: - TableView Delegate Methods
   override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      //Prepare Segue
      performSegue(withIdentifier: "toToItems", sender: self)
   }
   
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
      let destinationVC = segue.destination as! ToDoListViewController
      
      if let indexPath = tableView.indexPathForSelectedRow {
         destinationVC.selectedCategory = categories?[indexPath.row]
      }
   }
   
   
   //MARK: - Data Manipulation Methods
   func save(category: Category) {
      do {
         try realm.write{
            realm.add(category)
         }
      } catch {
         print("Error Saving Data: \(error)")
      }
      tableView.reloadData()
   }
   
   
   func loadCategories() {
      categories = realm.objects(Category.self)
      tableView.reloadData()
   }
   
   override func updateModel(at indexPath: IndexPath) {
      if let categoryForDeletion = self.categories?[indexPath.row]{
         do{
            try self.realm.write {
               self.realm.delete(categoryForDeletion)
            }
         } catch {
            print("Error Deleting")
         }
      }
   }
}
