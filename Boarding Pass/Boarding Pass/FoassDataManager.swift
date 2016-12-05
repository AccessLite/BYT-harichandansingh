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
      
        // Get into the habit of doing a "Reset Content and Settings", deleting your app off the sim or running the app on multiple sims, and thinking about
        // the "first run" use case. Why? Because your app crashes on the first run in a clean sim/device. And just like 
        // you need to be aware of three special interation cases in your code (-1, 0 and 1), the first run should be it's own
        // separate check every time.
        //
        // Your tableVC is looking for FoassDataManager.shared.operations.count to populate the correnct number of cells
        // However, that value is nil on your first run because your save() function doesn't save the passed parameter of
        // [FoaasOperation] to shared.operations like your load() function does
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
