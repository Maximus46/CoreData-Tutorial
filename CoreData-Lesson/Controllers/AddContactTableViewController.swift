//
//  AddContactTableViewController.swift
//  CoreData-Lesson
//
//  Created by Riccardo Arnone on 21/02/17.
//  Copyright © 2017 Riccardo Arnone. All rights reserved.
//

import UIKit

protocol AddContactTableViewControllerDelegate: class {
    func addContactTableViewControllerDidCancel(_ controller: AddContactTableViewController,_ contact: Contact?)
    func addContactTableViewControllerDidSave(_ controller: AddContactTableViewController)
}

enum StaticCell: Int {
    case firstName = 0, lastName, email
    
    var indexPath: IndexPath {
        return IndexPath(row: self.rawValue, section: 0)
    }
    var reuseIdentifier: String {
        return "StaticCell" + String(self.rawValue)
    }
    
    func textField(for tableView: UITableView) -> UITextField? {
        guard let cell = tableView.cellForRow(at: self.indexPath) else {
            return nil
        }
        return textField(for: cell)
    }
    
    func textField(for cell: UITableViewCell) -> UITextField? {
        for view in cell.contentView.subviews {
            if let textField = view as? UITextField {
                return textField
            }
        }
        return nil
    }
    
    func value(for tableView: UITableView) -> String? {
        return self.textField(for: tableView)?.text
    }
}

class AddContactTableViewController: UITableViewController {
    
// MARK: - Variables declaration
    weak var delegate: AddContactTableViewControllerDelegate?
    
    var phoneNumbers = [Phone]()
    var newContact: Contact?
    // If contactToEdit get passed then update phoneNumbers
    var contactToEdit: Contact? {
        didSet{
            if let numbers = contactToEdit?.phoneNumbers?.array as? [Phone] {
                phoneNumbers = numbers
            }
        }
    }
    
// MARK: - ViewControllers functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //Registering the NIB for the Phone section's header
        let headerNib = UINib(nibName: "AddPhoneNumberHeader", bundle: nil)
        tableView.register(headerNib, forHeaderFooterViewReuseIdentifier: "AddPhoneNumberHeader")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
// MARK: - UITableViewDataSource
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return section == 0 ? "Info" : "Numbers"
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 3
        }
        // Adding 1 row for "Add new contact"
        return 1 + phoneNumbers.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Handle static cells.
        if indexPath.section == 0 {
            let cellConfiguration = StaticCell(rawValue: indexPath.row)!
            let cell = tableView.dequeueReusableCell(
                withIdentifier: cellConfiguration.reuseIdentifier,
                for: indexPath)
            
            if contactToEdit != nil {
                let textField = cellConfiguration.textField(for: cell)
                
                switch cellConfiguration {
                case .firstName:
                    textField?.text = contactToEdit?.name
                case .lastName:
                    textField?.text = contactToEdit?.surname
                case .email:
                    textField?.text = contactToEdit?.email
                }
            }
            return cell
        }
        // Handle the "Add phone number" static cell in section 1.
        else if indexPath.section == 1 && indexPath.row == 0 {
            return tableView.dequeueReusableCell(withIdentifier: "AddPhone", for: indexPath)
        }
        // Handle phone numbers.
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "PhoneCell", for: indexPath) as! PhoneCell
            
            let phone = phoneNumbers[indexPath.row - 1]
            
            cell.configure(with: phone, at: indexPath.row)
            return cell
        }
    }

// MARK: - UITableViewDelegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath == IndexPath(row: 0, section: 1) {
            let alert = createAlert(title: "New Phone", message: "Add a new number")
            present(alert, animated: true)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let deleteAction = UITableViewRowAction(style: .destructive, title: "Delete", handler: {
            (action, indexPath) in
            
            // TODO: Get the phone you want to delete from the phone List
            // TODO: Delete it from the managedContext and save changes.
        })
        
        deleteAction.backgroundColor = UIColor.red
        return [deleteAction]
    
    }
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        if indexPath.section == 1 && indexPath.row > 0 {
            return .delete
        }
        
        return .none
    }
    

// MARK: - @IBActions
    @IBAction func cancelDidPress(_ sender: UIBarButtonItem) {
        delegate?.addContactTableViewControllerDidCancel(self, newContact)
    }
    
    @IBAction func saveDidPress(_ sender: UIBarButtonItem) {
        
        // Check if we're creating a new contact
        // TODO: Create and save a new contact in the database with data inside the textfields
        let firstName = StaticCell.firstName.value(for: tableView)
        let lastName = StaticCell.lastName.value(for: tableView)
        let email = StaticCell.email.value(for: tableView)
        if contactToEdit == nil {
            // TODO: Save changes and call the delegate
            delegate?.addContactTableViewControllerDidSave(self)
        }
        // If we're editing a contact
        // TODO: Update its info with the ones in the textfields
        else {
            contactToEdit?.name = firstName
            contactToEdit?.surname = lastName
            contactToEdit?.email = email
            for phone in phoneNumbers {
                phone.contact = contactToEdit
            }
            // Save changes and back to ContactsList
            CoreDataStack.shared.saveContext()
            performSegue(withIdentifier: "showContactList", sender: self)
        }
    }

// MARK: - Alerts
    func createAlert(title: String, message: String) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let saveAction = UIAlertAction(title: "Save", style: .default) { [unowned self] action in
            guard let textField = alert.textFields?.first, let numberToSave = textField.text else {
                return
            }
            
            // TODO: Create a new phoneobject and add it to the phone lists
            self.tableView.reloadData()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        // Add the buttons
        alert.addTextField()
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        return alert
    }
}
