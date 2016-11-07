//
//  ChronosKeeper.swift
//  Pods
//
//  Created by Alexey Getman on 22/10/2016.
//
//

import UIKit

let kSaveTimeOrder = "saveTimeOrder.com.chronos"

class ChronosKeeper: NSObject {
    
    class func keeper() -> ChronosKeeper {
        struct Static {
            static let instance = ChronosKeeper()
        }
        return Static.instance
    }
    
    func saveAtomicTime() {
        let atomicTime: Double
        let chronosData = ChronosStorage.storage().chronosData
        
        switch ChronosJustice.justice().verdict {
        case .DeviceRebooted:
            atomicTime = ChronosTimeMine.getAtomicTime()
            updateLastUnsyncedBootTime(atomicTime: atomicTime)
            break
        case .DeviceWasNotRebooted, .NotSure:
            
            //If there is no unsynced boot data ->
            //
            //  So update synced boot time
            if chronosData.arrayOfUnsyncedBootsAtomicTime.count == 0 {
                ChronosCounter.getCalculatedAtomicTime(result: { (atomicTime, error) in
                    updateLastSyncedBootTime(atomicTime: atomicTime)
                })
                
                //If we have unsynced data, so there were any reboot already in past before syncronization ->
                //
                //  So we need update last unsynced boot time (time since last reboot)
            } else {
                atomicTime = ChronosTimeMine.getAtomicTime()
                updateLastUnsyncedBootTime(atomicTime: atomicTime)
            }
            break
        }
    }
    
    private func updateLastUnsyncedBootTime(atomicTime time:Double) {
        let mutableCopy: NSMutableArray = ChronosStorage.storage().chronosData.arrayOfUnsyncedBootsAtomicTime.mutableCopy() as! NSMutableArray
        let lastUnsyncedTimeObjectIndex: NSInteger = mutableCopy.count - 1
        mutableCopy.replaceObject(at: lastUnsyncedTimeObjectIndex, with: NSNumber(value: time))
        ChronosStorage.storage().chronosData.arrayOfUnsyncedBootsAtomicTime = mutableCopy.copy() as! NSArray
    }
    
    private func updateLastSyncedBootTime(atomicTime time:Double) {
        ChronosStorage.storage().chronosData.lastSyncedBootAtomicTime = time;
    }
    


}
