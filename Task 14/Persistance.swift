import Foundation

class Persistance {
   static let shared = Persistance()
   
   // UserDefaults
   private let keyUserName = "Persistance.keyUserName"
   var userName: String? {
      set {
         UserDefaults.standard.set(newValue, forKey: keyUserName)
      }
      get {
         return UserDefaults.standard.string(forKey: keyUserName)
      }
   }
   
   private let keyUserSurname = "Persistance.keyUserSurname"
   var userSurname: String? {
      set {
         UserDefaults.standard.set(newValue, forKey: keyUserSurname)
      }
      get {
         return UserDefaults.standard.string(forKey: keyUserSurname)
      }
   }
   
}
