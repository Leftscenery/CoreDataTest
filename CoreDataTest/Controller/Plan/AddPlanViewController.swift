//
//  addPlanViewController.swift
//  CoreDataTest
//
//  Created by Jiawei Zhou on 4/16/18.
//  Copyright © 2018 Jiawei Zhou. All rights reserved.
//

import UIKit
import CoreData

class AddPlanViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, MemberTableViewCellDelegate, UITextFieldDelegate {
    
    private var memberArray: [String] = [""]
    @IBOutlet weak var planName: UITextField!
    @IBOutlet weak var planDate: UIDatePicker!
    @IBOutlet weak var memberTableView: UITableView!
    @IBOutlet weak var isDefault: UISwitch!
    @IBAction func addMember(_ sender: UIButton) {
        memberArray.append("")
        memberTableView.reloadData()
    }
    //写入数据库建立新项目
    @IBAction func addPlan(_ sender: UIBarButtonItem) {
        let context = self.getNSContext()
        let entityPlanList = NSEntityDescription.entity(forEntityName: "PlanList", in: context)
        let entityMember = NSEntityDescription.entity(forEntityName: "Member", in: context)
        let newPlan = PlanList(entity: entityPlanList!, insertInto: context)
        if planName.text?.count == 0{
            newPlan.name = "New Plan"
        }else{
            newPlan.name = planName.text
        }
       
        newPlan.date = planDate.date as NSDate
        newPlan.isPayOff = false
        newPlan.isCurrent = isDefault.isOn
        //导入Member
        for index in 0..<memberArray.count{
            let newMember = Member(entity: entityMember!, insertInto: context)
            newMember.name = memberArray[index] == "" ? "newMember\(index)" : memberArray[index]
            newMember.amount = 0
            newMember.paid = 0
            newMember.rest = 0
            newMember.plan = newPlan
        }
        do{
            try context.save()
        }catch{}
        if let navController = self.navigationController {
            navController.popViewController(animated: true)
        }
    }
    
    //MARK: - View Did Load
    override func viewDidLoad() {
        super.viewDidLoad()
        memberTableView.delegate = self
        memberTableView.dataSource = self
        planName.delegate = self
        isDefault.setOn(false, animated: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
    }
    
    //MARK: - Keyboard move
    @objc private func keyboardWillShow(notification: NSNotification) {
        let userInfo:NSDictionary = notification.userInfo! as NSDictionary
        let keyboardFrame:NSValue = userInfo.value(forKey: UIKeyboardFrameEndUserInfoKey) as! NSValue
        let keyboardRectangle = keyboardFrame.cgRectValue
        let keyboardHeight = keyboardRectangle.height
        let currentTextField: UITextField = view.currentFirstResponder()! as! UITextField
        if currentTextField.frame.origin.y == 0{
            view.frame.origin.y = -keyboardHeight
        }
    }
    @objc private func keyboardWillHide() {
        view.frame.origin.y = 0
    }
    
    //MARK: - TableView Cell Delegate
    func deleteMemberInfo(index: Int) {
        memberArray.remove(at: index)
        memberTableView.reloadData()
    }
    
    func updateMemberInfo(index: Int, text: String) {
        memberArray[index] = text
        self.view.endEditing(true)
        memberTableView.reloadData()
    }
    
    
    //MARK: - Textfield Delegate
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.view.endEditing(true)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
    
    //MARK: - TableView Delegate
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memberArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "addNewMember", for: indexPath) as! MemberTableViewCell
        cell.memberName.text = memberArray[indexPath.row]
        cell.indexNumber = indexPath.row
        cell.delegate = self
        return cell
    }
    
    
    //CoreData方法集合
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

extension UIView {
    func currentFirstResponder() -> UIResponder? {
        if self.isFirstResponder {
            return self
        }
        
        for view in self.subviews {
            if let responder = view.currentFirstResponder() {
                return responder
            }
        }
        return nil
    }
}


