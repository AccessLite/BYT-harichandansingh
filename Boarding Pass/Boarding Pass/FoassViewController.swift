//
//  FoassViewController.swift
//  Boarding Pass
//
//  Created by Harichandan Singh on 11/26/16.
//  Copyright © 2016 Harichandan Singh. All rights reserved.
//

import UIKit

class FoassViewController: UIViewController {
    //MARK: - Outlets
    @IBOutlet weak var mainTextLabel: UILabel!
    @IBOutlet weak var subtitleTextLabel: UILabel!
    
    
    //MARK: - Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        loadFoass()
        registerForNotifications()
    }
    
    internal func registerForNotifications() {
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(updateFoaas(sender:)), name: Notification.Name(rawValue: "FoaasObjectDidUpdate"), object: nil)
    }
    
    internal func updateFoaas(sender: Notification) {
        if let notificationBundle = sender.userInfo {
            if let updatedUrl = notificationBundle["url"] as? URL {
                FoassAPIManager.foassURL = updatedUrl
                loadFoass()
            }
        }
    }
    
    func loadFoass() {
        FoassAPIManager.getFoass(url: FoassAPIManager.foassURL) { (object: Foass?) in
            DispatchQueue.main.async {
                self.mainTextLabel.text = object?.message
                self.subtitleTextLabel.text = object?.subtitle
            }
        }
    }
    
    //MARK: - Actions
    @IBAction func octoButtonTouchedDown(_ sender: UIButton) {
        let newTransform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        let originalTransform = sender.imageView!.transform
        
        UIView.animate(withDuration: 0.1, animations: {
            sender.transform = newTransform
        }, completion: { (complete) in
            sender.transform = originalTransform
        })
    }

    
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "tableViewSegue" {
            //Nothing to pass here.
        }
    }
    
}
