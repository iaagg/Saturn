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
        return extractKernelTime()
    }
    
}
