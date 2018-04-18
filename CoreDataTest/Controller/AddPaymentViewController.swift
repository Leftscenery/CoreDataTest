//
//  AddPaymentViewController.swift
//  CoreDataTest
//
//  Created by Jiawei Zhou on 3/25/18.
//  Copyright © 2018 Jiawei Zhou. All rights reserved.
//

import UIKit
import CoreData

class AddPaymentViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, PaymentTableViewCellDelegate{
    
    struct memberPayment {
        var amount: Float = 0
        var name: String = ""
        var isSpecial: Bool = false
    }
    //Data
    var member: [memberPayment] = []
    var amount: Float = 0
    var date: Date = Date()
    var isPayOff: Bool = false
    var name: String = ""
    var rest: Float = 0
    
    //General
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var selectedPlan : PlanList?

    @IBOutlet weak var paymentName: UITextField!
    @IBOutlet weak var paymentAmount: UITextField!
    @IBOutlet weak var payViewController: UITableView!
    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBAction func payType(_ sender: UISegmentedControl) {
        switch segmentControl.selectedSegmentIndex {
        case 0:
            isPayOff = true
        case 1:
            isPayOff = false
        default:
            isPayOff = true
        }
    }
    
    @IBAction func evenButton(_ sender: UIButton) {
        for index in 0..<member.count{
            member[index].isSpecial = false
        }
        changeAmount()
    }
    
    //计算费用
    @objc func changeAmount(){
        amount = (paymentAmount.text! as NSString).floatValue
        rest = amount
        for index in 0..<member.count{
            if member[index].isSpecial{
                rest = rest - member[index].amount
            }
        }
        for index in 0..<member.count{
            if !member[index].isSpecial{
                member[index].amount = rest / Float(member.filter{!$0.isSpecial}.count)
            }
        }
        payViewController.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        payViewController.delegate = self
        payViewController.dataSource = self
        paymentAmount.addTarget(self, action: #selector(changeAmount), for: .editingChanged)
        
        //init Array
        for memberInfo in (selectedPlan?.members)!{
            if let memberData:Member = memberInfo as? Member{
                var newMember = memberPayment()
                newMember.amount = 0
                newMember.name = memberData.name!
                newMember.isSpecial = false
                member.append(newMember)
            }
            
        }
        
        // Do any additional setup after loading the view.
    }
    
    //MARK: - Cell Delegate Func
    func updateAmount(index: Int, amount: Float, isSpecial: Bool) {
        member[index].amount = amount
        member[index].isSpecial = isSpecial
        changeAmount()
        payViewController.reloadData()
    }
    
    //MARK: - TableView Datasource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return member.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "payCell", for: indexPath) as! PaymentTableViewCell
        cell.name.text = member[indexPath.row].name
        cell.payment.text = String(member[indexPath.row].amount)
        cell.indexNumber = indexPath.row
        cell.isSpecial = false
        cell.origin = String(member[indexPath.row].amount)
        cell.delegate = self
        cell.amount = (paymentAmount.text! as NSString).floatValue
        return cell
    }
    

    //MARK: - ADD
    
    @IBAction func addPayment(_ sender: UIButton) {
        //写入数据库
        let context = self.getNSContext()
        let entity = NSEntityDescription.entity(forEntityName: "Pay", in: context)
        let newPayment = Pay(entity: entity!, insertInto: context)
        newPayment.name = paymentName.text
        newPayment.isPayOff = self.isPayOff
        newPayment.date = Date() as NSDate
        newPayment.plan = self.selectedPlan
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
