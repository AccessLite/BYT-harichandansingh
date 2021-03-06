//
//  FoassViewController.swift
//  Boarding Pass
//
//  Created by Harichandan Singh on 11/26/16.
//  Copyright © 2016 Harichandan Singh. All rights reserved.
//

import UIKit

class FoassViewController: UIViewController {
    //MARK: - Properties
    static let profanityToggle: Bool = true
    
    //MARK: - Outlets
    @IBOutlet weak var mainTextLabel: UILabel!
    @IBOutlet weak var subtitleTextLabel: UILabel!
    
    //MARK: - Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        FoassDataManager.shared.requestOperations { (operations: [FoassOperation]?) in
            //not sure what I should be doing with this completion handler
        }
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
                FoassDataManager.foassURL = updatedUrl
                loadFoass()
            }
        }
    }
    
    func loadFoass() {
        FoassDataManager.getFoass(url: FoassDataManager.foassURL) { (object: Foass?) in
            DispatchQueue.main.async {
                if FoassViewController.profanityToggle {
                    self.mainTextLabel.text = object?.message.filterFoulWords()
                    self.subtitleTextLabel.text = object?.subtitle.filterFoulWords()
                }
                else {
                    self.mainTextLabel.text = object?.message
                    self.subtitleTextLabel.text = object?.subtitle
                }
            }
        }
    }
    
    internal func createScreenShotCompletion(image: UIImage, didFinishSavingWithError: NSError?, contextInfo: UnsafeMutableRawPointer?) {
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        var alert: UIAlertController
        
        // present appropriate message in UIAlertViewController
        if didFinishSavingWithError != nil {
            alert = UIAlertController(title: "Error", message: "There was an issue saving the image", preferredStyle: .alert)
        }
        else {
            alert = UIAlertController(title: "Screenshot Taken!", message: "Image saved to camera roll", preferredStyle: .alert)
        }
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
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
    
    @IBAction func foassViewControllerTapped(_ sender: UITapGestureRecognizer) {
        let activityViewController = UIActivityViewController(
            activityItems: [self.mainTextLabel.text!, self.subtitleTextLabel.text!],
            applicationActivities: nil)
        present(activityViewController, animated: true, completion: nil)
    }
    
    @IBAction func foassViewControllerLongPressed(_ sender: UILongPressGestureRecognizer) {
        if sender.state == UIGestureRecognizerState.began {
            UIGraphicsBeginImageContextWithOptions(self.view.frame.size, false, UIScreen.main.scale)
            view.layer.render(in: UIGraphicsGetCurrentContext()!)
            let image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            UIImageWriteToSavedPhotosAlbum(image!, self, #selector(createScreenShotCompletion(image:didFinishSavingWithError:contextInfo:)), nil)
        }
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "tableViewSegue" {
            //Nothing to pass here.
        }
    }
    
}
