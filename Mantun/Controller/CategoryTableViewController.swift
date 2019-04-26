 //
//  CategoryTableViewController.swift
//  Mantun
//
//  Created by Nanda Mochammad on 24/04/19.
//  Copyright © 2019 nandamochammad. All rights reserved.
//

import UIKit
 import CoreData

class CategoryTableViewController: UITableViewController {

    //Declare context and use method inside AppDelegate
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var categories = [Category]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
        loadItems()
    
    }
    
    
    //MARK: - TableView  DataSource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return categories.count
    
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
        cell.textLabel?.text = categories[indexPath.row].name
        
        return cell
    }
    
    
    
    //MARK: - TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
        performSegue(withIdentifier: "goToItem", sender: self)
        
//        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let destinationVC = segue.destination as! MantunTableViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            
            destinationVC.selectedCategory = categories[indexPath.row]
        
        }
    
    }
    
    
    //MARK: - Add New Categories
    
    @IBAction func addButtonTapped(_ sender: UIBarButtonItem) {
        var textField : UITextField!
        
        let alert = UIAlertController(title: "Add New Category", message: " ", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            
            
            //Set what will happen when user tap the button
            let newItem = Category(context: self.context)
            
            newItem.name = textField.text!
            
            //Add New DO list to array item object
            self.categories.append(newItem)
            
            self.savedItems()

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
    func savedItems(){
        
        do{
            
            try context.save()
        
        }catch{
        
            print("Error while save item ", error)
        
        }
        
        tableView.reloadData()
    
    }
    
    func loadItems(){
        
        let request : NSFetchRequest<Category> = Category.fetchRequest()
        
        do{
            
            categories = try context.fetch(request)
        
        }catch{
        
            print("Error Fetch Data from Context \(error)")
        
        }
        
        tableView.reloadData()
        
    }

    
}
