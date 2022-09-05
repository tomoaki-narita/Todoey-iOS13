//
//  Item.swift
//  Todoey
//
//  Created by output. on 2022/09/03.
//  Copyright © 2022 App Brewery. All rights reserved.
//

import Foundation

class Item: Codable { //デコードとエンコードを準拠するためにスーパークラスをCodableに
    var title: String = ""
    var done: Bool = false
}
