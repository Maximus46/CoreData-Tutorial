//
//  ContactsTableViewController.swift
//  CoreData-Lesson
//
//  Created by Riccardo Arnone on 21/02/17.
//  Copyright © 2017 Riccardo Arnone. All rights reserved.
//

import UIKit
import CoreData

class ContactsTableViewController: UITableViewController, NSFetchedResultsControllerDelegate {

    var fetchedResultsController : NSFetchedResultsController<Contact>!
    var contactToPass: Contact?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // TODO: Create and configure a fetchRequest in order to display all the contacts
        
        
        // TODO: Set the fetchedResultsController with the fetchRequest
        
        // TODO: Set the ContactsTableViewController as the fetchedResultsController's delegate
        
        // TODO: Perform fetch
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

// MARK: - UITableViewDataSource
    override func numberOfSections(in tableView: UITableView) -> Int {
        // TODO: Check if there are sections and in case get the number of sections
        return 0
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // TODO: Get numberOfRowsInSection
        return 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ContactCell", for: indexPath) as! ContactCell
        
        // TODO: Get the contact for the indexPath from the fetchedResultsController
        
        // TODO: Configure the cell
        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        // TODO: Get the sections title from the fetchedResultsController
        return nil
    }
    
// MARK: - UITableViewDelegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // TODO: Pass the selected object
        performSegue(withIdentifier: "showContactDetails", sender: self)
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let deleteAction = UITableViewRowAction(style: .destructive, title: "Delete", handler: {
            (action, indexPath) in
            
            // TODO: Get the contact you want to delete from the fetchedResultController
            
            // TODO: Delete it from the managedContext and save changes.
        })
        
        deleteAction.backgroundColor = UIColor.red
        return [deleteAction]
    }

    
// MARK: - NSFetchedResultsControllerDelegate
    // Notifies the controller changes are about to occur
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
            tableView.beginUpdates()
    }
    
    // Tells which object has changed, what kind of change occurred and the affected indexPaths
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        switch type {
        case .insert:
            tableView.insertRows(at: [newIndexPath!], with: .automatic)
        case .delete:
            tableView.deleteRows(at: [indexPath!], with: .automatic)
        case .update:
            let cell = tableView.cellForRow(at: indexPath!) as! ContactCell
            let contact = fetchedResultsController.object(at: indexPath!)
            cell.configure(with: contact)
            
        case .move:
            tableView.deleteRows(at: [indexPath!], with: .automatic)
            tableView.insertRows(at: [newIndexPath!], with: .automatic)
        }
    }
    
    // Applies the changes
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    // Tells which section has changed, what kind of change occurred and the affected indexPaths
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        
        let indexSet = IndexSet(integer: sectionIndex)
        
        switch type {
        case .insert:
            tableView.insertSections(indexSet, with: .automatic)
        case .delete:
            tableView.deleteSections(indexSet, with: .automatic)
        default:
            break
        }
    }

// MARK: - Navigation
    
    // Unwind segue to back from details View when clicking on Save
    @IBAction func didFinishEditing(segue: UIStoryboardSegue){
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addContact" {
            let navigationController = segue.destination as! UINavigationController
            let nextViewController = navigationController.topViewController as! AddContactTableViewController
            nextViewController.delegate = self
        }
        
        if segue.identifier == "showContactDetails" {
            // Edit the navigation Bar title and items to conform to edit context
            let nextViewController = segue.destination as! AddContactTableViewController
            nextViewController.navigationItem.leftBarButtonItem = nil
            nextViewController.title = "Edit Contact"
            nextViewController.contactToEdit = contactToPass
        }
    }
}

extension ContactsTableViewController: AddContactTableViewControllerDelegate {
    func addContactTableViewControllerDidCancel(_ controller: AddContactTableViewController,_ contact: Contact?) {
        // TODO: Save context after deleting the contact
        dismiss(animated: true, completion: nil)
    }
    func addContactTableViewControllerDidSave(_ controller: AddContactTableViewController) {
        dismiss(animated: true, completion: nil)
    }
}
