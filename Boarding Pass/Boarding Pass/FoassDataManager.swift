//
//  FoassDataManager.swift
//  Boarding Pass
//
//  Created by Harichandan Singh on 11/25/16.
//  Copyright © 2016 Harichandan Singh. All rights reserved.
//

import Foundation

class FoassDataManager {
    //MARK: - Properties
    static let shared: FoassDataManager = FoassDataManager()
    private static let operationsKey: String = "FoaasOperationsKey"
    private static let defaults = UserDefaults.standard
    internal private(set) var operations: [FoassOperation]?
    static var foassURL: URL = URL(string: "https://www.foaas.com/because/Anonymous")!
    
    //MARK: - Initializers
    private init() {}
    
    //MARK: - Methods
    internal func requestOperations(_ operations: @escaping ([FoassOperation]?)->Void) {
        if !FoassDataManager.shared.load() {
            FoassAPIManager.getOperations(completion: { (operationsArray: [FoassOperation]?) in
                if operationsArray != nil {
                    print("Successfully contacted API and created array of Operations")
                    if let unwrappedOperationsArray = operationsArray {
                        FoassDataManager.shared.save(operations: unwrappedOperationsArray)
                    }
                }
            })
        }
    }
    
    internal class func getFoass(url: URL, completion: @escaping (Foass?) -> Void) {
        FoassAPIManager.getFoass(url: url) { (foass: Foass?) in
            completion(foass)
        }
    }
    
    func save(operations: [FoassOperation]) {
        let data: [Data] = operations.flatMap{ try? $0.toData() }
        FoassDataManager.defaults.set(data, forKey: FoassDataManager.operationsKey)
        print("Saved data to User Defaults: \(FoassDataManager.defaults)")
        FoassDataManager.shared.operations = operations
    }
    
    func load() -> Bool {
        guard let defaultsData = FoassDataManager.defaults.value(forKey: FoassDataManager.operationsKey) as? [Data] else { return false }
        let operationsArray = defaultsData.flatMap{ FoassOperation(data: $0) }
        FoassDataManager.shared.operations = operationsArray
        print("Loaded operations")
        return true
    }
    
    func deleteStoredOperations() {
        FoassDataManager.defaults.set(nil, forKey: FoassDataManager.operationsKey)
    }
}
