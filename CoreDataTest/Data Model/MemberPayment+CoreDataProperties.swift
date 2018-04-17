//
//  MemberPayment+CoreDataProperties.swift
//  CoreDataTest
//
//  Created by Jiawei Zhou on 3/24/18.
//  Copyright © 2018 Jiawei Zhou. All rights reserved.
//
//

import Foundation
import CoreData


extension MemberPayment {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MemberPayment> {
        return NSFetchRequest<MemberPayment>(entityName: "MemberPayment")
    }

    @NSManaged public var name: String?
    @NSManaged public var amount: Float
    @NSManaged public var payments: SinglePayment?

}
