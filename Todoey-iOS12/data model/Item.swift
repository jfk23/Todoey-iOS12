//
//  Item.swift
//  Todoey-iOS12
//
//  Created by Byungsuk Choi on 1/13/20.
//  Copyright © 2020 Byungsuk Choi. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var title = ""
    @objc dynamic var done = false
    @objc dynamic var dateCreated = Date()
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
