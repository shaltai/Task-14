import Foundation
import CoreData

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
   
   // Core Data
   lazy var persistentContainer: NSPersistentContainer = {
      let container = NSPersistentContainer(name: "Task_14")
      container.loadPersistentStores(completionHandler: { (storeDescription, error) in
         if let error = error as NSError? {
            fatalError("Unresolved error \(error), \(error.userInfo)")
         }
      })
      return container
   }()
}
