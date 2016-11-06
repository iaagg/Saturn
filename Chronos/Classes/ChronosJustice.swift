//
//  ChronosJustice.swift
//  Pods
//
//  Created by Alexey Getman on 22/10/2016.
//
//

import UIKit

enum Verdicts {
    case DeviceRebooted
    case DeviceWasNotRebooted
    case NotSure
}

class ChronosJustice: NSObject {
    
    var verdict: Verdicts
    
    class func justice() -> ChronosJustice {
        struct Static {
            static let instance = ChronosJustice()
        }
        return Static.instance
    }
    
    override init() {
        self.verdict = .NotSure
    }

    func checkForRebootStatus() {
        var deviceRebooted: Bool = false
        let currentAtomicTime: Double = ChronosTimeMine.getAtomicTime()
        guard let chronosData: ChronosDataObject = ChronosStorage.storage().chronosData else {}
        guard let arrayOfUnsyncedBootsAtomicTime: NSArray = chronosData.arrayOfUnsyncedBootsAtomicTime else { }
        
        //If we have any unsynced boot time (reboot was already before sync) ->
        //
        //  So compare to last unsynced boot time
        if (arrayOfUnsyncedBootsAtomicTime.count > 0) {
            let lastUnsyncedTime: Double = (arrayOfUnsyncedBootsAtomicTime.lastObject as! NSNumber).doubleValue
            deviceRebooted = currentAtomicTime < lastUnsyncedTime;
            let rebootCount: Int = deviceRebooted ? Int((arrayOfUnsyncedBootsAtomicTime.count)+1) : Int((arrayOfUnsyncedBootsAtomicTime.count))
            
        //If we don't have any unsynced (no reboot was earlier) ->
        //
        //  So compare to last synced boot time
        } else {
            let lastAtomicTime: Double = chronosData.lastSyncedBootAtomicTime
            deviceRebooted = currentAtomicTime < lastAtomicTime;
            
            if !deviceRebooted {
                let deviceTime: Double = Date().timeIntervalSince1970
                let lastSavedDeviceTime = chronosData.lastSyncedBootDeviceTime
                let delta = currentAtomicTime - lastAtomicTime
                let expectedDeviceTime = lastSavedDeviceTime + delta
                let differenceBetweenExpectedAndReal = ceil((expectedDeviceTime - deviceTime))
                
                if differenceBetweenExpectedAndReal > 60*5 {
                    self.verdict = .NotSure
                    return
                }
            }
        }
        
        //DEVICE REBOOTED
        if (deviceRebooted) {
            self.verdict = .DeviceRebooted
            
            //Start counting unsynced boot time after reboot
            chronosData.arrayOfUnsyncedBootsAtomicTime = (arrayOfUnsyncedBootsAtomicTime.adding(0) as NSArray?)!
            
        //DEVICE WASN'T REBOOTED
        } else {
            self.verdict = .DeviceWasNotRebooted
        }
    }
    
}
