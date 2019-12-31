//
//  ViewController.swift
//  Todoey-iOS12
//
//  Created by Byungsuk Choi on 12/29/19.
//  Copyright © 2019 Byungsuk Choi. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {
    
    var arrayItem = ["Flowers smile", "Sunshine bright", "Grace as rain"]

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    //MARK: - UITableview datasource methods
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItems", for: indexPath)
        cell.textLabel?.text = arrayItem[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayItem.count
    }
    
    //MARK: - UITableview delegate methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.cellForRow(at: indexPath)?.accessoryType = tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark ? .none : .checkmark
        
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    //MARK: - Add new item
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Add new items", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add item", style: .default) { (alertaction) in
            // what happens after Add button pressed
            self.arrayItem.append(alert.textFields![0].text!)
            self.tableView.reloadData()
        }
        alert.addTextField { (alertField) in
            alertField.placeholder = "Enter new item"
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    

}

