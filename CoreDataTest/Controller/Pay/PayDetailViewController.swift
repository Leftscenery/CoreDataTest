//
//  PayDetailViewController.swift
//  CoreDataTest
//
//  Created by Jiawei Zhou on 3/25/18.
//  Copyright © 2018 Jiawei Zhou. All rights reserved.
//

import UIKit

class PayDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    //General
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var selectedPlan : PlanList?
    var selectedPay: Pay?
    
    
    @IBOutlet weak var memberPayDetailTable: UITableView!
    @IBOutlet weak var payOff: UILabel!
    @IBOutlet weak var amount: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var name: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        payOff.isHidden = !(selectedPay?.isPayOff)!
        name.text = "Name: "+(selectedPay?.name)!
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        date.text = "Date: "+formatter.string(from: (selectedPay?.date)! as Date)
        amount.text = "Amount: "+(NSString(format: "%.2f",(selectedPay?.amount)!) as String) as String
        memberPayDetailTable.delegate  = self
        memberPayDetailTable.dataSource = self
        // Do any additional setup after loading the view.
    }
    
    //Table View Delegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (selectedPlan?.members?.count)!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "memberDetailTableCell", for: indexPath)
        let memberPayData = Array(selectedPay!.memberpays!) as! [MemberPay]
        cell.textLabel?.text = memberPayData[indexPath.row].name
        cell.detailTextLabel?.text = String(memberPayData[indexPath.row].amount)
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
