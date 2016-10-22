//
//  SaturnDataObject.swift
//  Pods
//
//  Created by Alexey Getman on 22/10/2016.
//
//

import UIKit

class SaturnDataObject: NSObject, NSCoding {
    
    var arrayOfUnsyncedBootsAtomicTime: NSArray {
        didSet {
            SaturnStorage.storage().saturnDataChangedFor(saturnData: self)
        }
    }
    
    var lastSyncedBootAtomicTime: Double {
        didSet {
            SaturnStorage.storage().saturnDataChangedFor(saturnData: self)
        }
    }

    var lastSyncedBootDeviceTime: Double {
        didSet {
            SaturnStorage.storage().saturnDataChangedFor(saturnData: self)
        }
    }

    var syncPoint: SaturnSyncronization {
        didSet {
            SaturnStorage.storage().saturnDataChangedFor(saturnData: self)
        }
    }
    
    override init() {
        self.arrayOfUnsyncedBootsAtomicTime = NSArray()
        self.lastSyncedBootAtomicTime = 0
        self.lastSyncedBootDeviceTime = 0
        self.syncPoint = SaturnSyncronization()
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
        self.syncPoint = aDecoder.decodeObject(forKey: "syncPoint") as! SaturnSyncronization
    }
    
    override func isEqual(_ object: Any?) -> Bool {
        if object is SaturnDataObject {
            var saturnObject = object as! SaturnDataObject
            
            let hashOne = ObjectIdentifier(self).hashValue
            let hashTwo = ObjectIdentifier(saturnObject).hashValue
            
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
