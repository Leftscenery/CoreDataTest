//
//  Plan+CoreDataProperties.swift
//  CoreDataTest
//
//  Created by Jiawei Zhou on 3/24/18.
//  Copyright © 2018 Jiawei Zhou. All rights reserved.
//
//

import Foundation
import CoreData


extension Plan {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Plan> {
        return NSFetchRequest<Plan>(entityName: "Plan")
    }

    @NSManaged public var name: String?
    @NSManaged public var date: NSDate?
    @NSManaged public var isCurrent: Bool
    @NSManaged public var amount: Float
    @NSManaged public var paid: Float
    @NSManaged public var rest: Float
    @NSManaged public var isPayoff: Bool
    @NSManaged public var singlePays: NSSet?
    @NSManaged public var memberSummaries: NSSet?

}

// MARK: Generated accessors for singlePays
extension Plan {

    @objc(addSinglePaysObject:)
    @NSManaged public func addToSinglePays(_ value: SinglePayment)

    @objc(removeSinglePaysObject:)
    @NSManaged public func removeFromSinglePays(_ value: SinglePayment)

    @objc(addSinglePays:)
    @NSManaged public func addToSinglePays(_ values: NSSet)

    @objc(removeSinglePays:)
    @NSManaged public func removeFromSinglePays(_ values: NSSet)

}

// MARK: Generated accessors for memberSummaries
extension Plan {

    @objc(addMemberSummariesObject:)
    @NSManaged public func addToMemberSummaries(_ value: MemberSummary)

    @objc(removeMemberSummariesObject:)
    @NSManaged public func removeFromMemberSummaries(_ value: MemberSummary)

    @objc(addMemberSummaries:)
    @NSManaged public func addToMemberSummaries(_ values: NSSet)

    @objc(removeMemberSummaries:)
    @NSManaged public func removeFromMemberSummaries(_ values: NSSet)

}
