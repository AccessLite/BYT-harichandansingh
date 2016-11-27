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
    static var mainText: String = ""
    static var subtitleText: String = ""
    
    //MARK: - Outlets
    @IBOutlet weak var mainTextLabel: UILabel!
    @IBOutlet weak var subtitleTextLabel: UILabel!
    
    
    //MARK: - Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        loadFoass()
    }
    
    func loadFoass() {
        FoassAPIManager.getFoass(url: FoassAPIManager.foassURL) { (object: Foass?) in
            DispatchQueue.main.async {
                self.mainTextLabel.text = object?.message
                self.subtitleTextLabel.text = object?.subtitle
            }
        }
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "tableViewSegue" {
            //Nothing to pass here.
        }
    }
    
}
