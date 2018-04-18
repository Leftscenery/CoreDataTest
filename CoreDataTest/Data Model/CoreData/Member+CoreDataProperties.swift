//
//  Member+CoreDataProperties.swift
//  CoreDataTest
//
//  Created by Jiawei Zhou on 4/17/18.
//  Copyright © 2018 Jiawei Zhou. All rights reserved.
//
//

import Foundation
import CoreData


extension Member {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Member> {
        return NSFetchRequest<Member>(entityName: "Member")
    }

    @NSManaged public var name: String?
    @NSManaged public var amount: Float
    @NSManaged public var paid: Float
    @NSManaged public var rest: Float
    @NSManaged public var plan: PlanList?
    @NSManaged public var pays: NSSet?

}

// MARK: Generated accessors for pays
extension Member {

    @objc(addPaysObject:)
    @NSManaged public func addToPays(_ value: Pay)

    @objc(removePaysObject:)
    @NSManaged public func removeFromPays(_ value: Pay)

    @objc(addPays:)
    @NSManaged public func addToPays(_ values: NSSet)

    @objc(removePays:)
    @NSManaged public func removeFromPays(_ values: NSSet)

}
