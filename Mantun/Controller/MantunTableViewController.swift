//
//  ViewController.swift
//  Mantun
//
//  Created by Nanda Mochammad on 21/04/19.
//  Copyright © 2019 nandamochammad. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class MantunTableViewController: SwipeTableViewController{
    
    @IBOutlet weak var addButton: UIBarButtonItem!
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var gaweTitle: UINavigationItem!
    
    lazy var realm:Realm = {
        return try! Realm()
    }()
    
    var mantunItem : Results<Item>?
    
    var selectedCategory : Category?{
        didSet{
            loadItem()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.separatorStyle = .none
                
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        guard let colorHex = selectedCategory?.color else { fatalError()}
        
        gaweTitle.title = "\(selectedCategory!.name) Gawe"
        
        updateNavBar(withHexCode: colorHex)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        updateNavBar(withHexCode: "1D9BF6")
        
    }
    
    //MARK: - Nav Bar Set Up
    func updateNavBar(withHexCode colorHexCode : String){
        
        guard let navBar = navigationController?.navigationBar else{ fatalError("Nav Controller does not exist") }
        
        guard let navBarColor = UIColor(hexString: colorHexCode) else { fatalError()}
        
        navBar.barTintColor = navBarColor
        
        navBar.tintColor = ContrastColorOf(navBarColor, returnFlat: true)
        
        navBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor : ContrastColorOf(navBarColor, returnFlat: true)]
        
        searchBar.barTintColor = navBarColor
        
        addButton.tintColor = ContrastColorOf(navBarColor, returnFlat: true)

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
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let item = mantunItem?[indexPath.row]{
            //Set the cell's text from datassource
            cell.textLabel?.text = item.title
            
            if let color = UIColor(hexString: selectedCategory!.color)?.darken(byPercentage: CGFloat(indexPath.row)/CGFloat(mantunItem!.count)){
                cell.backgroundColor = color
                cell.textLabel?.textColor = ContrastColorOf(color, returnFlat: true)
            }
            
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
                        newItem.dateCreated = Date.init()
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
        
        mantunItem = selectedCategory?.items.sorted(byKeyPath: "dateCreated", ascending: false)
        
        tableView.reloadData()
        
    }
    
    //Delete Data from Swipe
    override func updateModel(at indexPath: IndexPath) {
        super.updateModel(at: indexPath)
        
        if let item = self.mantunItem?[indexPath.row]{
            do{
                try self.realm.write {
                    self.realm.delete(item)
                }
            }catch{
                print("Error delete category ", error)
            }
        }
    }

}//class

//MARK: - Search Method

extension MantunTableViewController: UISearchBarDelegate{

    //Declare the action when the searchBarSearchButtonClicked
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {

        mantunItem = mantunItem?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: false)

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

