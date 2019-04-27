//
//  AppDelegate.swift
//  Mantun
//
//  Created by Nanda Mochammad on 21/04/19.
//  Copyright © 2019 nandamochammad. All rights reserved.
//

import UIKit
import CoreData
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        //Get Realm file location path on storage
        print(Realm.Configuration.defaultConfiguration.fileURL ?? "Home")
        
        //Define object dataModel
        let data = Data()
        data.name = "Nanda"
        data.age = 20
        
        //Build Realm Object and save method
        do{
            let realm = try Realm()
            try realm.write {
                realm.add(data)
            }
        }catch{
            print("Error at AppDelegate ~ Realm", error)
        }
        
        
        return true
    }

    func applicationWillTerminate(_ application: UIApplication) {
        
        self.saveContext()
    }

    // MARK: - Core Data stack
    
    lazy var persistentContainer: NSPersistentContainer = {
        
        let container = NSPersistentContainer(name: "DataModel")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }


}

