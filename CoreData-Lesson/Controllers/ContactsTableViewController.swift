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
        
        //Create and configure a fetchRequest
        let fetchRequest: NSFetchRequest<Contact> = Contact.fetchRequest()
        fetchRequest.propertiesToFetch = ["name","surname"]
        let nameSort = NSSortDescriptor(key: #keyPath(Contact.name), ascending: true)
        fetchRequest.sortDescriptors = [nameSort]
        
        //Set the fetchedResultsController with the fetchRequest
        fetchedResultsController = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: CoreDataStack.shared.managedContext,
            sectionNameKeyPath: #keyPath(Contact.name),
            cacheName: nil
        )
        
        //Set the ContactsTableViewController as the fetchedResultsController's delegate
        fetchedResultsController.delegate = self
        
        do {
            try fetchedResultsController.performFetch()
        }
        catch let error as NSError {
            print("Fetching error: \(error), \(error.userInfo)")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

// MARK: - UITableViewDataSource
    override func numberOfSections(in tableView: UITableView) -> Int {
        //Check if there are sections and in case get the number of sections
        guard let sections = fetchedResultsController.sections else {
            return 0
        }
        return sections.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sectionInfo = fetchedResultsController.sections?[section] else {
            return 0
        }
        return sectionInfo.numberOfObjects
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ContactCell", for: indexPath) as! ContactCell
        
        let contact = fetchedResultsController.object(at: indexPath)
        
        cell.configure(with: contact)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let sectionInfo = fetchedResultsController.sections?[section]
        let firstCharacter = sectionInfo?.name.characters.first
        return String(describing: firstCharacter!)
    }
    
// MARK: - UITableViewDelegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //Assign the selected object to the 'contactToPass' variable
        
        contactToPass = fetchedResultsController.object(at: indexPath)
        performSegue(withIdentifier: "showContactDetails", sender: self)
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let deleteAction = UITableViewRowAction(style: .destructive, title: "Delete", handler: {
            (action, indexPath) in
            
            //First get the contact we want to delete from the fetchedResultController
            //then delete it from the managedContext and save changes.
            let contact = self.fetchedResultsController.object(at: indexPath)
            contact.delete()
        })
        
        deleteAction.backgroundColor = UIColor.red
        return [deleteAction]
    }

    
// MARK: - NSFetchedResultsControllerDelegate
    //Notifies the controller changes are about to occur
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
            tableView.beginUpdates()
    }
    
    //Tells which object has changed, what kind of change occurred and the affected indexPaths
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
    
    //Applies the changes
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    //Tells which section has changed, what kind of change occurred and the affected indexPaths
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
    
    //Unwind segue to back from details View when clicking on Save
    @IBAction func didFinishEditing(segue: UIStoryboardSegue){
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addContact" {
            let navigationController = segue.destination as! UINavigationController
            let nextViewController = navigationController.topViewController as! AddContactTableViewController
            nextViewController.delegate = self
        }
        
        if segue.identifier == "showContactDetails" {
            //Edit the navigation Bar title and items to conform to edit context
            let nextViewController = segue.destination as! AddContactTableViewController
            nextViewController.navigationItem.leftBarButtonItem = nil
            nextViewController.title = "Edit Contact"
            nextViewController.contactToEdit = contactToPass
        }
    }
}

extension ContactsTableViewController: AddContactTableViewControllerDelegate {
    func addContactTableViewControllerDidCancel(_ controller: AddContactTableViewController,_ contact: Contact?) {
        //Delete the contact
        //Save context after deleting the contact
        contact?.delete()
        dismiss(animated: true, completion: nil)
    }
    func addContactTableViewControllerDidSave(_ controller: AddContactTableViewController) {
        dismiss(animated: true, completion: nil)
    }
}
