//
//  FoassField.swift
//  Boarding Pass
//
//  Created by Harichandan Singh on 11/22/16.
//  Copyright © 2016 Harichandan Singh. All rights reserved.
//

import Foundation

class FoassField: JSONConvertible, CustomStringConvertible {
    //MARK: - Properties
    let name: String
    let field: String
    var description: String {
        return "Name: \(name) Field: \(field)"
    }
    
    //MARK: - Initializers
    init(name: String, field: String) {
        self.name = name
        self.field = field
    }
    
    required convenience init?(json: [String : AnyObject]) {
        guard let name = json["name"] as? String,
            let field = json["field"] as? String
            else { return nil }
        self.init(name: name, field: field)
    }
    
    //MARK: - Methods
    func toJson() -> [String : AnyObject] {
        return [
          "name": self.name as AnyObject,
          "field": self.field as AnyObject
        ]
    }
}
