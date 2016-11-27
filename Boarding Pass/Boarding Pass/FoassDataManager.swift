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
    
    //MARK: - Initializers
    private init() {}
    
    //MARK: - Methods
    func save(operations: [FoassOperation]) {
        let data: [Data] = operations.flatMap{ try? $0.toData() }
        FoassDataManager.defaults.set(data, forKey: FoassDataManager.operationsKey)
        print("Saved data to User Defaults: \(FoassDataManager.defaults)")
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
