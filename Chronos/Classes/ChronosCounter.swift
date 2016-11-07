//
//  ChronosCounter.swift
//  Pods
//
//  Created by Alexey Getman on 22/10/2016.
//
//

import UIKit

public enum DateCraftingResultType {
    
    //In this case Chronos has calculated time properly and you can rely on it.
    case CraftedDateIsReliable
    
    //In this case Chronos tried to calculate time properly, but there is a chance that it is not accurate.
    case CraftedDateIsUnreliable
    
    //In this case Chronos can't count time properly due to some reasons. You should try to make a sync point to make time counting possible.
    case CraftingReliableDateIsImpossible
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
        }
        
        result(calculatedAtomicTime, resultType)
    }
    
    //Adds all saved unsynced boots time (time of working after reboot)
    private class func addUnsyncTime(toTime time:Double) -> Double {
        var receivedTime = time
        let chronosData = ChronosStorage.storage().chronosData
        
        if chronosData.arrayOfUnsyncedBootsAtomicTime.count > 0 {
            
            for (_, value) in chronosData.arrayOfUnsyncedBootsAtomicTime.enumerated() {
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
            
            for (index, _) in chronosData.arrayOfUnsyncedBootsAtomicTime.enumerated() {
                
                if index == lastUnsyncTimeIndex {
                    break;
                }
                
                receivedTime += (chronosData.arrayOfUnsyncedBootsAtomicTime[index] as! NSNumber).doubleValue
            }
        }
        
        return time;
    }
    
}
