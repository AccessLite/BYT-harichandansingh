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
    var operation: FoassOperation!
    var uri: String {
        return (operation?.url)!
    }
    var targetURL: URL {
        return URL(string: "https://www.foaas.com\(uri)".addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)!
    }
    var fpb: FoassPathBuilder?
    
    //MARK: - Outlets
    @IBOutlet weak var previewTextView: UITextView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var fromLabel: UILabel!
    @IBOutlet weak var fromTextField: UITextField!
    @IBOutlet weak var referenceLabel: UILabel!
    @IBOutlet weak var referenceTextField: UITextField!
    @IBOutlet weak var scrollViewBottomLayoutGuideConstraint: NSLayoutConstraint!
    
    
    //MARK: - Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        fpb = FoassPathBuilder(operation: self.operation)
        registerForKeyboardNotification()
        hideKeyboard()
        self.navigationItem.hidesBackButton = false
        loadUI(url: targetURL)
    }
    
    func registerForKeyboardNotification() {
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(self.keyboardWillShow), name: Notification.Name(rawValue: "UIKeyboardWillShowNotification"), object: nil)
        notificationCenter.addObserver(self, selector: #selector(self.keyboardWillHide), name: Notification.Name(rawValue: "UIKeyboardWillHideNotification"), object: nil)
    }
    
    internal func keyboardWillShow(sender: Notification) {
        let userInfo = sender.userInfo!
        let keyboardFrame: CGRect = (userInfo[UIKeyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        let keyboardHeight: CGFloat = keyboardFrame.height
        scrollViewBottomLayoutGuideConstraint.constant = keyboardHeight
        self.view.updateConstraints()
        print("Showing keyboard.")
    }
    
    internal func keyboardWillHide(sender: Notification) {
        scrollViewBottomLayoutGuideConstraint.constant = 0
        self.view.updateConstraints()
        print("Hiding keyboard.")
    }
    
    func hideKeyboard() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func loadUI(url: URL) {
        // 1. This incurs a lot of network calls. Our goal is going to be making 1 single API call per operation to get
        //      the needed preview text. Then we store that locally, and update our preview text through string manipulations.
        
        // 2. It's not a huge inefficiency by any means, but by hard coding the 3 text field values we limit how
        //      update-able our code is and incur additional "technical debt" from potentially introducing bugs
        //      since code will need to be updated in several places if any changes to the UI need to be made.
        //      Perhaps it might be better to create a UIView subclass, with a text field and label that we could
        //      add X times to a UIStackView to only generate the number of views we need... hint hint
        FoassDataManager.getFoass(url: url, completion: { (foass: Foass?) in
            DispatchQueue.main.async {
                self.previewTextView.text = foass?.description
                guard let allKeys: [String] = self.fpb?.allKeys() else { return }
                
                switch self.operation!.fields.count {
                case 2:
                    self.nameLabel.text = ":\(allKeys[0])"
                    self.nameTextField.placeholder = allKeys[0]
                    self.fromLabel.text = ":\(allKeys[1])"
                    self.fromTextField.placeholder = allKeys[1]
                    
                    self.referenceLabel.isHidden = true
                    self.referenceTextField.isHidden = true
                case 3:
                    self.nameLabel.text = ":\(allKeys[0])"
                    self.nameTextField.placeholder = allKeys[0]
                    self.fromLabel.text = ":\(allKeys[1])"
                    self.fromTextField.placeholder = allKeys[1]
                    self.referenceLabel.text = ":\(allKeys[2])"
                    self.referenceTextField.placeholder = allKeys[2]
                    
                default:
                    self.nameLabel.text = ":\(allKeys[0])"
                    self.nameTextField.placeholder = allKeys[0]
                    
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
        guard let allKeys: [String] = self.fpb?.allKeys() else { return }
        guard let text = textField.text, text.characters.count > 0 else { return }
        
        switch textField {
        case nameTextField:
            self.fpb?.update(key: allKeys[0], value: text)
        case fromTextField:
            self.fpb?.update(key: allKeys[1], value: text)
        case referenceTextField:
            self.fpb?.update(key: allKeys[2], value: text)
        default:
            assertionFailure("Should never get here.")
        }
        
        if let newURL = URL(string: "https://www.foaas.com" + (self.fpb?.build())!) {
            loadUI(url: newURL)
        }
        
    }
    
    //MARK: - Actions
    @IBAction func selectButtonTapped(_ sender: UIBarButtonItem) {
        let endpoint: String = (self.fpb?.build())!
        let url = URL(string: "https://www.foaas.com\(endpoint)".addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)!
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.post(name: Notification.Name(rawValue: "FoaasObjectDidUpdate"), object: nil, userInfo: [ "url" : url ])
        
        dismiss(animated: true, completion: nil)
    }
    
}
