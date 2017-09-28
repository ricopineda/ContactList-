//
//  AddEventViewController.swift
//  Exam3
//
//  Created by Enrico Pineda on 9/27/17.
//  Copyright © 2017 Enrico Pineda. All rights reserved.
//

import UIKit
import CoreData

class AddEventViewController: UIViewController {
    
    var delegate: AddEventDel?
    var indexPath: NSIndexPath?
    var name: String?
    var time: Date?



    
    @IBOutlet weak var titleText: UITextField!
    @IBOutlet weak var infoText: UITextView!
    @IBOutlet weak var timePicker: UIDatePicker!

    override func viewDidLoad() {
        super.viewDidLoad()
        titleText.text = name
        timePicker.date = time!

    }
    @IBAction func cancelButtonPressed(_ sender: UIButton) {
        delegate?.cancelButton(controller: self)
    }
    
    
    @IBAction func saveButtonPressed(_ sender: UIButton) {
        delegate?.saveButton(controller: self, name: titleText.text!, time: timePicker.date, from: indexPath)
    }


    @IBAction func timePickerUsed(_ sender: UIDatePicker) {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH.mm"
        var timePicker = formatter.string(from: sender.date)
    }
}
