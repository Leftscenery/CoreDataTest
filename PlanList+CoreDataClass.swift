//
//  PlanList+CoreDataClass.swift
//  CoreDataTest
//
//  Created by Jiawei Zhou on 4/18/18.
//  Copyright © 2018 Jiawei Zhou. All rights reserved.
//
//

import Foundation
import CoreData

@objc(PlanList)
public class PlanList: NSManagedObject {
    
    func updateAmount(){
        let arrayPays:[Pay] = Array(self.pays!) as! [Pay]
        var amount: Float = 0
        var rest: Float = 0
        var paid: Float = 0
        for eachPay in arrayPays{
            if eachPay.isPayOff{
                paid += eachPay.amount
                rest -= eachPay.amount
            }else{
                amount += eachPay.amount
                rest += eachPay.amount
            }
        }
        self.amount = amount
        self.paid = paid
        self.rest = rest
    }
}
