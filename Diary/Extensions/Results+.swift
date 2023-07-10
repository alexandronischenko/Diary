//
//  Results+.swift
//  Diary
//
//  Created by Alexandr Onischenko on 10.07.2023.
//

import Foundation
import RealmSwift

extension Results {
    var array: [Element] { return self.map { $0 } }
}
