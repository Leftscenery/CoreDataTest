//
//  PaymentTableViewCell.swift
//  CoreDataTest
//
//  Created by Jiawei Zhou on 4/17/18.
//  Copyright © 2018 Jiawei Zhou. All rights reserved.
//

import UIKit

protocol PaymentTableViewCellDelegate {
    func updateAmount(index: Int, amount: Float, isSpecial: Bool)
}

class PaymentTableViewCell: UITableViewCell, UITextFieldDelegate {
    var delegate: PaymentTableViewCellDelegate?
    var indexNumber: Int = 0
    var isSpecial: Bool = false
    var origin: String = ""
    var amount: Float = 0
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var payment: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        payment.addTarget(self, action: #selector(changeAmount), for: .editingChanged)
        // Initialization code
    }
    
    @objc func changeAmount() {
        if (payment.text! as NSString).floatValue > amount{
            payment.text = String(amount)
        }
        if payment.text != origin{
            isSpecial = true
            delegate?.updateAmount(index: indexNumber, amount: (payment.text! as NSString).floatValue, isSpecial: isSpecial)
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
