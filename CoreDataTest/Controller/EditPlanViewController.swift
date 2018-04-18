//
//  addPlanViewController.swift
//  CoreDataTest
//
//  Created by Jiawei Zhou on 4/16/18.
//  Copyright © 2018 Jiawei Zhou. All rights reserved.
//

import UIKit
import CoreData

class EditPlanViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, MemberTableViewCellDelegate, UITextFieldDelegate {
    
    //Member Struct
    struct memberData {
        var name: String = ""
        var origin : String = ""
    }
    
    //General
    var selectedPlan : PlanList?
    
    private var memberArray: [memberData] = []
    @IBOutlet weak var planName: UITextField!
    @IBOutlet weak var planDate: UIDatePicker!
    @IBOutlet weak var memberTableView: UITableView!
    @IBOutlet weak var isDefault: UISwitch!
    @IBAction func addMember(_ sender: UIButton) {
        let newMember = memberData()
        memberArray.append(newMember)
        memberTableView.reloadData()
    }
    //写入数据库建立新项目
    @IBAction func addPlan(_ sender: UIBarButtonItem) {
        selectedPlan?.name = planName.text
        selectedPlan?.date = planDate.date as NSDate
        selectedPlan?.isPayOff = false
        selectedPlan?.isCurrent = isDefault.isOn

        //NSSet to Array
        var arralizeMember:[Member] = Array(selectedPlan!.members!) as! [Member]
        //New Member
        let newMemberArray = memberArray.filter{ return (($0.origin == "") && ($0.name
             != ""))}
        for index in 0..<newMemberArray.count{
            let newMember = Member()
            newMember.name = newMemberArray[index].name
            newMember.amount = 0
            newMember.paid = 0
            newMember.rest = 0
            newMember.plan = selectedPlan
        }
        //Delete Member
        let deleteMemberArray = memberArray.filter{ return (($0.origin != "") && ($0.name
            == ""))}
        for index in 0..<deleteMemberArray.count{
            for indexX in 0..<arralizeMember.count{
                if deleteMemberArray[index].origin == arralizeMember[indexX].name{
                    arralizeMember.remove(at: indexX)
                }
            }
        }
        //Update Member
        let updatedMemberArray = memberArray.filter{ return (($0.origin != "") && ($0.name
            != ""))}
        for index in 0..<updatedMemberArray.count{
            for indexX in 0..<arralizeMember.count{
                if updatedMemberArray[index].origin == arralizeMember[indexX].name{
                    arralizeMember[indexX].name = updatedMemberArray[index].name
                }
            }
        }
        //Array to NSSet
        let newArralizeMember = NSSet(array: arralizeMember)
        //Save
        selectedPlan?.members = newArralizeMember
        do{
            try self.getNSContext().save()
        }catch{}
        if let navController = self.navigationController {
            navController.popViewController(animated: true)
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        memberTableView.delegate = self
        memberTableView.dataSource = self
        planName.delegate = self
        
        //init
        self.title = selectedPlan?.name
        planName.text = selectedPlan?.name
        planDate.date = (selectedPlan?.date)! as Date
        isDefault.isOn = (selectedPlan?.isCurrent)!
        for obj in (selectedPlan?.members)!{
            let memberContent: Member = obj as! Member
            var newMemberData = memberData()
            newMemberData.name = memberContent.name!
            newMemberData.origin = memberContent.name!
            memberArray.append(newMemberData)
        }
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
//        let userInfo:NSDictionary = notification.userInfo! as NSDictionary
//        let keyboardFrame:NSValue = userInfo.value(forKey: UIKeyboardFrameEndUserInfoKey) as! NSValue
//        let keyboardRectangle = keyboardFrame.cgRectValue
//        let keyboardHeight = keyboardRectangle.height
        let currentTextField: UITextField = view.currentFirstResponder()! as! UITextField
        if currentTextField.frame.origin.y == 0{
            view.frame.origin.y = -57
        }
    }
    @objc private func keyboardWillHide() {
        view.frame.origin.y = 0
    }
    
    //MARK: - TableView Cell Delegate
    func deleteMemberInfo(index: Int) {
        memberArray[index].name = ""
        memberTableView.reloadData()
    }
    
    func updateMemberInfo(index: Int, text: String) {
        memberArray[index].name = text
        self.view.endEditing(true)
        memberTableView.reloadData()
    }
    
    
    //MARK: - Textfield Delegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true;
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
        cell.memberName.text = memberArray[indexPath.row].name
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

