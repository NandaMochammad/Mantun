//
//  Category.swift
//  Mantun
//
//  Created by Nanda Mochammad on 27/04/19.
//  Copyright © 2019 nandamochammad. All rights reserved.
//

import Foundation
import RealmSwift
import ChameleonFramework

class Category: Object{
    @objc dynamic var name: String = ""
    @objc dynamic var color : String = ""
    var items = List<Item>()
}
