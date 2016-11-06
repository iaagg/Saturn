//
//  ChronosDateSmithy.swift
//  Pods
//
//  Created by Alexey Getman on 22/10/2016.
//
//

import UIKit

class ChronosDateSmithy: NSObject {
    
    static var ownServerProvided : Bool = false
    
    class func craftDate(result: (Date, DateCraftingResultType) -> ()) {
        var date: Date
        let chronosData = ChronosStorage.storage().chronosData
        
        //SYNC DATA AVAILABLE
        if chronosData.syncPoint.serverTime != 0 {
            ChronosCounter.getCalculatedAtomicTime { (time, error) in
                let timePassedSinceLastSync: Double = time - chronosData.syncPoint.atomicTime
                let currentExpectedTime: Double = chronosData.syncPoint.serverTime + timePassedSinceLastSync
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
                ChronosPsychic.tryToSyncTimeWithGlobalWeb()
            }
        }
    }
    
}
