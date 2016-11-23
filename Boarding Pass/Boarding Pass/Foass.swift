//
//  Foass.swift
//  Boarding Pass
//
//  Created by Harichandan Singh on 11/22/16.
//  Copyright © 2016 Harichandan Singh. All rights reserved.
//

import Foundation

class Foass: JSONConvertible, CustomStringConvertible {
    //MARK: - Properties
    let message: String
    let subtitle: String
    var description: String {
        return (message + "\n" + subtitle)
    }
    
    //MARK: - Initializers
    init(message: String, subtitle: String) {
        self.message = message
        self.subtitle = subtitle
    }
    
    required convenience init?(json: [String : AnyObject]) {
        guard let message = json["message"] as? String,
            let subtitle = json["subtitle"] as? String
            else { return nil }
        
        self.init(message: message, subtitle: subtitle)
    }
    
    //MARK: - Methods
    func toJson() -> [String : AnyObject] {
        return [
            "message": self.message as AnyObject,
            "subtitle": self.subtitle as AnyObject
        ]
    }
}
