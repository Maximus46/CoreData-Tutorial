//
//  PhoneCell.swift
//  CoreData-Lesson
//
//  Created by Riccardo Arnone on 21/02/17.
//  Copyright © 2017 Riccardo Arnone. All rights reserved.
//

import UIKit

class PhoneCell: UITableViewCell {
    
    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var numberTextField: UITextField!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(with phone: Phone, at index: Int){
        idLabel.text = "Phone " + String(index)
        numberTextField.text = phone.number
    }
}
