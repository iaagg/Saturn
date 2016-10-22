//
//  SaturnCounter.swift
//  Pods
//
//  Created by Alexey Getman on 22/10/2016.
//
//

import UIKit

enum DateCraftingResultType {
    case CraftedDateIsReliable
    case CraftedDateIsUnreliable
    case CraftingReliableDateIsInpossible
}

class SaturnCounter: NSObject {
    
    class func getCalculatedAtomicTime(result: (Double, DateCraftingResultType) -> ()) {

        let saturnData = SaturnStorage.storage().saturnData
        var calculatedAtomicTime: Double = 0
        let currentAtomicTime = SaturnTimeMine.getAtomicTime()
        var resultType: DateCraftingResultType = .CraftedDateIsReliable
        
        switch SaturnJustice.justice().verdict {
            
        case .DeviceRebooted:
            calculatedAtomicTime += saturnData.lastSyncedBootAtomicTime
            calculatedAtomicTime = addUnsyncTime(toTime: calculatedAtomicTime)
            calculatedAtomicTime += currentAtomicTime;
            break
            
        case .DeviceWasNotRebooted:
            
            //If we have any unsynced data -> there were any reboot already in past before syncronization
            //
            //  So all atomic time consits of: |Last synced boot time| + |All saved unsynced boots time exept last| + |Current atomic time since reboot|
            if saturnData.arrayOfUnsyncedBootsAtomicTime.count > 0 {
                calculatedAtomicTime += saturnData.lastSyncedBootAtomicTime
                calculatedAtomicTime = addUnsyncTimeExeptLast(toTime: calculatedAtomicTime)
                calculatedAtomicTime += currentAtomicTime;
                
                //We don't have any unsynced data ->
                //
                //  So |Current atomic time since reboot| is actual
            } else {
                calculatedAtomicTime = currentAtomicTime
            }
            break
        case .NotSure:
            calculatedAtomicTime = currentAtomicTime
            resultType = .CraftedDateIsUnreliable
            break
        default: break
        }
        
        result(calculatedAtomicTime, resultType)
    }
    
    //Adds all saved unsynced boots time (time of working after reboot)
    private class func addUnsyncTime(toTime time:Double) -> Double {
        var receivedTime = time
        let saturnData = SaturnStorage.storage().saturnData
        
        if saturnData.arrayOfUnsyncedBootsAtomicTime.count > 0 {
            
            for (index, value) in saturnData.arrayOfUnsyncedBootsAtomicTime.enumerated() {
                receivedTime += (value as! NSNumber).doubleValue
            }
        }
        
        return receivedTime
    }
    
    //Adds all saved unsynced boots time (time of working after reboot) exept last
    private class func addUnsyncTimeExeptLast(toTime time: Double) -> Double {
        var receivedTime = time
        let saturnData = SaturnStorage.storage().saturnData
        
        if saturnData.arrayOfUnsyncedBootsAtomicTime.count > 0 {
            let lastUnsyncTimeIndex: NSInteger = saturnData.arrayOfUnsyncedBootsAtomicTime.count - 1
            
            for (index, value) in saturnData.arrayOfUnsyncedBootsAtomicTime.enumerated() {
                
                if index == lastUnsyncTimeIndex {
                    break;
                }
                
                receivedTime += (saturnData.arrayOfUnsyncedBootsAtomicTime[index] as! NSNumber).doubleValue
            }
        }
        
        return time;
    }
    
}
