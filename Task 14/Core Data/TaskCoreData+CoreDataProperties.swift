//
//  TaskCoreData+CoreDataProperties.swift
//  Task 14
//
//  Created by Stanislav Pimenov on 16.10.2021.
//
//

import Foundation
import CoreData


extension TaskCoreData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TaskCoreData> {
        return NSFetchRequest<TaskCoreData>(entityName: "TaskCoreData")
    }

    @NSManaged public var text: String?

}

extension TaskCoreData : Identifiable {

}
