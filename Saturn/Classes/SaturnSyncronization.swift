//
//  SaturnSyncronization.swift
//  Pods
//
//  Created by Alexey Getman on 22/10/2016.
//
//

import UIKit

class SaturnSyncronization: NSObject, NSCoding {
    
    weak var weakSaturnData: SaturnDataObject?

    var atomicTime: Double  {
        didSet {
            SaturnStorage.storage().saturnDataChangedFor(saturnData: weakSaturnData!)
        }
    }

    var serverTime: Double {
        didSet {
            SaturnStorage.storage().saturnDataChangedFor(saturnData: weakSaturnData!)
        }
    }
    
    override init() {
        self.atomicTime = 0
        self.serverTime = 0
    }

    
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(atomicTime, forKey: "atomicTime")
        aCoder.encode(serverTime, forKey: "serverTime")
    }
    
    public required init?(coder aDecoder: NSCoder) {
        self.atomicTime = aDecoder.decodeDouble(forKey: "atomicTime")
        self.serverTime = aDecoder.decodeDouble(forKey: "serverTime")
    }
    
}
