//
//  MemberTableViewCell.swift
//  CoreDataTest
//
//  Created by Jiawei Zhou on 4/16/18.
//  Copyright © 2018 Jiawei Zhou. All rights reserved.
//

import UIKit

protocol MemberTableViewCellDelegate {
    func deleteMemberInfo(index: Int)
    func updateMemberInfo(index: Int, text: String)
}

class MemberTableViewCell: UITableViewCell, UITextFieldDelegate {
    
    var delegate : MemberTableViewCellDelegate?
    var indexNumber: Int = 0
    @IBOutlet weak var memberName: UITextField!
    @IBAction func deleteMember(_ sender: UIButton) {
        delegate?.deleteMemberInfo(index: indexNumber)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        memberName.delegate = self
        // Initialization code
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        delegate?.updateMemberInfo(index: indexNumber, text: textField.text!)
        return true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
