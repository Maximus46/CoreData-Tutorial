//
//  ContactCell.swift
//  CoreData-Lesson
//
//  Created by Riccardo Arnone on 21/02/17.
//  Copyright © 2017 Riccardo Arnone. All rights reserved.
//

import UIKit

class ContactCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var surnameLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    func configure(with contact: Contact){
        nameLabel.text = contact.name
        surnameLabel.text = contact.surname
    }
}
