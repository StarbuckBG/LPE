//
//  DatabaseIntegration+transitions.swift
//  Lumi-iOS
//
//  Created by Martin Kuvandzhiev on 10/5/16.
//  Copyright © 2016 Rapid Development Crew. All rights reserved.
//

import UIKit

extension DatabaseIntegration {

    func getUserPosition() -> Int
    {
        if(DatabaseIntegration.sharedInstance().chart == nil)
        {
            return Int(0)
        }
        
        for index:Int in 0..<DatabaseIntegration.sharedInstance().chart.count
        {
            let anEntry = DatabaseIntegration.sharedInstance().chart[index];
            if(anEntry["user_id"] as? String == DatabaseIntegration.sharedInstance().userdata["id"] as? String)
            {
                return index + 1;
            }
        }
        return 0;
    }
    
    func getHoursOfPlay() -> String?
    {
        if timeOfPlayDictionary != nil
        {
        return String(format:"%02d:%02d:%02d",
                      Int(timeOfPlayDictionary["hours"] as! String)!,
                      Int(timeOfPlayDictionary["minutes"] as! String)!,
                      Int(timeOfPlayDictionary["seconds"] as! String)!)
        }
        return "Loading..."
    }
    
    func getPointsForLastWeek() -> String?
    {
        if weekUserdata != nil
        {
            return weekUserdata["points"] as? String
        }
        
        return "Loading..."
    }
}
