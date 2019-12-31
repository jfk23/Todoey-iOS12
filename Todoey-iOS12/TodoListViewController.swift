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


}

