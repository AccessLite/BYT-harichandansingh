//
//  OperationViewController.swift
//  Boarding Pass
//
//  Created by Harichandan Singh on 11/26/16.
//  Copyright © 2016 Harichandan Singh. All rights reserved.
//

import UIKit

class OperationViewController: UIViewController, UITextViewDelegate, UITextFieldDelegate {
    //MARK: - Properties
    var operation: FoassOperation? = nil
    var uri: String {
        return (operation?.url)!
    }
    var targetURL: URL {
        return URL(string: "https://www.foaas.com\(uri)".addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)!
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
        self.navigationItem.hidesBackButton = false
        loadUI(url: targetURL)
    }
    
    func loadUI(url: URL) {
        // 1. This incurs a lot of network calls. Our goal is going to be making 1 single API call per operation to get
        //      the needed preview text. Then we store that locally, and update our preview text through string manipulations.
        
        // 2. It's not a huge inefficiency by any means, but by hard coding the 3 text field values we limit how
        //      update-able our code is and incur additional "technical debt" from potentially introducing bugs
        //      since code will need to be updated in several places if any changes to the UI need to be made.
        //      Perhaps it might be better to create a UIView subclass, with a text field and label that we could
        //      add X times to a UIStackView to only generate the number of views we need... hint hint
        
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
        guard textField.text != nil || textField.text?.isEmpty == false else { return }
        
        var componentsArray: [String] = (operation?.url)!.components(separatedBy: "/")
        var componentPosition: Int!
        
        switch textField {
        case nameTextField: componentPosition = 2
        case fromTextField: componentPosition = 3
        case referenceTextField: componentPosition = 4
        default:
            assertionFailure("Should never get here")
        }
        
        componentsArray[componentPosition] = textField.text!
        let uri = componentsArray.joined(separator: "/")
        self.operation?.url = uri
        let newURL: URL = URL(string: "https://www.foaas.com\(uri)".addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)!
        
        self.loadUI(url: newURL)
    }
    
    //MARK: - Actions
    @IBAction func selectButtonTapped(_ sender: UIBarButtonItem) {
        let endpoint: String = (self.operation?.url)!
        let url = URL(string: "https://www.foaas.com\(endpoint)".addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)!
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.post(name: Notification.Name(rawValue: "FoaasObjectDidUpdate"), object: nil, userInfo: [ "url" : url ])
        
        dismiss(animated: true, completion: nil)
    }
    
}

