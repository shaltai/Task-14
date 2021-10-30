import Foundation
import CoreData


extension TaskCoreData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TaskCoreData> {
        return NSFetchRequest<TaskCoreData>(entityName: "TaskCoreData")
    }

    @NSManaged public var text: String?
    @NSManaged public var isCompleted: Bool

}

extension TaskCoreData : Identifiable {

}
