//
//  Category.swift
//  Todoey
//
//  Created by JC Manikis on 2021-07-15.
//  Copyright © 2021 App Brewery. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name : String = ""
    @objc dynamic var colorHex : String = ""
    
    // forward realationship link
    let items = List<Item>()
}
