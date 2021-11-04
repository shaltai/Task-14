import Foundation
import CoreData
import RealmSwift

class Persistance {
   static let shared = Persistance()
   
   // Realm
   let realm = try! Realm()
   
   func save(task text: String) {
      let task = Task()
      task.text = text
      try! self.realm.write {
         self.realm.add(task)
      }
   }
   
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
   
   // Get tasks
   func getTasks() -> [TaskCoreData] {
      var tasks: [TaskCoreData] = []
      
      do {
         tasks = try persistentContainer.viewContext.fetch(TaskCoreData.fetchRequest())
      } catch let error as NSError {
         print("Error: \(error), \(error.userInfo)")
      }
      return tasks
   }
   
   // Save context
   func save(context: NSManagedObjectContext) {
      guard context.hasChanges else { return }
      do {
         try context.save()
      } catch let error as NSError {
         print("Error: \(error), \(error.userInfo)")
      }
   }
}
