//
//  Item.swift
//  Mantun
//
//  Created by Nanda Mochammad on 27/04/19.
//  Copyright © 2019 nandamochammad. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object{
    @objc dynamic var title: String = ""
    @objc dynamic var done: Bool = false
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
