//
//  PlanData.swift
//  CoreDataTest
//
//  Created by Jiawei Zhou on 4/16/18.
//  Copyright © 2018 Jiawei Zhou. All rights reserved.
//

import Foundation
import CoreData

struct PlanData {
    var name: String = ""
    var date: Date = Date()
    var isCurrent: Bool = false
    var isPayOff : Bool = false
    var paid: Float = 0
    var rest: Float = 0
    
}
