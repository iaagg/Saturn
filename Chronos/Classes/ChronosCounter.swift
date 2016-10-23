//
//  ChronosCounter.swift
//  Pods
//
//  Created by Alexey Getman on 22/10/2016.
//
//

import UIKit

public enum DateCraftingResultType {
    case CraftedDateIsReliable
    case CraftedDateIsUnreliable
    case CraftingReliableDateIsInpossible
}

class ChronosCounter: NSObject {
    
    public class func getCalculatedAtomicTime(result: (Double, DateCraftingResultType) -> ()) {
        
        let chronosData = ChronosStorage.storage().chronosData
        var calculatedAtomicTime: Double = 0
        let currentAtomicTime = ChronosTimeMine.getAtomicTime()
        var resultType: DateCraftingResultType = .CraftedDateIsReliable
        
        switch ChronosJustice.justice().verdict {
            
        case .DeviceRebooted:
            calculatedAtomicTime += chronosData.lastSyncedBootAtomicTime
            calculatedAtomicTime = addUnsyncTime(toTime: calculatedAtomicTime)
            calculatedAtomicTime += currentAtomicTime;
            break
            
        case .DeviceWasNotRebooted:
            
            //If we have any unsynced data -> there were any reboot already in past before syncronization
            //
            //  So all atomic time consits of: |Last synced boot time| + |All saved unsynced boots time exept last| + |Current atomic time since reboot|
            if chronosData.arrayOfUnsyncedBootsAtomicTime.count > 0 {
                calculatedAtomicTime += chronosData.lastSyncedBootAtomicTime
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
        let chronosData = ChronosStorage.storage().chronosData
        
        if chronosData.arrayOfUnsyncedBootsAtomicTime.count > 0 {
            
            for (index, value) in chronosData.arrayOfUnsyncedBootsAtomicTime.enumerated() {
                receivedTime += (value as! NSNumber).doubleValue
            }
        }
        
        return receivedTime
    }
    
    //Adds all saved unsynced boots time (time of working after reboot) exept last
    private class func addUnsyncTimeExeptLast(toTime time: Double) -> Double {
        var receivedTime = time
        let chronosData = ChronosStorage.storage().chronosData
        
        if chronosData.arrayOfUnsyncedBootsAtomicTime.count > 0 {
            let lastUnsyncTimeIndex: NSInteger = chronosData.arrayOfUnsyncedBootsAtomicTime.count - 1
            
            for (index, value) in chronosData.arrayOfUnsyncedBootsAtomicTime.enumerated() {
                
                if index == lastUnsyncTimeIndex {
                    break;
                }
                
                receivedTime += (chronosData.arrayOfUnsyncedBootsAtomicTime[index] as! NSNumber).doubleValue
            }
        }
        
        return time;
    }
    
}