//
//  SaturnPsychic.swift
//  Pods
//
//  Created by Alexey Getman on 22/10/2016.
//
//

import UIKit

class SaturnPsychic: NSObject {
    
    class func saveSyncPoint(_ time: Double) {
        syncTimeWithGlobalWebTime(time)
    }
    
    class func syncTimeWithGlobalWebTime(_ time: Double) {
        SaturnJustice.justice().verdict = .DeviceWasNotRebooted
        let atomicTime = SaturnTimeMine.getAtomicTime()
        let saturnData = SaturnStorage.storage().saturnData
        saturnData.syncPoint.serverTime = time;
        saturnData.syncPoint.atomicTime = atomicTime;
        saturnData.lastSyncedBootAtomicTime = atomicTime;
        saturnData.arrayOfUnsyncedBootsAtomicTime = NSArray()
        SaturnStorage.saveSaturnData(saturnData)
    }
    
    class func tryToSyncTimeWithGlobalWeb() {
        
        // Send HTTP GET Request
        
        // Define server side script URL
        let URL = "http://api.geonames.org/timezoneJSON?formatted=true&lat=47.01&lng=10.2&username=demo&style=full"
        // Add one parameter
        // Create NSURL Ibject
        let myUrl = NSURL(string: URL)
        
        // Creaste URL Request
        let request = NSMutableURLRequest(url:myUrl! as URL)
        
        // Set request HTTP method to GET. It could be POST as well
        request.httpMethod = "GET"
                
        DispatchQueue.global(qos: .background).async {
            // Excute HTTP Request
            let task = URLSession.shared.dataTask(with: request as URLRequest) {
                data, response, error in
                
                // Check for error
                if error != nil
                {
                    print("error=\(error)")
                    return
                }
                
                if let httpResponse: HTTPURLResponse = response as? HTTPURLResponse {
                    let headers = httpResponse.allHeaderFields
                    let dateString: String = headers["Date"] as! String
                    let formatter = DateFormatter()
                    formatter.dateFormat = "EEE',' dd MMM yyyy HH:mm:ss z"
                    formatter.locale = Locale(identifier: "en_US")
                    let date = formatter.date(from: dateString)
                    if let time: TimeInterval = date?.timeIntervalSince1970 {
                        
                        DispatchQueue.main.async {
                            //SUCCESS: Perform synchronization
                            SaturnPsychic.syncTimeWithGlobalWebTime(time)
                        }
                    }
                }
            }
            
            task.resume()
        }
        }
}



