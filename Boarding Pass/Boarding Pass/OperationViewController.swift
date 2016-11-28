//
//  OperationViewController.swift
//  Boarding Pass
//
//  Created by Harichandan Singh on 11/26/16.
//  Copyright © 2016 Harichandan Singh. All rights reserved.
//

import UIKit

class OperationViewController: UIViewController, UITextViewDelegate, UITextFieldDelegate {
    //MARK: - Propvaries
    var operation: FoassOperation? = nil
    var uri: String {
        return (operation?.url)!
    }
    var targetURL: URL {
        return URL(string: "https://www.foaas.com\(uri)")!
    }
    
    //MARK: - Outlets
    @IBOutlet weak var previewTextView: UITextView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var fromLabel: UILabel!
    @IBOutlet weak var fromTextField: UITextField!
    @IBOutlet weak var referenceLabel: UILabel!
    @IBOutlet weak var referenceTextField: UITextField!
    
    //MARK: - Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.hidesBackButton = true
        loadUI(url: targetURL)
    }
    
    func loadUI(url: URL) {
        FoassAPIManager.getFoass(url: url, completion: { (foass: Foass?) in
            DispatchQueue.main.async {
                self.previewTextView.text = foass?.description
                switch self.operation!.fields.count {
                case 2:
                    self.nameLabel.text = ":\(self.operation!.fields[0].name.lowercased())"
                    self.nameTextField.placeholder = "\(self.operation!.fields[0].name.lowercased())"
                    self.fromLabel.text = ":\(self.operation!.fields[1].name.lowercased())"
                    self.fromTextField.placeholder = "\(self.operation!.fields[1].name.lowercased())"
                    
                    self.referenceLabel.isHidden = true
                    self.referenceTextField.isHidden = true
                case 3:
                    self.nameLabel.text = ":\(self.operation!.fields[0].name.lowercased())"
                    self.nameTextField.placeholder = "\(self.operation!.fields[0].name.lowercased())"
                    self.fromLabel.text = ":\(self.operation!.fields[1].name.lowercased())"
                    self.fromTextField.placeholder = "\(self.operation!.fields[1].name.lowercased())"
                    self.referenceLabel.text = ":\(self.operation!.fields[2].name.lowercased())"
                    self.referenceTextField.placeholder = "\(self.operation!.fields[2].name.lowercased())"
                    
                default:
                    self.nameLabel.text = ":\(self.operation!.fields[0].name.lowercased())"
                    self.nameTextField.placeholder = "\(self.operation!.fields[0].name.lowercased())"
                    self.fromTextField.isHidden = true
                    
                    self.fromLabel.isHidden = true
                    self.fromTextField.isHidden = true
                    self.referenceLabel.isHidden = true
                    self.referenceTextField.isHidden = true
                }
            }
        })
    }
    
    //MARK: - Text Field Delegate Methods
    func textFieldDidEndEditing(_ textField: UITextField) {
        switch textField {
        case nameTextField:
            var x = (operation?.url)!.components(separatedBy: "/")
            x[2] = nameTextField.text!
            let uri = x.joined(separator: "/")
            operation?.url = uri
            let newURL: URL = URL(string: "https://www.foaas.com\(uri)")!
            loadUI(url: newURL)
        case fromTextField:
            var x = (operation?.url)!.components(separatedBy: "/")
            x[3] = fromTextField.text!
            let uri = x.joined(separator: "/")
            operation?.url = uri
            let newURL: URL = URL(string: "https://www.foaas.com\(uri)")!
            loadUI(url: newURL)
        case referenceTextField:
            var x = (operation?.url)!.components(separatedBy: "/")
            x[4] = referenceTextField.text!
            let uri = x.joined(separator: "/")
            operation?.url = uri
            let newURL: URL = URL(string: "https://www.foaas.com\(uri)")!
            loadUI(url: newURL)
        default:
            print("Should never reach this point.")
        }
    }
    
    //MARK: - Actions
    @IBAction func selectButtonTapped(_ sender: UIBarButtonItem) {
        
        //            FoassAPIManager.getFoass(url: url) { (foass: Foass?) in
        //
        //            }
        //            dismiss(animated: true, completion: nil)
        
        let endpoint: String = (self.operation?.url)!
        let url = URL(string: "https://www.foaas.com\(endpoint)")!
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.post(name: Notification.Name(rawValue: "FoaasObjectDidUpdate"), object: nil, userInfo: [ "url" : url ])
        
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    }
    
    
}

