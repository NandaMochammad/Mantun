//
//  ViewController.swift
//  Mantun
//
//  Created by Nanda Mochammad on 21/04/19.
//  Copyright © 2019 nandamochammad. All rights reserved.
//

import UIKit
import RealmSwift

class MantunTableViewController: UITableViewController{
    
    @IBOutlet weak var gaweTitle: UINavigationItem!
    
    let realm = try! Realm()
    var mantunItem : Results<Item>?
    
    var selectedCategory : Category?{
        didSet{
            loadItem()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let title = selectedCategory?.name{
            gaweTitle.title = "\(title) Gawe"
            print(title)
        }
        
    }

    
    //MARK: - Tableview Datasource Methods
    //This Method used for defin the data source
    //1. Define numberOfRowsInSection to get value of rows needed
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mantunItem?.count ?? 0
    }
    
    //2. Define cellForRowAt to set the content on every cell
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //Declare the cell settings
        let cell = tableView.dequeueReusableCell(withIdentifier: "mantunCellTable", for: indexPath)
        
        if let item = mantunItem?[indexPath.row]{
            //Set the cell's text from datassource
            cell.textLabel?.text = item.title
            
            //Using Ternary Operation
            // value = condition ? valueTrue : valueFalse
            cell.accessoryType = item.done == true ? .checkmark : .none
        }else{
            cell.textLabel?.text = "No Items Added"
        }
        
        return cell
    }
    

    //MARK: - Tableview Delegate Methods
    //This Method used for give an action if the cell get tapped
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //Give an fade to white animation in selected row
        tableView.deselectRow(at: indexPath, animated: true)
        
        //Change value of selected row
        if let currentCategory = mantunItem?[indexPath.row]{
            do{
                try self.realm.write {
                    currentCategory.done = !currentCategory.done
                }
            }catch{
                print("Error checkmark in didSelectRow -> \(error)")
            }
        }
        
        tableView.reloadData()

    }

    
    //MARK: - Add New Item
    
    @IBAction func addDoList(_ sender: UIBarButtonItem) {
        
        var newitem : UITextField!
        
        let alert = UIAlertController(title: "Add New Do List", message: " ", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
            if let currentCategory = self.selectedCategory{
                do{
                    try self.realm.write {
                        let newItem = Item()
                        newItem.title = newitem.text!
                        currentCategory.items.append(newItem)
                    }
                }catch{
                    print("Error addData in MantunTVC -> \(error)")
                }
                
            }
            
            self.tableView.reloadData()
            
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

    
    //MARK: - Data Manipulation Methods
    func loadItem(){
        
        mantunItem = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)

        tableView.reloadData()
        
    }

//    func deleteData(_ index : Int){
//        context.delete(itemArray[index])
//        itemArray.remove(at: index)
//        savedItem()
//    }
    
    ////////////////////////////////
    
    
    

}//class

//MARK: - Search Method

//extension MantunTableViewController: UISearchBarDelegate{
//
//    //Declare the action when the searchBarSearchButtonClicked
//    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//
//        let request : NSFetchRequest<Item> = Item.fetchRequest() //declare the content of request
//
//        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!) //Query to communicate with CoreData
//
//        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)] //Give an action to sort ascending the table after sorting
//
//        loadItem(with: request, predicate: predicate) //load item
//
//    }//func
//
//    //Declare the action of the searchBar(textDidChange)
//    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//
//        if searchBar.text?.count == 0{
//
//            loadItem()
//
//            DispatchQueue.main.async { //to affect the user interface in foreground
//
//                searchBar.resignFirstResponder() //to release the current status to original status
//
//            }//dispatch
//
//        }//if
//
//    }//func
//
//}//extension
