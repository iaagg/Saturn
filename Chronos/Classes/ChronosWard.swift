//
//  ChronosWard.swift
//  Pods
//
//  Created by Alexey Getman on 22/10/2016.
//
//

import UIKit

class ChronosWard: NSObject {
    
    var saveNotificationPushTimer: Timer?
    var saveTimerPeriod: Double = 60*2.5 //Every 2.5 minutes for default

    class func ward() -> ChronosWard {
        struct Static {
            static let instance = ChronosWard()
        }
        
        return Static.instance
    }
    
    func startSavingSchedule(withInterval interval: Double?) {
        if let unwrappedInterval = interval {
            saveTimerPeriod = unwrappedInterval
        }
        
        if let timer = self.saveNotificationPushTimer {
            timer.invalidate()
        }
        
        self.saveNotificationPushTimer = Timer.scheduledTimer(timeInterval: saveTimerPeriod, target: ChronosKeeper.keeper(), selector: #selector(ChronosKeeper.saveAtomicTime), userInfo: nil, repeats: true)
    }
    
    deinit {
        if let timer = self.saveNotificationPushTimer {
            timer.invalidate()
        }
    }
    
}
