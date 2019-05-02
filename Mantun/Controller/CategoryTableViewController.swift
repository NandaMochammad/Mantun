 //
//  CategoryTableViewController.swift
//  Mantun
//
//  Created by Nanda Mochammad on 24/04/19.
//  Copyright © 2019 nandamochammad. All rights reserved.
//

import UIKit
import RealmSwift

class CategoryTableViewController: UITableViewController {
    
    lazy var realm:Realm = {
        return try! Realm()
    }()
    
    var category: Results<Category>?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCategory()
        
    }
    
    
    //MARK: - TableView  DataSource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
         return category?.count ?? 1 //Nil Coalescing Operator
    
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
        cell.textLabel?.text = category?[indexPath.row].name ?? "No Category Added"
        
        return cell
    }
    
    
    
    //MARK: - TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
        performSegue(withIdentifier: "goToItem", sender: self)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let destinationVC = segue.destination as! MantunTableViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            
            destinationVC.selectedCategory = category?[indexPath.row]
        
        }
    
    }
    
    
    //MARK: - Add New Categories
    
    @IBAction func addButtonTapped(_ sender: UIBarButtonItem) {
        var textField : UITextField!
        
        let alert = UIAlertController(title: "Add New Category", message: " ", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            
            
            //Set what will happen when user tap the button
            let newItem = Category()
            
            newItem.name = textField.text!
            
            print("Add new item ",newItem.name)
            
            self.savedCategory(categories: newItem)
        }
        
        alert.addTextField { (field) in
            
            field.placeholder = "Category Name . . ."
            
            textField = field
            
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion:{
            alert.view.superview?.isUserInteractionEnabled = true
            alert.view.superview?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.alertControllerBackgroundTapped)))
        })
    }
    
    @objc func alertControllerBackgroundTapped()
    {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
    //MARK: - Data Manipulation Method
    func savedCategory(categories: Category){
        do{
            try realm.write {
                realm.add(categories)
            }
        }catch{
            print("Error savedItems in Category Controller \(error)")
        }
        
        tableView.reloadData()
    }
    
    func loadCategory(){
        
        category = realm.objects(Category.self)
        
        tableView.reloadData()

    }

    
}
