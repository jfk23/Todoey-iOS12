//
//  ViewController.swift
//  Todoey-iOS12
//
//  Created by Byungsuk Choi on 12/29/19.
//  Copyright © 2019 Byungsuk Choi. All rights reserved.
//

import UIKit
import RealmSwift

class TodoListViewController: UITableViewController {
    
    let realm = try! Realm()
    
    //var defaults = UserDefaults.standard
    //let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    //let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("items.plist")
    
    
    var todoItems: Results<Item>?
    
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
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItems", for: indexPath)
        
        if let item = todoItems?[indexPath.row] {
            
            cell.textLabel?.text = item.title
            
            if item.done == false {
                cell.accessoryType = .none
            } else {
                cell.accessoryType = .checkmark
            }
        } else {
            
            cell.textLabel?.text = "No items added yet"
        }
            
        
        return cell
    }
    

    
    //MARK: - UITableview delegate methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let item = todoItems?[indexPath.row] {
            
            do {
                try realm.write {
                    item.done = !item.done
                }
            } catch {
                print("error updating data: \(error)")
            }
        }
        
//        arrayItem[indexPath.row].setValue("Completed", forKey: "title")
//        todoItems[indexPath.row].done = !todoItems[indexPath.row].done
        //context.delete(arrayItem[indexPath.row])
        //arrayItem.remove(at: indexPath.row)
        
//        saveitem()
        
//        tableView.cellForRow(at: indexPath)?.accessoryType = tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark ? .none : .checkmark
        
        tableView.reloadData()
        
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    //MARK: - Add new item
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Add new items", message: "", preferredStyle: .alert)

        let action = UIAlertAction(title: "Add item", style: .default) { (alertaction) in
            // what happens after Add button pressed

            
            do {
                try self.realm.write {
                    let item = Item()
                    item.title = alert.textFields![0].text!
                    item.dateCreated = Date()
                    self.selectedCategory?.items.append(item)
                }
            } catch {
                print("error saving new item: \(error)")
            }
            
            self.tableView.reloadData()

        }
        
        alert.addTextField { (alertField) in
            alertField.placeholder = "Enter new item"
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
        
    }
    
    func saveitem() {

//        do {
//            try context.save()
//
//        } catch {
//            print ("error with saving data: \(error)")
//        }
//        
//        self.tableView.reloadData()
//
    }
    
    func loaditems() {
        //let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Item")
        //let request : NSFetchRequest<Item> = Item.fetchRequest()
        
        todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        
        //todoItems = realm.object(ofType: Item.self, forPrimaryKey: selectedCategory?.name)


//        let CategoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
//
//        if let additional = predicate {
//            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [CategoryPredicate, additional])
//
//        } else {
//            request.predicate = CategoryPredicate
//        }
//
//        do {
//            arrayItem = try context.fetch(request)
//        } catch {
//            print("error fetching data in context: \(error)")
//        }
        tableView.reloadData()

    }
}

extension TodoListViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
        tableView.reloadData()
        
//        let request : NSFetchRequest<Item> = Item.fetchRequest()
//        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
//        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
//        loaditems(with: request, predicate: predicate)
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
