//
//  ViewController.swift
//  Todoey-iOS12
//
//  Created by Byungsuk Choi on 12/29/19.
//  Copyright © 2019 Byungsuk Choi. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {
    
    var defaults = UserDefaults.standard
    
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("items.plist")
    
    
    var arrayItem = [Item]()
    
//    var arrayItem = ["Flowers smile", "Sunshine bright", "Grace as rain"]
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(dataFilePath!)
        
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
        
        loaditems()
     

        
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
        
        arrayItem[indexPath.row].done = !arrayItem[indexPath.row].done
        
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
            
            let item = Item()
            item.title = alert.textFields![0].text!
            
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
        
        let encoder = PropertyListEncoder()
        do {
            let data = try encoder.encode(self.arrayItem)
            try data.write(to: self.dataFilePath!)
        } catch {
            print ("error with encoding data: \(error)")
        }
        
        self.tableView.reloadData()
        
    }
    
    func loaditems() {
        if let data = try? Data(contentsOf: dataFilePath!) {
            let decoder = PropertyListDecoder()
            do {
                arrayItem = try decoder.decode([Item].self, from: data)
            } catch {
                print("error when decoding data: \(error)")
            }
        }
    }
    

}

