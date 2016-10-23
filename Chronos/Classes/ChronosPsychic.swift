//
//  ChronosPsychic.swift
//  Pods
//
//  Created by Alexey Getman on 22/10/2016.
//
//

import UIKit

class ChronosPsychic: NSObject {
    
    class func syncTimeWithGlobalWebTime(_ time: Double) {
        ChronosJustice.justice().verdict = .DeviceWasNotRebooted
        let atomicTime = ChronosTimeMine.getAtomicTime()
        let chronosData = ChronosStorage.storage().chronosData
        chronosData.syncPoint.serverTime = time;
        chronosData.syncPoint.atomicTime = atomicTime;
        chronosData.lastSyncedBootAtomicTime = atomicTime;
        chronosData.arrayOfUnsyncedBootsAtomicTime = NSArray()
        ChronosStorage.saveChronosData(chronosData)
    }
    
    class func tryToSyncTimeWithGlobalWeb() {
        
        // Send HTTP GET Request
        
        // Define server side script URL
        let URL = "http://www.timeapi.org/utc/now"
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
                
                if let httpResponse: HTTPURLResponse = response as! HTTPURLResponse {
                    let headers = httpResponse.allHeaderFields
                    let dateString: String = headers["Date"] as! String
                    var formatter = DateFormatter()
                    formatter.dateFormat = "EEE',' dd MMM yyyy HH:mm:ss z"
                    let date = formatter.date(from: dateString)
                    if let time: TimeInterval = date?.timeIntervalSince1970 {
                        
                        DispatchQueue.main.async {
                            //SUCCESS: Perform synchronization
                            ChronosPsychic.syncTimeWithGlobalWebTime(time)
                        }
                    }
                }
            }
            
            task.resume()
        }
        }
}



