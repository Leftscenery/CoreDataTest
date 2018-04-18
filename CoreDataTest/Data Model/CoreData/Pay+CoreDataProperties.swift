//
//  Pay+CoreDataProperties.swift
//  CoreDataTest
//
//  Created by Jiawei Zhou on 4/17/18.
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
    @NSManaged public var isPayOff: Bool
    @NSManaged public var date: NSDate?
    @NSManaged public var name: String?
    @NSManaged public var member: Member?
    @NSManaged public var plan: PlanList?

}
