//
//  ViewController.swift
//  Reminder (Local Notification)
//
//  Created by Admin on 05/12/22.
//

import UIKit
import UserNotifications

class ViewController: UIViewController {

    var model = [MyReminder]()
    
    let tableView: UITableView = {
           let table = UITableView()
           table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
           return table
       }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "Reminder"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped))
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Test", style: .done, target: self, action: #selector(test))
    }

    override func viewDidLayoutSubviews() {
            super.viewDidLayoutSubviews()
            tableView.frame = view.bounds
        }
    
    @objc func addButtonTapped(){
        // show add vc
        guard let vc = storyboard?.instantiateViewController(identifier: "add") as? AddReminderController
        else {
            return
        }
        vc.title = "New Reminder"
        vc.navigationItem.largeTitleDisplayMode = .automatic
        vc.complition = { title, body , date in
            DispatchQueue.main.async {
                self.navigationController?.popToRootViewController(animated: true)
                let new = MyReminder(title: title, date: date, identifier: "id_\(title)")
                self.model.append(new)
                self.tableView.reloadData()
                
                //now scheduling the event
                let content = UNMutableNotificationContent()
                content.title = title
                content.sound = .default
                content.body = body
                
                let targetDate = date //.addingTimeInterval(10)
                let trigger = UNCalendarNotificationTrigger(dateMatching: Calendar.current.dateComponents([.year, .month, .day , .hour ,.minute, .second], from: targetDate), repeats: false)
                
                let request = UNNotificationRequest(identifier: "some_long_id", content: content, trigger: trigger)
                UNUserNotificationCenter.current().add(request) { error in
                    if error != nil {
                        print("Something went wrong")
                    }
                    
               }
            }
            
        }
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func test(){
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert,.badge, .sound]) { success, error in
            if success {
                //schedule test
                self.scheduleTest()
            }
            else if let error = error{
                print("\(error.localizedDescription)")
            }
        }
    }
    func scheduleTest(){
        // 1-> request
        // 2-> content parameter(title, body, sound)
        // 3-> triger(date, location)
        
        let content = UNMutableNotificationContent()
        content.title = "Hello World"
        content.sound = .default
        content.body = "---------- Wake Up alarm-------------------------"
        
        let targetDate = Date().addingTimeInterval(10)
        let trigger = UNCalendarNotificationTrigger(dateMatching: Calendar.current.dateComponents([.year, .month, .day , .hour ,.minute, .second], from: targetDate), repeats: false)
        
        let request = UNNotificationRequest(identifier: "some_long_id", content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request) { error in
            if error != nil {
                print("Something went wrong")
            }
            
       }
        
        
    }

}

extension ViewController: UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = model[indexPath.row].title
       // let date = model[indexPath.row].date
        //we are converting date into string
//        let formatter = DateFormatter()
//        formatter.detailTextLabel?.text = "MM, DD , YYYY"
//        cell.detailTextLabel?.text = formatter.string(from: date)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
