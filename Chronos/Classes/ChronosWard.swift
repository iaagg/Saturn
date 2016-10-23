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
    var timerPeriod: Double = 60*5 //Every 5 minutes for default

    class func ward() -> ChronosWard {
        struct Static {
            static let instance = ChronosWard()
        }
        
        return Static.instance
    }
    
    func startSavingSchedule() {
        self.saveNotificationPushTimer = Timer.scheduledTimer(timeInterval: timerPeriod, target: ChronosKeeper.keeper(), selector: #selector(ChronosKeeper.saveAtomicTime), userInfo: nil, repeats: true)
    }
    
    deinit {
        if let timer = self.saveNotificationPushTimer {
            timer.invalidate()
        }
    }
    
}
