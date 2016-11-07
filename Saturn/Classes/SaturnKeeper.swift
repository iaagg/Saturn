//
//  SaturnKeeper.swift
//  Pods
//
//  Created by Alexey Getman on 22/10/2016.
//
//

import UIKit

let kSaveTimeOrder = "saveTimeOrder.com.saturn"

class SaturnKeeper: NSObject {
    
    class func keeper() -> SaturnKeeper {
        struct Static {
            static let instance = SaturnKeeper()
        }
        return Static.instance
    }
    
    func saveAtomicTime() {
        let atomicTime: Double
        let saturnData = SaturnStorage.storage().saturnData
        
        switch SaturnJustice.justice().verdict {
        case .DeviceRebooted:
            atomicTime = SaturnTimeMine.getAtomicTime()
            updateLastUnsyncedBootTime(atomicTime: atomicTime)
            break
        case .DeviceWasNotRebooted, .NotSure:
            
            //If there is no unsynced boot data ->
            //
            //  So update synced boot time
            if saturnData.arrayOfUnsyncedBootsAtomicTime.count == 0 {
                SaturnCounter.getCalculatedAtomicTime(result: { (atomicTime, error) in
                    updateLastSyncedBootTime(atomicTime: atomicTime)
                })
                
                //If we have unsynced data, so there were any reboot already in past before syncronization ->
                //
                //  So we need update last unsynced boot time (time since last reboot)
            } else {
                atomicTime = SaturnTimeMine.getAtomicTime()
                updateLastUnsyncedBootTime(atomicTime: atomicTime)
            }
            break
        }
    }
    
    private func updateLastUnsyncedBootTime(atomicTime time:Double) {
        let mutableCopy: NSMutableArray = SaturnStorage.storage().saturnData.arrayOfUnsyncedBootsAtomicTime.mutableCopy() as! NSMutableArray
        let lastUnsyncedTimeObjectIndex: NSInteger = mutableCopy.count - 1
        mutableCopy.replaceObject(at: lastUnsyncedTimeObjectIndex, with: NSNumber(value: time))
        SaturnStorage.storage().saturnData.arrayOfUnsyncedBootsAtomicTime = mutableCopy.copy() as! NSArray
    }
    
    private func updateLastSyncedBootTime(atomicTime time:Double) {
        SaturnStorage.storage().saturnData.lastSyncedBootAtomicTime = time;
    }
    


}
