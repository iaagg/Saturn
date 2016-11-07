//
//  SaturnTimeMine.swift
//  Pods
//
//  Created by Alexey Getman on 22/10/2016.
//
//

import UIKit

public class SaturnTimeMine: NSObject {
    
    //Current Atomic time in seconds
    public class func getAtomicTime() -> Double {
        return machTimeToSecs(mach_absolute_time())
    }
    
    //Convertor of atomic time to seconds
    public class func machTimeToSecs(_ time: UInt64) -> Double  {
        var timebase: mach_timebase_info_data_t = mach_timebase_info_data_t(numer: 0, denom: 0)
        mach_timebase_info(&timebase);
        let result = Double(time) * Double(timebase.numer) / Double(timebase.denom) / Double(1e9)
        return result
    }
    
}
