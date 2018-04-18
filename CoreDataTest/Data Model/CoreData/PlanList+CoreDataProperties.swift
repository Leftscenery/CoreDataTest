//
//  PlanList+CoreDataProperties.swift
//  CoreDataTest
//
//  Created by Jiawei Zhou on 4/17/18.
//  Copyright © 2018 Jiawei Zhou. All rights reserved.
//
//

import Foundation
import CoreData


extension PlanList {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PlanList> {
        return NSFetchRequest<PlanList>(entityName: "PlanList")
    }

    @NSManaged public var name: String?
    @NSManaged public var date: NSDate?
    @NSManaged public var isCurrent: Bool
    @NSManaged public var isPayOff: Bool
    @NSManaged public var amount: Float
    @NSManaged public var paid: Float
    @NSManaged public var rest: Float
    @NSManaged public var members: NSSet?
    @NSManaged public var pays: NSSet?

}

// MARK: Generated accessors for members
extension PlanList {

    @objc(addMembersObject:)
    @NSManaged public func addToMembers(_ value: Member)

    @objc(removeMembersObject:)
    @NSManaged public func removeFromMembers(_ value: Member)

    @objc(addMembers:)
    @NSManaged public func addToMembers(_ values: NSSet)

    @objc(removeMembers:)
    @NSManaged public func removeFromMembers(_ values: NSSet)

}

// MARK: Generated accessors for pays
extension PlanList {

    @objc(addPaysObject:)
    @NSManaged public func addToPays(_ value: Pay)

    @objc(removePaysObject:)
    @NSManaged public func removeFromPays(_ value: Pay)

    @objc(addPays:)
    @NSManaged public func addToPays(_ values: NSSet)

    @objc(removePays:)
    @NSManaged public func removeFromPays(_ values: NSSet)

}
