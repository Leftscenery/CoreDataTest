//
//  MemberSummary+CoreDataProperties.swift
//  CoreDataTest
//
//  Created by Jiawei Zhou on 3/24/18.
//  Copyright © 2018 Jiawei Zhou. All rights reserved.
//
//

import Foundation
import CoreData


extension MemberSummary {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MemberSummary> {
        return NSFetchRequest<MemberSummary>(entityName: "MemberSummary")
    }

    @NSManaged public var amount: Float
    @NSManaged public var paid: Float
    @NSManaged public var rest: Float
    @NSManaged public var name: String?
    @NSManaged public var plans: Plan?
    @NSManaged public var singlePayments: NSSet?

}

// MARK: Generated accessors for singlePayments
extension MemberSummary {

    @objc(addSinglePaymentsObject:)
    @NSManaged public func addToSinglePayments(_ value: SinglePayment)

    @objc(removeSinglePaymentsObject:)
    @NSManaged public func removeFromSinglePayments(_ value: SinglePayment)

    @objc(addSinglePayments:)
    @NSManaged public func addToSinglePayments(_ values: NSSet)

    @objc(removeSinglePayments:)
    @NSManaged public func removeFromSinglePayments(_ values: NSSet)

}
