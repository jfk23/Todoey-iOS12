//
//  CategoryViewController.swift
//  Todoey-iOS12
//
//  Created by Byungsuk Choi on 1/9/20.
//  Copyright © 2020 Byungsuk Choi. All rights reserved.
//

import UIKit
import RealmSwift
import SwipeCellKit

class CategoryViewController: UITableViewController {
    
    let realm = try! Realm()
    
    //let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var CatArray: Results<Category>?

    override func viewDidLoad() {
        super.viewDidLoad()

        loadCategory()
        tableView.rowHeight = 76.0
 
    }

    // MARK: - Table view data source


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return CatArray?.count ?? 1
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoCategory", for: indexPath) as! SwipeTableViewCell

        cell.textLabel?.text = CatArray?[indexPath.row].name ?? "No Category added yet"
        //print (cell.textLabel?.text)
        
        cell.delegate = self

        return cell
        
    }
    
    //MARK: - tableview delegate methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let DestinationVC = segue.destination as! TodoListViewController
        if let indexpath = tableView.indexPathForSelectedRow {
            DestinationVC.selectedCategory = CatArray?[indexpath.row]
        }
    }
   

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "New Category", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add a category", style: .default) { (alertAction) in
            
            let newCat = Category()
            newCat.name = alert.textFields![0].text!
            
            self.save(category: newCat)
            
        }
        alert.addAction(action)
        
        alert.addTextField { (textfield) in
            textfield.placeholder = "Please add a category"
        }
        
        present(alert, animated: true, completion: nil)
        
    }
    
    func save(category: Category) {
        
        do {
            try realm.write {
                realm.add(category)
            }
        } catch {
            print ("error with saving a category: \(error)")
        }
        
        tableView.reloadData()
    }
    
    func loadCategory() {
        
        CatArray = realm.objects(Category.self)
        tableView.reloadData()
//        let request : NSFetchRequest<Category> = Category.fetchRequest()
//        do {
//            CatArray = try context.fetch(request)
//        } catch {
//            print ("error with fetching category: \(error)")
//        }
    }
    
}

extension CategoryViewController: SwipeTableViewCellDelegate {
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }

        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            // handle action by updating model with deletion
            //print("item deleted")
            do {
                try self.realm.write {
                    self.realm.delete(self.CatArray![indexPath.row])
                }
                
            } catch {
                print("error when deleting a category: \(error)")
            }
            
            
            //tableView.reloadData()
                
         
        }

        // customize the action appearance
        deleteAction.image = UIImage(named: "delete-icon")

        return [deleteAction]
    }
    
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        var options = SwipeOptions()
        options.expansionStyle = .destructive
        options.transitionStyle = .border
        return options
    }
}
