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
            let anEntry = DatabaseIntegration.sharedInstance().chart[index] as! [String:Any];
            if((anEntry["user_id"] as! String) == DatabaseIntegration.sharedInstance().userdata["id"] as! String)
            {
                return index + 1;
            }
        }
        return 0;
    }
    
    func getHoursOfPlay() -> String?
    {
        if (timeOfPlayDictionary != nil && timeOfPlayDictionary["hours"] != nil  && timeOfPlayDictionary["minutes"] != nil && timeOfPlayDictionary["seconds"] != nil)
        {
            if let hours = timeOfPlayDictionary["hours"] as? String, let minutes = timeOfPlayDictionary["minutes"] as? String, let seconds = timeOfPlayDictionary["seconds"] as? String
            {
        return String(format:"%02d:%02d:%02d",
                      Int(hours)!,
                      Int(minutes)!,
                      Int(seconds)!)
            }
            else
            {
                return "00:00:00"
            }
        }
        return "Loading..."
    }
    
    func getPointsForLastWeek() -> String?
    {
        if weekUserdata != nil
        {
            if let points = weekUserdata["points"] as? String
            {
                return points 
            }
           return "0"
            
        }
        
        return "Loading..."
    }
}
