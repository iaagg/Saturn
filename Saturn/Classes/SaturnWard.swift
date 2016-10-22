//
//  SaturnWard.swift
//  Pods
//
//  Created by Alexey Getman on 22/10/2016.
//
//

import UIKit

class SaturnWard: NSObject {
    
    var saveNotificationPushTimer: Timer?
    var timerPeriod: Double = 60*5 //Every 5 minutes for default

    class func ward() -> SaturnWard {
        struct Static {
            static let instance = SaturnWard()
        }
        
        return Static.instance
    }
    
    func startSavingSchedule() {
        self.saveNotificationPushTimer = Timer.scheduledTimer(timeInterval: timerPeriod, target: SaturnKeeper.keeper(), selector: #selector(SaturnKeeper.saveAtomicTime), userInfo: nil, repeats: true)
    }
    
    deinit {
        if let timer = self.saveNotificationPushTimer {
            timer.invalidate()
        }
    }
    
}
