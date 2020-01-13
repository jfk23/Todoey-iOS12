//
//  CategoryViewController.swift
//  Todoey-iOS12
//
//  Created by Byungsuk Choi on 1/9/20.
//  Copyright © 2020 Byungsuk Choi. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var CatArray = [Category]()

    override func viewDidLoad() {
        super.viewDidLoad()

        loadCategory()
 
    }

    // MARK: - Table view data source


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return CatArray.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoCategory", for: indexPath)

        cell.textLabel?.text = CatArray[indexPath.row].name

        return cell
    }
    
    //MARK: - tableview delegate methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let DestinationVC = segue.destination as! TodoListViewController
        if let indexpath = tableView.indexPathForSelectedRow {
            DestinationVC.selectedCategory = CatArray[indexpath.row]
        }
    }
   

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "New Category", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add a category", style: .default) { (alertAction) in
            
            let newCat = Category(context: self.context)
            newCat.name = alert.textFields![0].text
            self.CatArray.append(newCat)
            
            self.saveCategory()
            
        }
        alert.addAction(action)
        
        alert.addTextField { (textfield) in
            textfield.placeholder = "Please add a category"
        }
        
        present(alert, animated: true, completion: nil)
        
    }
    
    func saveCategory() {
        
        do {
            try context.save()
        } catch {
            print ("error with saving a category: \(error)")
        }
        
        tableView.reloadData()
    }
    
    func loadCategory() {
        let request : NSFetchRequest<Category> = Category.fetchRequest()
        do {
            CatArray = try context.fetch(request)
        } catch {
            print ("error with fetching category: \(error)")
        }
    }
    
}
