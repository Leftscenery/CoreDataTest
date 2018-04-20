//
//  AddPaymentViewController.swift
//  CoreDataTest
//
//  Created by Jiawei Zhou on 3/25/18.
//  Copyright © 2018 Jiawei Zhou. All rights reserved.
//

import UIKit
import CoreData

class AddPaymentViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, PaymentTableViewCellDelegate, UITextFieldDelegate{
    
    //Model
    struct MemberPayment {
        var amount: Float = 0
        var name: String = ""
        var isSpecial: Bool = false
    }
    
    var member: [MemberPayment] = []
    var amount: Float = 0
    var date: Date = Date()
    var name: String = ""
    var rest: Float = 0
    var plan: PlanList?
    
    //General
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var selectedPlan : PlanList?

    @IBOutlet weak var paymentName: UITextField!
    @IBOutlet weak var paymentAmount: UITextField!
    @IBOutlet weak var payViewController: UITableView!
    @IBOutlet weak var payOff: UISwitch!
    @IBOutlet weak var evenButtonUI: UIButton!
    @IBAction func evenButton(_ sender: UIButton) {
        for index in 0..<member.count{
            member[index].isSpecial = false
        }
        changeAmount()
    }
    
    @IBAction func savePayment(_ sender: UIBarButtonItem) {
        //Payment写入
        let context = self.getNSContext()
        let entityPay = NSEntityDescription.entity(forEntityName: "Pay", in: context)
        let entityMemberPay = NSEntityDescription.entity(forEntityName: "MemberPay", in: context)
        let newPayment = Pay(entity: entityPay!, insertInto: context)
        newPayment.name = paymentName.text
        newPayment.isPayOff = payOff.isOn
        newPayment.date = Date() as NSDate
        if payOff.isOn{
            var total: Float = 0
            member.map{ total += $0.amount}
            newPayment.amount = total
        }else{
            newPayment.amount = amount
        }
        newPayment.plan = self.selectedPlan
        //memberPay写入
        for memberInfo in (selectedPlan?.members)!{
            if let selectMemberInfo:Member = memberInfo as? Member{
                for memberData in member{
                    if memberData.name == selectMemberInfo.name{
                        let newMemberPayment = MemberPay(entity: entityMemberPay!, insertInto: context)
                        newMemberPayment.amount = memberData.amount
                        newMemberPayment.date = date as NSDate
                        newMemberPayment.isPayoff = payOff.isOn
                        newMemberPayment.name = selectMemberInfo.name
                        newMemberPayment.pay = newPayment
                        newMemberPayment.member = selectMemberInfo
                    }
                }
            }
        }
        //更新Plan信息
        if payOff.isOn{
            member.map{ amount += $0.amount }
            selectedPlan?.paid += amount
            selectedPlan?.rest = (selectedPlan?.amount)! - amount
        }else{
            selectedPlan?.amount += amount
            selectedPlan?.rest += amount
        }
        //更新member信息
        var arralizeMember:[Member] = Array(selectedPlan!.members!) as! [Member]
        for index in 0..<arralizeMember.count{
            for indexX in 0..<member.count{
                if member[indexX].name == arralizeMember[index].name!{
                    if payOff.isOn{
                        arralizeMember[index].paid += member[index].amount
                        arralizeMember[index].rest = arralizeMember[index].amount - member[index].amount
                    }else{
                        arralizeMember[index].amount += member[index].amount
                        arralizeMember[index].rest += member[index].amount
                    }
                }
            }
        }
        let newArralizeMember = NSSet(array: arralizeMember)
        selectedPlan?.members = newArralizeMember
        //整体写入
        do{
            try context.save()
        }catch{}
        if let navController = self.navigationController {
            navController.popViewController(animated: true)
        }
    }
    
    //计算费用
    @objc func changeAmount(){
        if payOff.isOn{
        }else{
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
        }
        payViewController.reloadData()
    }
    
    @objc func changeMode(){
        if payOff.isOn{
            evenButtonUI.isHidden = true
            paymentAmount.isHidden = true
            for index in 0..<member.count{
                member[index].amount = 0
                payViewController.reloadData()
            }
        }else{
            paymentAmount.isHidden = false
            evenButtonUI.isHidden = false
            for index in 0..<member.count{
                member[index].isSpecial = false
            }
            changeAmount()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        payViewController.delegate = self
        payViewController.dataSource = self
        paymentAmount.addTarget(self, action: #selector(changeAmount), for: .editingChanged)
        payOff.addTarget(self, action: #selector(changeMode), for: .valueChanged)
        paymentName.delegate = self
        paymentAmount.delegate = self
        payOff.setOn(false, animated: true)
        
        //init Array
        for memberInfo in (selectedPlan?.members)!{
            if let memberData:Member = memberInfo as? Member{
                var newMember = MemberPayment()
                newMember.amount = 0
                newMember.name = memberData.name!
                newMember.isSpecial = false
                member.append(newMember)
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
        paymentAmount.removeTarget(self, action: #selector(changeAmount), for: .editingChanged)
        payOff.removeTarget(self, action: #selector(changeMode), for: .valueChanged)
    }
    
    //MARK: - Keyboard move
    @objc private func keyboardWillShow(notification: NSNotification) {
        let userInfo:NSDictionary = notification.userInfo! as NSDictionary
        let keyboardFrame:NSValue = userInfo.value(forKey: UIKeyboardFrameEndUserInfoKey) as! NSValue
        let keyboardRectangle = keyboardFrame.cgRectValue
        let keyboardHeight = keyboardRectangle.height
        let currentTextField: UITextField = view.currentFirstResponder()! as! UITextField
        if currentTextField.frame.origin.y == 6{
            view.frame.origin.y = -keyboardHeight
        }
    }
    @objc private func keyboardWillHide() {
        view.frame.origin.y = 0
    }
    
    //MARK: - Cell Delegate Func
    func updateAmount(index: Int, amount: Float, isSpecial: Bool) {
        member[index].amount = amount
        member[index].isSpecial = isSpecial
        changeAmount()
        self.view.endEditing(true)
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
        cell.isPayOff = payOff.isOn
        cell.origin = String(member[indexPath.row].amount)
        cell.delegate = self
        cell.amount = (paymentAmount.text! as NSString).floatValue
        return cell
    }
    
    //MARK: - Textfield Delegate
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.view.endEditing(true)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
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
