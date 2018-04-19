//
//  MemberPay+CoreDataProperties.swift
//  CoreDataTest
//
//  Created by Jiawei Zhou on 4/18/18.
//  Copyright © 2018 Jiawei Zhou. All rights reserved.
//
//

import Foundation
import CoreData


extension MemberPay {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MemberPay> {
        return NSFetchRequest<MemberPay>(entityName: "MemberPay")
    }

    @NSManaged public var amount: Float
    @NSManaged public var date: NSDate?
    @NSManaged public var isPayoff: Bool
    @NSManaged public var name: String?
    @NSManaged public var member: Member?
    @NSManaged public var pay: Pay?

}
