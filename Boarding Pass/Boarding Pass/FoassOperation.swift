//
//  FoassOperation.swift
//  Boarding Pass
//
//  Created by Harichandan Singh on 11/22/16.
//  Copyright © 2016 Harichandan Singh. All rights reserved.
//

import Foundation

final class FoassOperation: JSONConvertible, DataConvertible {
    //MARK: - Properties
    let name: String
    let url: String
    let fields: [[String: AnyObject]] // this should be [FoaasField]
  
    //MARK; - Initializers
    init(name: String, url: String, fields: [[String: AnyObject]]) {
        self.name = name
        self.url = url
        self.fields = fields
    }
    
    required convenience init?(json: [String : AnyObject]) {
        guard let name = json["name"] as? String,
            let url = json["url"] as? String,
            let fields = json["fields"] as? [[String: AnyObject]]
            else { return nil }
      
        // convert 'fields' into [FoaasField]
        self.init(name: name, url: url, fields: fields)
    }
    
    required convenience init?(data: Data) {
        do {
            let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: AnyObject]
            
            if let validJson = json {
                self.init(json: validJson)
            } else {
                return nil
            }
        }
        catch {
            print("Error casting from data: \(error)")
            return nil
        }
    }
    
    //MARK: - Methods
    func toJson() -> [String : AnyObject] {
        let json: [String: AnyObject] =
            ["name": self.name as AnyObject,
             "url": self.url as AnyObject,
             "fields": self.fields as AnyObject // this won't work once 'fields' is type [FoaasField]
        ]
        return json
    }
    
    func toData() throws -> Data {
        // this protocol should/can be written as a single line.
        // consider the following:
        // 1. should toData() handle the throw, or should the calling function?
        // 2. What information does your NSError give that JSONSerialization's built-in error doesn't?
        let json = self.toJson()
        
        do {
            // always semi-descriptive var names, please
            let x = try JSONSerialization.data(withJSONObject: json, options: [])
            return x
        }
        catch {
            throw NSError(domain: "Error converting to Data type", code: 1, userInfo: nil)
        }
    }
}
