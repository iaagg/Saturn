//
//  SaturnDateSmithy.swift
//  Pods
//
//  Created by Alexey Getman on 22/10/2016.
//
//

import UIKit

class SaturnDateSmithy: NSObject {
    
    static var ownServerProvided : Bool = false
    
    class func craftDate(result: (Date, DateCraftingResultType) -> ()) {
        var date: Date
        let saturnData = SaturnStorage.storage().saturnData
        
        //SYNC DATA AVAILABLE
        if saturnData.syncPoint.serverTime != 0 {
            SaturnCounter.getCalculatedAtomicTime { (time, error) in
                let timePassedSinceLastSync: Double = time - saturnData.syncPoint.atomicTime
                let currentExpectedTime: Double = saturnData.syncPoint.serverTime + timePassedSinceLastSync
                let date: Date = Date(timeIntervalSince1970: currentExpectedTime)
                result(date, error)
            }
            
        //NO SYNC DATA YET
        } else {
            
            //Can't get calculated time -> return users's device time
            date = Date()
            let resultType: DateCraftingResultType = .CraftingReliableDateIsImpossible
            result(date, resultType)
            
            if !ownServerProvided {
                SaturnPsychic.tryToSyncTimeWithGlobalWeb()
            }
        }
    }
    
}
