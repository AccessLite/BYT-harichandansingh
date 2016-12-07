//
//  FoassPathBuilder.swift
//  Boarding Pass
//
//  Created by Harichandan Singh on 12/6/16.
//  Copyright © 2016 Harichandan Singh. All rights reserved.
//

import Foundation

class FoassPathBuilder {
    //MARK: - Properties
    var operation: FoassOperation!
    var operationFields: [String : String]!
    
    //MARK: - Initializers
    init(operation: FoassOperation) {
        var output: [String: String] = [:]
        _ = operation.fields.flatMap { output[$0.field] = "field"}
        
        self.operation = operation
        self.operationFields = output
    }
    
    //MARK: - Methods
    func build() -> String {
        var operationURLString: String = self.operation.url
        for (k,v) in self.operationFields {
            operationURLString = operationURLString.replacingOccurrences(of: ":\(k)", with: v)
        }
        return operationURLString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
    }
    
    func update(key: String, value: String)  {
        if let _ = self.operationFields[key] {
            self.operationFields[key] = value
        }
    }
    
    func indexOf(key: String) -> Int? {
        let urlComponentArray = operation.url.components(separatedBy: "/:")
        return urlComponentArray.contains(key) ? urlComponentArray.index(of: key)! - 1 : nil
    }
    
    func allKeys() -> [String] {
        return self.operation.fields.map { $0.field }
    }
}
