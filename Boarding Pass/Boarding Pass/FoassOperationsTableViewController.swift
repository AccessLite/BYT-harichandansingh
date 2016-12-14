//
//  FoassOperationsTableViewController.swift
//  Boarding Pass
//
//  Created by Harichandan Singh on 11/26/16.
//  Copyright © 2016 Harichandan Singh. All rights reserved.
//

import UIKit

class FoassOperationsTableViewController: UITableViewController {
    //MARK: - Properties
    let cellIdentifier = "operationsCellIdentifier"
    
    //MARK: - Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Operations"
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return FoassDataManager.shared.operations!.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        let operation = FoassDataManager.shared.operations?[indexPath.row]
        cell.textLabel?.font = UIFont.systemFont(ofSize: 18.0, weight: UIFontWeightBold)
        if FoassViewController.profanityToggle {
            cell.textLabel?.text = operation?.name.filterFoulWords()
        }
        else {
            cell.textLabel?.text = operation?.name
        }
        return cell
    }
    
    //MARK: - Actions
    @IBAction func doneButtonTapped(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "operationSegue" {
            if let ovc = segue.destination as? OperationViewController {
                if let cell = sender as? UITableViewCell {
                    ovc.navigationItem.title = cell.textLabel?.text
                    
                    let indexPath = tableView.indexPath(for: cell)
                    let operation = FoassDataManager.shared.operations?[indexPath!.row]
                    ovc.operation = operation
                }
            }
        }
    }
    
}
