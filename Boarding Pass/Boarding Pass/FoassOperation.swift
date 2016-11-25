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
    let fields: [FoassField]
    
    //MARK: - Initializers
    init(name: String, url: String, fields: [FoassField]) {
        self.name = name
        self.url = url
        self.fields = fields
    }
    
    required convenience init?(json: [String : AnyObject]) {
        guard let name = json["name"] as? String,
            let url = json["url"] as? String,
            let fields = json["fields"] as? [[String: AnyObject]]
            else { return nil }
        
        let allFields: [FoassField] = fields.flatMap{ FoassField(json: $0) }
        self.init(name: name, url: url, fields: allFields)
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
        return [
            "name": self.name as AnyObject,
            "url": self.url as AnyObject,
            "fields": self.fields.flatMap{ $0.toJson() } as AnyObject
        ]
    }
    
    func toData() throws -> Data {
        return try JSONSerialization.data(withJSONObject: self.toJson(), options: [])
    }
}
