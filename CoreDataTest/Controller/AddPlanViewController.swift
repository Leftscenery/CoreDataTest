//
//  addPlanViewController.swift
//  CoreDataTest
//
//  Created by Jiawei Zhou on 4/16/18.
//  Copyright © 2018 Jiawei Zhou. All rights reserved.
//

import UIKit

class AddPlanViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var planName: UITextField!
    @IBOutlet weak var planDate: UIDatePicker!
    @IBOutlet weak var memberTableView: MemberTableView!
    @IBOutlet weak var isDefault: UISwitch!
    @IBAction func addMember(_ sender: UIButton) {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        memberTableView.delegate = self
        memberTableView.dataSource = self
        // Do any additional setup after loading the view.
    }
    
    
    //MARK: - TableView Delegate
    
    
    
    //MARK: - TableView Data
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "addNewMember", for: indexPath) as! MemberTableViewCell
        cell.memberName.text = "Text"
        return cell
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
