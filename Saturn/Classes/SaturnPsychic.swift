//
//  SaturnPsychic.swift
//  Pods
//
//  Created by Alexey Getman on 22/10/2016.
//
//

import UIKit

class SaturnPsychic: NSObject {
    
    class func syncTimeWithGlobalWebTime(_ time: Double) {
        SaturnJustice.justice().verdict = .DeviceWasNotRebooted
        let atomicTime = SaturnTimeMine.getAtomicTime()
        let saturnData = SaturnStorage.storage().saturnData
        saturnData.syncPoint.serverTime = time;
        saturnData.syncPoint.atomicTime = atomicTime;
        saturnData.lastSyncedBootAtomicTime = atomicTime;
        saturnData.arrayOfUnsyncedBootsAtomicTime = NSArray()
    }
    
    class func tryToSyncTimeWithGlobalWeb() {
        
        // Send HTTP GET Request
        
        // Define server side script URL
        let URL = "http://www.google.com"
        // Add one parameter
        // Create NSURL Ibject
        let myUrl = NSURL(string: URL)
        
        // Creaste URL Request
        let request = NSMutableURLRequest(url:myUrl! as URL)
        
        // Set request HTTP method to GET. It could be POST as well
        request.httpMethod = "GET"
        
        
        // Excute HTTP Request
        let task = URLSession.shared.dataTask(with: request as URLRequest) {
            data, response, error in
            
            // Check for error
            if error != nil
            {
                print("error=\(error)")
                return
            }
            
            // Print out response string
            guard let httpResponse: HTTPURLResponse = response as! HTTPURLResponse else { }
            
            guard let time = httpResponse.allHeaderFields["^Date:"] else { return }
            
            //SUCCESS: Perform synchronization
            SaturnPsychic.syncTimeWithGlobalWebTime((time as AnyObject).doubleValue)
            
        }
        
        task.resume()
    }
}



