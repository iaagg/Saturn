//
//  SaturnTimeMine.swift
//  Pods
//
//  Created by Alexey Getman on 22/10/2016.
//
//

import UIKit

class SaturnTimeMine: NSObject {
    
    //Current Atomic time in seconds
    class func getAtomicTime() -> Double {
        return machTimeToSecs(mach_absolute_time())
    }
    
    //Convertor of atomic time to seconds
    class func machTimeToSecs(_ time: UInt64) -> Double  {
        var timebase: mach_timebase_info_data_t = mach_timebase_info_data_t()
        mach_timebase_info(&timebase);
        return Double(time) * Double(timebase.numer) / Double(timebase.denom / UInt32(1e9));
    }
    
}
