//
//  Category.swift
//  Todoey-iOS12
//
//  Created by Byungsuk Choi on 1/13/20.
//  Copyright © 2020 Byungsuk Choi. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name = ""
    var items = List<Item>()
}
