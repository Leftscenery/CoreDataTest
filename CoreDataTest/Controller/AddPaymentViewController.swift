//
//  AddPaymentViewController.swift
//  CoreDataTest
//
//  Created by Jiawei Zhou on 3/25/18.
//  Copyright © 2018 Jiawei Zhou. All rights reserved.
//

import UIKit
import CoreData

class AddPaymentViewController: UIViewController{
    
    //General
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var selectedPlan : Plan?
    var isPayment : Bool  = true

    @IBOutlet weak var paymentName: UITextField!
    @IBOutlet weak var paymentAmount: UITextField!
    
    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBAction func payType(_ sender: UISegmentedControl) {
        switch segmentControl.selectedSegmentIndex {
        case 0:
            isPayment = true
        case 1:
            isPayment = false
        default:
            isPayment = true
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

//MARK: - ADD
    
    @IBAction func addPayment(_ sender: UIButton) {
        //写入数据库
        let context = self.getNSContext()
        let entity = NSEntityDescription.entity(forEntityName: "SinglePayment", in: context)
        let newPayment = SinglePayment(entity: entity!, insertInto: context)
        newPayment.name = paymentName.text
        newPayment.isPayment = self.isPayment
        newPayment.date = Date() as NSDate
        newPayment.plans = self.selectedPlan
        do{
            try context.save()
        }catch{}
        if let navController = self.navigationController {
            navController.popViewController(animated: true)
        }
    }
    

//MARK: - CoreData方法集合
    //获取NSContext
    func getNSContext() -> NSManagedObjectContext{
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
