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
        // again, your code will crash here if URI contains a space, making this necesary. 
        // ideally, you should only have 1 point to access this new URL so that you only have to worry about
        // adding the percent encoding stuff to one place in your code. re-think how you'd like to implement this
        // I would suggest replacing occurance of URL(string:) with URLComponents if possible, ensuring that % encoding
        // is part of the URLComponent process.. if not, try and bring in URLQueryItem.
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
        
        // We want to allow someone to back out of this operation to choose a different one
        self.navigationItem.hidesBackButton = false // true
        loadUI(url: targetURL)
    }
    
    func loadUI(url: URL) {
        // I like this working solution. Here are some things to consider for the following weeks: 
        
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
        
        // 1. Your code throws an exception when your text fields contains text with a whitespace value.
        // This is because a URL cannot be created with a path component that contains a non-percent-encoded value.
        
        // 2. There is also a lot of repeated code for each case. Makes it arguealy more explicit, but at the cost of
        // introducing technical debt by violating DRY
        
        // 3. How are you guaranteeing that the component index values for each textfield will always be the same?
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
        // we don't want to change the URL for the operation: 
        // it's our model and should not be manipulated after being set. 
        // Though your code relies on this change in order to be able to update your main VC. but this is not 
        // a good solution
        self.operation?.url = uri
        
        // all the force-unwrapping here isn't ideal, but suitable for our needs
        let newURL: URL = URL(string: "https://www.foaas.com\(uri)".addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)!
        
        self.loadUI(url: newURL)
    }
    
    //MARK: - Actions
    @IBAction func selectButtonTapped(_ sender: UIBarButtonItem) {
        
        let endpoint: String = (self.operation?.url)!
        
        // you code will crash here without percent-encoded endpoint value
        let url = URL(string: "https://www.foaas.com\(endpoint)")!
        
        // Well done on the use of Notification Center!
        let notificationCenter = NotificationCenter.default
        notificationCenter.post(name: Notification.Name(rawValue: "FoaasObjectDidUpdate"), object: nil, userInfo: [ "url" : url ])
        
        dismiss(animated: true, completion: nil)
    }
    
}

