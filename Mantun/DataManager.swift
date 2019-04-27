//
//  DataManager.swift
//  Mantun
//
//  Created by Nanda Mochammad on 27/04/19.
//  Copyright © 2019 nandamochammad. All rights reserved.
//

import Foundation
import RealmSwift

class DataManager: Object {
    
    static let shared = DataManager()

    var categories = Category()
    
//    convenience required init(){
//        self.init()
//    }
    
    func saveDataToRealm(){
        do{
            let realm = try Realm()
            try realm.write {
                realm.add(categories.self)
            }
        }catch{
            print("Error at DataManager Save ~ Realm", error)
        }
    }
    
    func loadDataFromRealm(){
        
        do{
//            let realm = try Realm()
        }catch{
            print("Error at DataManager Load ~ Realm", error)
        }
        
    }
    
    
}//class DataManager
