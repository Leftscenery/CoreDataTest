//
//  SinglePayment+CoreDataProperties.swift
//  CoreDataTest
//
//  Created by Jiawei Zhou on 3/24/18.
//  Copyright © 2018 Jiawei Zhou. All rights reserved.
//
//

import Foundation
import CoreData


extension SinglePayment {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SinglePayment> {
        return NSFetchRequest<SinglePayment>(entityName: "SinglePayment")
    }

    @NSManaged public var name: String?
    @NSManaged public var date: NSDate?
    @NSManaged public var amount: Float
    @NSManaged public var image: NSData?
    @NSManaged public var isPayment: Bool
    @NSManaged public var plans: Plan?
    @NSManaged public var memberPayments: NSSet?

}

// MARK: Generated accessors for memberPayments
extension SinglePayment {

    @objc(addMemberPaymentsObject:)
    @NSManaged public func addToMemberPayments(_ value: MemberPayment)

    @objc(removeMemberPaymentsObject:)
    @NSManaged public func removeFromMemberPayments(_ value: MemberPayment)

    @objc(addMemberPayments:)
    @NSManaged public func addToMemberPayments(_ values: NSSet)

    @objc(removeMemberPayments:)
    @NSManaged public func removeFromMemberPayments(_ values: NSSet)

}
