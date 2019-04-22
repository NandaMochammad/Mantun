//
//  titleModel.swift
//  Mantun
//
//  Created by Nanda Mochammad on 22/04/19.
//  Copyright © 2019 nandamochammad. All rights reserved.
//

import Foundation

//Mark the class using Encodable, Decodable or just write Codable
//Which mean the class can be encode to other form, and the variable inside it should declare the data type
class TitleModel: Codable {
    var titleString : String = ""
    var done : Bool = false
}
