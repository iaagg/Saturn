//
//  ChronosDateSmithy.swift
//  Pods
//
//  Created by Alexey Getman on 22/10/2016.
//
//

import UIKit

class ChronosDateSmithy: NSObject {
    
    class func craftDate(result: (Date, DateCraftingResultType) -> ()) {
        let chronosData = ChronosStorage.storage().chronosData
        ChronosCounter.getCalculatedAtomicTime { (time, error) in
            let timePassedSinceLastSync: Double = time - chronosData.syncPoint.atomicTime
            let currentExpectedTime: Double = chronosData.syncPoint.serverTime + timePassedSinceLastSync
            let date: Date = Date(timeIntervalSince1970: currentExpectedTime)
            result(date, error)
        }
    }
    
}
