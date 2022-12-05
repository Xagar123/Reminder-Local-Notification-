//
//  ViewController.swift
//  pagination
//
//  Created by Admin on 05/12/22.
//

import UIKit

class ViewController: UIViewController {

    let data = ["one","two","three","four","five","one","two","three","four","five","one","two","three","four","five","one","two","three","four","five","one","two","three","four","five","one","two","three","four","five","one","two","three","four","five","one","two","three","four","five"]
    
    var limit = 10 // loading data at a time
    var totalCount = 0 //it will add inside view didload
    var index = 0 // it will specify the current index
    
    var displayData:[String] = Array()
    let tableView:UITableView = {
       let table = UITableView()
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return table
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
        totalCount = data.count
        
        //initial condition
        while index < limit {
            displayData.append(data[index])
            index = index + 1
        }
    }
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        tableView.frame = view.bounds
    }


}
extension ViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return displayData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = "\(indexPath.row). \(displayData[indexPath.row])"
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        // we are checking the last cell if its equal
        if indexPath.row == displayData.count-1 {
            
            var index = displayData.count-1 // storing last row index
            if index+1 >= data.count-1 {
                // if not so then we will find the remaning data
                limit = data.count - index
            }else{
                limit = index + 10
            }
            
            while index < limit {
                displayData.append(data[index])
                index = index + 1
            }
            self.perform(#selector(loadTable),with: nil, afterDelay: 0.5)
        }
    }
    @objc func loadTable(){
        self.tableView.reloadData()
    }
    
    
}

