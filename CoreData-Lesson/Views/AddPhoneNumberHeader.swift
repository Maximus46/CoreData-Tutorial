//
//  AddPhoneNumberHeader.swift
//  CoreData-Lesson
//
//  Created by Riccardo Arnone on 21/02/17.
//  Copyright © 2017 Riccardo Arnone. All rights reserved.
//

import UIKit

//Used to inform its delegate about the button tapped event.
protocol AddPhoneNumberHeaderDelegate: class {
    func addPhoneNumberHeaderDidTap(_ view: UITableViewHeaderFooterView, in section: Int)
}

class AddPhoneNumberHeader: UITableViewHeaderFooterView {
    
    weak var delegate: AddPhoneNumberHeaderDelegate?
    
    var sectionNumber: Int!
    
    @IBAction func didTapButton(_ sender: UIButton) {
        delegate?.addPhoneNumberHeaderDidTap(self, in: sectionNumber)
    }
}
