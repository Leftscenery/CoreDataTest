//
//  Pay+CoreDataProperties.swift
//  CoreDataTest
//
//  Created by Jiawei Zhou on 4/18/18.
//  Copyright © 2018 Jiawei Zhou. All rights reserved.
//
//

import Foundation
import CoreData


extension Pay {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Pay> {
        return NSFetchRequest<Pay>(entityName: "Pay")
    }

    @NSManaged public var amount: Float
    @NSManaged public var date: NSDate?
    @NSManaged public var isPayOff: Bool
    @NSManaged public var name: String?
    @NSManaged public var memberpays: NSSet?
    @NSManaged public var plan: PlanList?

}

// MARK: Generated accessors for memberpays
extension Pay {

    @objc(addMemberpaysObject:)
    @NSManaged public func addToMemberpays(_ value: MemberPay)

    @objc(removeMemberpaysObject:)
    @NSManaged public func removeFromMemberpays(_ value: MemberPay)

    @objc(addMemberpays:)
    @NSManaged public func addToMemberpays(_ values: NSSet)

    @objc(removeMemberpays:)
    @NSManaged public func removeFromMemberpays(_ values: NSSet)

}
