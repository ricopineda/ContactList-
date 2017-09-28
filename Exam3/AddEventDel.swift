//
//  AddEventDel.swift
//  Exam3
//
//  Created by Enrico Pineda on 9/27/17.
//  Copyright © 2017 Enrico Pineda. All rights reserved.
//

import UIKit
import CoreData

protocol AddEventDel: class {
    
    func cancelButton(controller: AddEventViewController)
    
    func saveButton(controller: AddEventViewController, name: String, time: Date, info: String, from: NSIndexPath?)
}
