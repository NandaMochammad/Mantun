//
//  ViewController.swift
//  Mantun
//
//  Created by Nanda Mochammad on 21/04/19.
//  Copyright © 2019 nandamochammad. All rights reserved.
//

import UIKit

class MantunTableViewController: UITableViewController{
    
    //Declare Data Saved Location on Stroage
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("TitleModel.plist")
    
    //Declare Model as Global Variable as! Array of item Object
    var itemArray = [TitleModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        print(dataFilePath)
        
        //Input Data to Model
        //1. Declare as a String
        let titleModel = TitleModel()
        //2. Set variable inside model with string
        titleModel.titleString = "Get Breakfast"
        //3. add the content of number 2 to array
        itemArray.append(titleModel)
        
        let titleModel1 = TitleModel()
        titleModel1.titleString = "Go to Bus Station "
        itemArray.append(titleModel1)
        
        let titleModel2 = TitleModel()
        titleModel2.titleString = "Go to Academy"
        itemArray.append(titleModel2)
        
        //Load Data
        loadItem()
    }

    
    //MARK - Tableview Datasource Methods : This Method used for defin the data source
    //1. Define numberOfRowsInSection to get value of rows needed
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    //2. Define cellForRowAt to set the content on every cell
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let item = itemArray[indexPath.row]
        
        //Declare the cell settings
        let cell = tableView.dequeueReusableCell(withIdentifier: "mantunCellTable", for: indexPath)
        
        //Set the cell's text from datassource
        cell.textLabel?.text = item.titleString
        
        //Using Ternary Operation
        // value = condition ? valueTrue : valueFalse
        cell.accessoryType = item.done == true ? .checkmark : .none
        
        return cell
    }
    
    //////////////////////////////////////////
    
    //MARK - Tableview Delegate Methods : This Method used for give an action if the cell get tapped
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //Give an fade to white animation in selected row
        tableView.deselectRow(at: indexPath, animated: true)
        
        //Change value of selected row
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        saveditem()

    }
    
    ////////////////////////////////////////////
    
    //MARK - Add New Item
    
    @IBAction func addDoList(_ sender: UIBarButtonItem) {
        
        var newitem : UITextField!
        
        let alert = UIAlertController(title: "Add New Do List", message: " ", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
            //Set what will happen when user tap the button
            let titleModel = TitleModel()
            titleModel.titleString = newitem.text!
            
            //Add New DO list to array item object
            self.itemArray.append(titleModel)
            
            self.saveditem()
        }
        
        alert.addTextField { (textField) in
            textField.placeholder = "Add New Item"
            newitem = textField

        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    
    ///////////////////////////////////////
    //Mark - Model Manipulation Methods
    //Save item using NSCoder - Encode data
    func saveditem(){
        let encoder = PropertyListEncoder()
        
        do{
            let data = try encoder.encode(itemArray)
            try data.write(to: dataFilePath!)
        }catch{
            print("Error while encoding, \(error)")
        }
        
        self.tableView.reloadData()
    }
    
    //Get item using NSCoder - Decode  data
    func loadItem(){
        if let data = try? Data(contentsOf: dataFilePath!){
            let decoder = PropertyListDecoder()
            do{
                itemArray = try decoder.decode([TitleModel].self, from: data)
            }catch{
                print("Error while Decode, \(error)")
            }
        }
    }
    
    

}
