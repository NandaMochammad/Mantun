//
//  Category.swift
//  Mantun
//
//  Created by Nanda Mochammad on 27/04/19.
//  Copyright © 2019 nandamochammad. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object{
    @objc dynamic var name: String = ""
    var items = List<Item>()
}
