//
//  APIRequestManager.swift
//  Boarding Pass
//
//  Created by Harichandan Singh on 11/22/16.
//  Copyright © 2016 Harichandan Singh. All rights reserved.
//

import Foundation

class FoassAPIManager {
    //MARK: - Properties
    private static let defaultSession = URLSession(configuration: .default)
    
    //MARK: - Methods
    internal class func getFoass(url: URL, completion: @escaping (Foass?) -> Void) {
        var request: URLRequest = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        defaultSession.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
            if error != nil {
                print("Error encountered with URL and data task: \(error)")
            }
            
            do {
                let foassDict = try JSONSerialization.jsonObject(with: data!, options: []) as? [String: AnyObject]
                if let x = foassDict {
                    let foassObject = Foass.init(json: x)
                    completion(foassObject)
                }
            }
            catch {
                print("Encountered an error when casting from JSON: \(error)")
            }
            }.resume()
    }
    
}
