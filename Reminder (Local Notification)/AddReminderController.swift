//
//  AddReminderController.swift
//  Reminder (Local Notification)
//
//  Created by Admin on 05/12/22.
//

import UIKit

class AddReminderController: UIViewController {

    @IBOutlet var titleField: UITextField!
    @IBOutlet var bodyField: UITextField!
    @IBOutlet var datePicker: UIDatePicker!
    
    public var complition: ((String, String, Date) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(didTapSaveButton))
    }
    

    @objc func didTapSaveButton(){
        if let titleText = titleField.text, !titleText.isEmpty,
           let bodyText = bodyField.text, !bodyText.isEmpty {
            
            let targetDate = datePicker.date
            complition?(titleText, bodyText, targetDate)
        }
    }
    
}
