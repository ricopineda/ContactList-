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
        let sort = NSSortDescriptor(key: "eventtime", ascending: true)
        let firstPredicate = NSPredicate(format: "favorite == %@", NSNumber(value: false))
        favRequest.sortDescriptors = [sort]
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
        let sort = NSSortDescriptor(key: "eventtime", ascending: true)
        nonFavRequest.sortDescriptors = [sort]
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
            return "Incomplete"
        }
        else if section == 1 {
            return "Complete"
        }
        // ...
        return "Not here"
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return incomplete.count
        }
        return complete.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyCell")!
        
        if indexPath.section == 0 {
            let formatter = DateFormatter()
            formatter.dateFormat = "h:mm a"
            formatter.amSymbol = "AM"
            formatter.pmSymbol = "PM"
            let eventdate = incomplete[indexPath.row].eventtime
            let dateString = formatter.string(from: eventdate! as Date)
            cell.textLabel?.text = dateString + " " + (incomplete[indexPath.row].eventname!)
        } else {
            let formatter = DateFormatter()
            formatter.dateFormat = "h:mm a"
            formatter.amSymbol = "AM"
            formatter.pmSymbol = "PM"
            let eventdate = complete[indexPath.row].eventtime
            let dateString = formatter.string(from: eventdate! as Date)
            cell.textLabel?.text = dateString + " " + (complete[indexPath.row].eventname!)
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            incomplete[indexPath.row].favorite = true
        } else {
            complete[indexPath.row].favorite = false
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
        
            incomplete.remove(at: indexPath.row)
            tableView.reloadData()
        }
        else{
            let item = complete[indexPath.row]
            managedObjectContext.delete(item)
            
            do {
                try managedObjectContext.save()
            } catch {
                print("\(error)")
            }
            
            complete.remove(at: indexPath.row)
            tableView.reloadData()
        }
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
                addEventViewController.info = text.information!
                addEventViewController.time = text.eventtime! as Date
                addEventViewController.indexPath = indexPath
        }
    }
    
    func cancelButton(controller: AddEventViewController){
        dismiss(animated: true, completion: nil)
    }
    
    func saveButton(controller: AddEventViewController, name: String, time: Date, info: String, from: NSIndexPath?) {
        if let index = from{
            if from?.section == 0 {
                let newItem = incomplete[index.row]
                newItem.eventname = name
                newItem.information = info
                newItem.eventtime = time as NSDate
                print(newItem)
            } else {
                let newItem = complete[index.row]
                newItem.eventname = name
                newItem.information = info
                newItem.eventtime = time as NSDate
            }
            
        } else  {
            let newItem = NSEntityDescription.insertNewObject(forEntityName: "Events", into: managedObjectContext) as! Events
            newItem.eventname = name
            newItem.information = info
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































