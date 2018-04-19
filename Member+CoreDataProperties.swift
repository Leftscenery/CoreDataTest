//
//  Member+CoreDataProperties.swift
//  CoreDataTest
//
//  Created by Jiawei Zhou on 4/18/18.
//  Copyright © 2018 Jiawei Zhou. All rights reserved.
//
//

import Foundation
import CoreData


extension Member {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Member> {
        return NSFetchRequest<Member>(entityName: "Member")
    }

    @NSManaged public var amount: Float
    @NSManaged public var name: String?
    @NSManaged public var paid: Float
    @NSManaged public var rest: Float
    @NSManaged public var memberpays: NSSet?
    @NSManaged public var plan: PlanList?

}

// MARK: Generated accessors for memberpays
extension Member {

    @objc(addMemberpaysObject:)
    @NSManaged public func addToMemberpays(_ value: MemberPay)

    @objc(removeMemberpaysObject:)
    @NSManaged public func removeFromMemberpays(_ value: MemberPay)

    @objc(addMemberpays:)
    @NSManaged public func addToMemberpays(_ values: NSSet)

    @objc(removeMemberpays:)
    @NSManaged public func removeFromMemberpays(_ values: NSSet)

}
