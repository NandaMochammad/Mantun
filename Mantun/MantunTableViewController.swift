//
//  ViewController.swift
//  Mantun
//
//  Created by Nanda Mochammad on 21/04/19.
//  Copyright © 2019 nandamochammad. All rights reserved.
//

import UIKit

class MantunTableViewController: UITableViewController{
    
    var itemArray = ["Get Breakfast", "Go to Bus Station", "Go to Academy", "FInish Udemy Module"]
    var inits = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        
    }

    
    //MARK - Tableview Datasource Methods : This Method used for defin the data source
    //1. Define numberOfRowsInSection to get value of rows needed
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    //2. Define cellForRowAt to set the content on every cell
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //Declare the cell settings
        let cell = tableView.dequeueReusableCell(withIdentifier: "mantunCellTable", for: indexPath)
        
        //Set the cell's text from datassource
        cell.textLabel?.text = itemArray[indexPath.row]
        
        return cell
    }
    
    //////////////////////////////////////////
    
    //MARK - Tableview Delegate Methods : This Method used for give an action if the cell get tapped
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //Give an fade to white animation in selected row
        tableView.deselectRow(at: indexPath, animated: true)
        
        //Give Checkmark in selected row
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark{
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        }else{
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
    }
    
    ////////////////////////////////////////////
    
    //MARK - Add New Item
    
    @IBAction func addDoList(_ sender: UIBarButtonItem) {
        var newitem : UITextField!
        
        let alert = UIAlertController(title: "Add New Do List", message: " ", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            //Set what will happen when user tap the button
            print("yeay")
            self.itemArray.append(newitem.text ?? "")
            self.tableView.reloadData()
        }
        
        alert.addTextField { (textField) in
            textField.placeholder = "Add New Item"
            newitem = textField

        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    
    
    

}

