//
//  Item.swift
//  Todoey
//
//  Created by JC Manikis on 2021-07-15.
//  Copyright © 2021 App Brewery. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var title : String = ""
    @objc dynamic var done : Bool = false
    @objc dynamic var dateCreated : Date? 
    
    // inverse link to category using property "items" from category class
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
