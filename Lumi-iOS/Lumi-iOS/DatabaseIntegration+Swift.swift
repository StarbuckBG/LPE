//
//  DatabaseIntegration+Swift.swift
//  Lumi-iOS
//
//  Created by Martin Kuvandzhiev on 3/4/17.
//  Copyright © 2017 Rapid Development Crew. All rights reserved.
//

import Foundation


extension DatabaseIntegration{
    
    func loadAppliances(for playgroundId: String, completion: @escaping (Error?, NSDictionary?)->()){
        let sessionConfig = URLSessionConfiguration.default
        
        /* Create session, and optionally set a URLSessionDelegate. */
        let session = URLSession(configuration: sessionConfig, delegate: nil, delegateQueue: nil)
        
        /* Create the Request:
         Get Appliances (GET http://rapiddevcrew.com/lumi_v2/getAppliances/)
         */
        
        guard let URL = URL(string: "https://rapiddevcrew.com/lumi_v2/getAppliances/") else {return}
        var request = URLRequest(url: URL)
        request.httpMethod = "GET"
        
        // Headers
        
        request.addValue("{\"playground_id\":\"\(playgroundId)\"}", forHTTPHeaderField: "Data")
        
        /* Start a new Task */
        let task = session.dataTask(with: request, completionHandler: { (data: Data?, response: URLResponse?, error: Error?) -> Void in
            if (error == nil) {
                // Success
//                let statusCode = (response as! HTTPURLResponse).statusCode
                guard data != nil else {return}
                do {
                    let responceData = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSArray
                    let dataDictionary = responceData.firstObject as! NSDictionary
                    
                    completion(nil, dataDictionary)
                }
                catch {
                    
                }
                
            }
            completion(error, nil)
        })
        task.resume()
        session.finishTasksAndInvalidate()
    }

}
