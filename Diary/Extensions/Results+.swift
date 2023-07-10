import Foundation
import RealmSwift

extension Results {
    var array: [Element] { return self.map { $0 } }
}
