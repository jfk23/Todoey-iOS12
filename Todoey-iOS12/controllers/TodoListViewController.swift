//
//  ViewController.swift
//  Todoey-iOS12
//
//  Created by Byungsuk Choi on 12/29/19.
//  Copyright © 2019 Byungsuk Choi. All rights reserved.
//

import UIKit
import CoreData

class TodoListViewController: UITableViewController {
    
    //var defaults = UserDefaults.standard
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    //let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("items.plist")
    
    
    var arrayItem = [Item]()
    
    var selectedCategory : Category? {
        didSet{
            loaditems()
        }
    }
    
//    var arrayItem = ["Flowers smile", "Sunshine bright", "Grace as rain"]
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //print(dataFilePath!)
        
//        if let items = defaults.array(forKey: "TodoItems") as? [Item] {
//            arrayItem = items
//        }
        // Do any additional setup after loading the view.
        
//        let newItem = Item()
//        newItem.title = "Flowers smile"
//        arrayItem.append(newItem)
//
//        let newItem2 = Item()
//        newItem2.title = "Sunshine bright"
//        arrayItem.append(newItem2)
//
//        let newItem3 = Item()
//        newItem3.title = "Grace as rain"
//        arrayItem.append(newItem3)
        
        
     

        
    }
    
    //MARK: - UITableview datasource methods
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItems", for: indexPath)
        cell.textLabel?.text = arrayItem[indexPath.row].title
        if arrayItem[indexPath.row].done == false {
            cell.accessoryType = .none
        } else {
            cell.accessoryType = .checkmark
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayItem.count
    }
    
    //MARK: - UITableview delegate methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
//        arrayItem[indexPath.row].setValue("Completed", forKey: "title")
        arrayItem[indexPath.row].done = !arrayItem[indexPath.row].done
        //context.delete(arrayItem[indexPath.row])
        //arrayItem.remove(at: indexPath.row)
        
        saveitem()
        
//        tableView.cellForRow(at: indexPath)?.accessoryType = tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark ? .none : .checkmark
        
        tableView.reloadData()
        
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    //MARK: - Add new item
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Add new items", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add item", style: .default) { (alertaction) in
            // what happens after Add button pressed
            
            let item = Item(context: self.context)
            item.title = alert.textFields![0].text!
            item.done = false
            item.parentCategory = self.selectedCategory
            
            self.arrayItem.append(item)
            //self.defaults.set(self.arrayItem, forKey: "TodoItems")
            
            self.saveitem()
            
        }
        alert.addTextField { (alertField) in
            alertField.placeholder = "Enter new item"
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    func saveitem() {

        do {
            try context.save()

        } catch {
            print ("error with saving data: \(error)")
        }
        
        self.tableView.reloadData()
        
    }
    
    func loaditems(with request:NSFetchRequest<Item> = Item.fetchRequest(), predicate:NSPredicate?=nil) {
        //let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Item")
        //let request : NSFetchRequest<Item> = Item.fetchRequest()
        
        let CategoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
        
        if let additional = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [CategoryPredicate, additional])
            
        } else {
            request.predicate = CategoryPredicate
        }

        do {
            arrayItem = try context.fetch(request)
        } catch {
            print("error fetching data in context: \(error)")
        }
        tableView.reloadData()
        
    }
}

extension TodoListViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        loaditems(with: request, predicate: predicate)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text!.count == 0 {
            loaditems()
        
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
}
