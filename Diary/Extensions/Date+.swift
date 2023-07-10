//
//  Date+.swift
//  Diary
//
//  Created by Alexandr Onischenko on 10.07.2023.
//

import Foundation

extension Date {
    func currentTimeMillis() -> Int64 {
        return Int64(self.timeIntervalSince1970)
    }
}
