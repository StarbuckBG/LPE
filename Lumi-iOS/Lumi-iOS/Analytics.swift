//
//  Analytics.swift
//  Lumi-iOS
//
//  Created by Martin Kuvandzhiev on 3/14/17.
//  Copyright © 2017 Rapid Development Crew. All rights reserved.
//

import Foundation
import Firebase

class Analytics: NSObject{
    class func logAnalyticsEvent(_ event: String, arguments:[String:String]?){
        FIRAnalytics.logEvent(withName: event, parameters: arguments as [String : NSObject]?)
    }
}



extension Analytics { // Home screen
    class func homeScreenOpened(){
        self.logAnalyticsEvent("HomeScreenOpened", arguments: nil)
    }
    
    class func shareBalloonTapped(){
        self.logAnalyticsEvent("BalloonShareTapped", arguments: nil)
    }
    
    class func pointsBalloonTapped(){
        self.logAnalyticsEvent("BalloonPointsTapped", arguments: nil)
    }
    
    class func mapBalloonTapped(){
        self.logAnalyticsEvent("BalloonMapTapped", arguments: nil)
    }
    
    class func connectBalloonTapped(){
        self.logAnalyticsEvent("BalloonConnectTapped", arguments: nil)
    }
    
    class func exchangeBalloonTapped(){
        self.logAnalyticsEvent("BalloonExchangeTapped", arguments: nil)
    }
}


extension Analytics { // exchange
    class func exchangeScreenOpened(){
        self.logAnalyticsEvent("ExchangeScreenOpened", arguments: nil)
    }
    
    class func pointsExchanged(points: String, destination: String){
        self.logAnalyticsEvent("ExchangePointsExchanged", arguments: ["points":"\(points)", "companyId":destination])
    }
    
    class func exchangeDestinationSelected(destination: String){
        self.logAnalyticsEvent("ExchangeDestinationSelected", arguments: ["destination":destination])
    }
}

extension Analytics { // map
    class func mapScreenOpened(){
        self.logAnalyticsEvent("MapScreenOpened", arguments: nil)
    }
    
    class func playgroundInfoSelected(playgroundName: String){
        self.logAnalyticsEvent("MapPlaygroundInfoSelected", arguments: ["playgroundName":playgroundName])
    }
}


extension Analytics{ // logIn
    class func logInScreenOpened(){
        self.logAnalyticsEvent("LogInScreenOpened", arguments: nil)
    }
    
    class func registerButtonTapped(){
        self.logAnalyticsEvent("RegisterButtonTapped", arguments: nil)
    }
    
    class func forgottenPasswordTapped(){
        self.logAnalyticsEvent("ForgottenPasswordTapped", arguments: nil)
    }
}


extension Analytics{ // register
    class func registerScreenOpened(){
        self.logAnalyticsEvent("RegisterScreenOpened", arguments: nil)
    }
    
    class func registerActionInitiated(){
        self.logAnalyticsEvent("RegisterInitiationTapped", arguments: nil)
    }
}


extension Analytics{ // profile
    class func profileScreenOpened(){
        self.logAnalyticsEvent("ProfileScreenOpened", arguments: nil)
    }
    
    class func logScreenOpened(){
        self.logAnalyticsEvent("LogScreenOpened", arguments: nil)
    }
}

extension Analytics{ // information screen
    class func infoScreenOpened(){
        self.logAnalyticsEvent("InfoScreenOpened", arguments: nil)
    }
}

extension Analytics{ // terms and conditions
    class func termsAndConditionsOpened(){
        self.logAnalyticsEvent("TermsAndConditionsScreenOpened", arguments: nil)
    }
}

extension Analytics{ // connect
    class func connectScreenOpened(){
        self.logAnalyticsEvent("ConnectScreenOpened", arguments: nil)
    }
    
    class func qrCodeScanned(code: String){
        self.logAnalyticsEvent("ConnectQRCodeScanned", arguments: ["code":code])
    }
    
    class func deviceConnected(deviceName: String){
        self.logAnalyticsEvent("ConnectDeviceConnected", arguments: ["playgroundName":deviceName])
    }
    
    class func deviceDisconnected(deviceName: String, points: Float, secondsOfPlay: Int){
        self.logAnalyticsEvent("ConnectDeviceDisconnected", arguments: ["deviceName":deviceName, "points":"\(points)", "secondsOfPlay":"\(secondsOfPlay)"])
    }
}









