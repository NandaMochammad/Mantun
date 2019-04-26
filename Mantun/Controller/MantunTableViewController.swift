//
//  ViewController.swift
//  Mantun
//
//  Created by Nanda Mochammad on 21/04/19.
//  Copyright © 2019 nandamochammad. All rights reserved.
//

import UIKit
import CoreData

class MantunTableViewController: UITableViewController{
    
    @IBOutlet weak var gaweTitle: UINavigationItem!
    
    //Declare a context from Singleton UI Application
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    //Declare Model as Global Variable as! Array of item Object
    var itemArray = [Item]()
    
    var selectedCategory : Category?{
        
        //Method below will executed after selectedCategory got an item
        didSet{
        
            //Load Data
            loadItem()
        
        }
    
    }
    
    override func viewDidLoad() {
    
        super.viewDidLoad()
        
//        Get Path of directory apps storage
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))

        if let title = selectedCategory?.name{
            gaweTitle.title = "\(title) Gawe"
            print(title)
        }
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
        cell.textLabel?.text = item.title
        
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
        
        savedItem()

    }
    
    ////////////////////////////////////////////
    
    //MARK - Add New Item
    
    @IBAction func addDoList(_ sender: UIBarButtonItem) {
        
        var newitem : UITextField!
        
        let alert = UIAlertController(title: "Add New Do List", message: " ", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
            
            //Set what will happen when user tap the button
            let newItem = Item(context: self.context)
            
            newItem.title = newitem.text!
            
            newItem.done = false
            
            newItem.parentCategory = self.selectedCategory
            
            //Add New DO list to array item object
            self.itemArray.append(newItem)
            
            self.savedItem()
            
        }//action
        
        alert.addTextField { (textField) in
            
            textField.placeholder = "Add New Item"
            
            newitem = textField

        }//alert
        
        alert.addAction(action)
        
        present(alert, animated: true, completion:{
            
            alert.view.superview?.isUserInteractionEnabled = true
            
            alert.view.superview?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.alertControllerBackgroundTapped)))
            
        })//present
        
    } //func
    
    @objc func alertControllerBackgroundTapped()
    {
        self.dismiss(animated: true, completion: nil)
    }
    
    ///////////////////////////////////////
    //Mark - Model Manipulation Methods
    //Save item using NSCoder - Encode data
    //Save item using CoreData
    func savedItem(){
//        let encoder = PropertyListEncoder()
        
        do{
            try context.save()
//            let data = try encoder.encode(itemArray)
//            try data.write(to: dataFilePath!)
        }catch{
            print("Error saving context \(error)")
//            print("Error while encoding, \(error)")
        }
        
        self.tableView.reloadData()
    }
    
//    Get item using NSCoder - Decode  data
    func loadItem(with request : NSFetchRequest<Item> = Item.fetchRequest(), predicate : NSPredicate? = nil ){
        
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
        
        if let additionalPredicate = predicate{
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionalPredicate])
        }else{
            request.predicate = categoryPredicate
        }

        do{
            itemArray = try context.fetch(request)
        }catch{
            print("Error Fetch Data from Context \(context)")
        }
        
        tableView.reloadData()

//        if let data = try? Data(contentsOf: dataFilePath!){
//            let decoder = PropertyListDecoder()
//            do{
//                itemArray = try decoder.decode([TitleModel].self, from: data)
//            }catch{
//                print("Error while Decode, \(error)")
//            }
//        }
    }
    
    func deleteData(_ index : Int){
        context.delete(itemArray[index])
        itemArray.remove(at: index)
        savedItem()
    }
    
    ////////////////////////////////
    
    
    

}//class

//MARK: - Search Method

extension MantunTableViewController: UISearchBarDelegate{
    
    //Declare the action when the searchBarSearchButtonClicked
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        let request : NSFetchRequest<Item> = Item.fetchRequest() //declare the content of request
        
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!) //Query to communicate with CoreData
            
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)] //Give an action to sort ascending the table after sorting
            
        loadItem(with: request, predicate: predicate) //load item
        
    }//func
    
    //Declare the action of the searchBar(textDidChange)
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchBar.text?.count == 0{
        
            loadItem()
            
            DispatchQueue.main.async { //to affect the user interface in foreground
            
                searchBar.resignFirstResponder() //to release the current status to original status
                
            }//dispatch
            
        }//if
        
    }//func
    
}//extension
