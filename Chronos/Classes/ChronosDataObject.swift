//
//  ChronosDataObject.swift
//  Pods
//
//  Created by Alexey Getman on 22/10/2016.
//
//

import UIKit

struct ChronosSyncPoint {
    var atomicTime: Double
    var serverTime: Double
    weak var weakChronosData: ChronosDataObject?
}

public class ChronosDataObject: NSObject, NSCoding {
    
    var arrayOfUnsyncedBootsAtomicTime: NSArray
    
    var lastSyncedBootAtomicTime: Double

    var lastSyncedBootDeviceTime: Double

    var syncPoint: ChronosSyncPoint
    
    override init() {
        self.arrayOfUnsyncedBootsAtomicTime = NSArray()
        self.lastSyncedBootAtomicTime = 0
        self.lastSyncedBootDeviceTime = 0
        self.syncPoint = ChronosSyncPoint(atomicTime: 0, serverTime: 0, weakChronosData: nil)
    }

    
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(arrayOfUnsyncedBootsAtomicTime, forKey: "arrayOfUnsyncedBootsAtomicTime")
        aCoder.encode(lastSyncedBootAtomicTime, forKey: "lastSyncedBootAtomicTime")
        aCoder.encode(lastSyncedBootDeviceTime, forKey: "lastSyncedBootDeviceTime")
        aCoder.encode(syncPoint, forKey: "syncPoint")
    }
    
    public required init?(coder aDecoder: NSCoder) {
        self.arrayOfUnsyncedBootsAtomicTime = aDecoder.decodeObject(forKey: "arrayOfUnsyncedBootsAtomicTime") as! NSArray
        self.lastSyncedBootAtomicTime = aDecoder.decodeDouble(forKey: "lastSyncedBootAtomicTime")
        self.lastSyncedBootDeviceTime = aDecoder.decodeDouble(forKey: "lastSyncedBootDeviceTime")
        self.syncPoint = aDecoder.decodeObject(forKey: "syncPoint") as! ChronosSyncPoint
    }
    
    override public func isEqual(_ object: Any?) -> Bool {
        if object is ChronosDataObject {
            var chronosObject = object as! ChronosDataObject
            
            let hashOne = ObjectIdentifier(self).hashValue
            let hashTwo = ObjectIdentifier(chronosObject).hashValue
            
            if hashOne == hashTwo {
                return true
            } else {
                return false
            }
        } else {
            return false
        }
    }
    
}
