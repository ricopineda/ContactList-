//
//  ViewController.swift
//  Exam3
//
//  Created by Enrico Pineda on 9/27/17.
//  Copyright © 2017 Enrico Pineda. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UITableViewController, AddEventDel{
    
    var incomplete = [Events]()
    
    var complete = [Events]()
    
    let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchIncomplete()
        fetchComplete()
        tableView.reloadData()

    }
    func fetchIncomplete(){
        let favRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Events")
        let firstPredicate = NSPredicate(format: "favorite == %@", NSNumber(value: false))
        favRequest.predicate = NSCompoundPredicate(type: .and, subpredicates: [firstPredicate])
        
        do {
            let favResult = try managedObjectContext.fetch(favRequest)
            incomplete = favResult as! [Events]
        } catch {
            print("\(error)")
        }
    }
    
    func fetchComplete(){
        let nonFavRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Events")
        let firstPredicate = NSPredicate(format: "favorite == %@", NSNumber(value: true))
        nonFavRequest.predicate = NSCompoundPredicate(type: .and, subpredicates: [firstPredicate])
        
        do {
            let favResult = try managedObjectContext.fetch(nonFavRequest)
            complete = favResult as! [Events]
        } catch {
            print("\(error)")
        }
        
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Complete"
        }
        else if section == 1 {
            return "Incomplete"
        }
        // ...
        return "Not here"
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return complete.count
        }
        return incomplete.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyCell")
        
        if indexPath.section == 0 {
            cell?.textLabel?.text = "\(complete[indexPath.row].eventtime!)\(complete[indexPath.row].eventname!)"
        } else {
            cell?.textLabel?.text = "\(incomplete[indexPath.row].eventtime!)\(incomplete[indexPath.row].eventname!)"
        }
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            complete[indexPath.row].favorite = false
        } else {
            incomplete[indexPath.row].favorite = true
        }
        do {
            try managedObjectContext.save()
        } catch {
            print("\(error)")
        }
        fetchIncomplete()
        fetchComplete()
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            let item = incomplete[indexPath.row]
            managedObjectContext.delete(item)
        
            do {
                try managedObjectContext.save()
            } catch {
                print("\(error)")
            }
        }
        incomplete.remove(at: indexPath.row)
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        performSegue(withIdentifier: "EditItem", sender: indexPath)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AddItem"{
            let addEventViewController = segue.destination as! AddEventViewController
            addEventViewController.delegate = self
        }
        else if segue.identifier == "EditItem"{
            let addEventViewController = segue.destination as! AddEventViewController
            addEventViewController.delegate = self
            
            let indexPath = sender as! NSIndexPath
            let text = incomplete[indexPath.row]
            addEventViewController.name = text.eventname!
            addEventViewController.time = text.eventtime! as Date
            addEventViewController.indexPath = indexPath
        }
    }
    
    func cancelButton(controller: AddEventViewController){
        dismiss(animated: true, completion: nil)
    }
    
    func saveButton(controller: AddEventViewController, name: String, time: Date, from: NSIndexPath?) {
        if let index = from{
            if from?.section == 0 {
                let newItem = complete[index.row]
                newItem.eventname = name
                newItem.eventtime = time as NSDate
                print(newItem)
            } else {
                let newItem = incomplete[index.row]
                newItem.eventname = name
                newItem.eventtime = time as NSDate
            }
            
        } else  {
            let newItem = NSEntityDescription.insertNewObject(forEntityName: "Events", into: managedObjectContext) as! Events
            newItem.eventname = name
            newItem.eventtime = time as NSDate
            newItem.favorite = false
            incomplete.append(newItem)
            print(newItem)
            print(managedObjectContext)
        }
        do {
            try managedObjectContext.save()
        } catch {
            print("\(error)")
        }
        
        fetchIncomplete()
        fetchComplete()
        self.tableView.reloadData()
        
        dismiss(animated: true, completion: nil)
    }

}































