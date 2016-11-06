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

extension ChronosSyncPoint {
    init(data: Data) {
        let decodedData = NSKeyedUnarchiver.unarchiveObject(with: data) as! EncodedSyncPoint
        atomicTime = decodedData.atomicTime
        serverTime = decodedData.serverTime
    }
    
    func asData() -> Data {
        return NSKeyedArchiver.archivedData(withRootObject: EncodedSyncPoint(self))
    }
}

class EncodedSyncPoint: NSObject, NSCoding {
    
    let atomicTime: Double
    let serverTime: Double
    
    init(_ syncPointStruct: ChronosSyncPoint) {
        atomicTime = syncPointStruct.atomicTime
        serverTime = syncPointStruct.serverTime
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(atomicTime, forKey: "atomicTime")
        aCoder.encode(serverTime, forKey: "serverTime")
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.atomicTime = aDecoder.decodeDouble(forKey: "atomicTime")
        self.serverTime = aDecoder.decodeDouble(forKey: "serverTime")
    }
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
        aCoder.encode(syncPoint.asData(), forKey: "syncPoint")
    }
    
    public required init?(coder aDecoder: NSCoder) {
        self.arrayOfUnsyncedBootsAtomicTime = aDecoder.decodeObject(forKey: "arrayOfUnsyncedBootsAtomicTime") as! NSArray
        self.lastSyncedBootAtomicTime = aDecoder.decodeDouble(forKey: "lastSyncedBootAtomicTime")
        self.lastSyncedBootDeviceTime = aDecoder.decodeDouble(forKey: "lastSyncedBootDeviceTime")
        self.syncPoint = ChronosSyncPoint(data: aDecoder.decodeObject(forKey: "syncPoint") as! Data)
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
