//
//  SaturnDateSmithy.swift
//  Pods
//
//  Created by Alexey Getman on 22/10/2016.
//
//

import UIKit

class SaturnDateSmithy: NSObject {

    class func craftDate(result: (Date, DateCraftingResultType) -> ()) {
        let saturnData = SaturnStorage.storage().saturnData
        SaturnCounter.getCalculatedAtomicTime { (time, error) in
            let timePassedSinceLastSync: Double = time - saturnData.syncPoint.atomicTime
            let currentExpectedTime: Double = saturnData.syncPoint.serverTime + timePassedSinceLastSync
            let date: Date = Date(timeIntervalSince1970: currentExpectedTime)
            result(date, error)
        }
    }
    
}
