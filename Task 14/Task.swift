import Foundation
import RealmSwift

class Task: Object {
   @Persisted var text: String = ""
}
