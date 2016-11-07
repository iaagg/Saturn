//
//  SaturnStorage.swift
//  Pods
//
//  Created by Alexey Getman on 22/10/2016.
//
//

import UIKit

let kSaturnDataKey = "kSaturnData.com.saturn"

public class SaturnStorage: NSObject {
    
    var saturnData: SaturnDataObject
    
    public class func storage() -> SaturnStorage {
        struct Static {
            static var instance: SaturnStorage = SaturnStorage()
        }
        return Static.instance
    }
    
    override init() {
        self.saturnData = SaturnStorage.getSaturnData()
    }
 
    private class func getSaturnData() -> SaturnDataObject {
        
        var saturnDataObject: SaturnDataObject
        
        if let fetchedData = UserDefaults.standard.value(forKey: kSaturnDataKey) {
            saturnDataObject = NSKeyedUnarchiver.unarchiveObject(with: fetchedData as! Data) as! SaturnDataObject
        } else {
            saturnDataObject = SaturnDataObject()
        }
        
        saturnDataObject.syncPoint.weakSaturnData = saturnDataObject
        
        return saturnDataObject
    }
    
    public class func saveSaturnData(_ saturnData: SaturnDataObject) {
        if saturnData.isEqual(SaturnStorage.storage().saturnData) {
            let archivedSaturnData = NSKeyedArchiver.archivedData(withRootObject: SaturnStorage.storage().saturnData)
            UserDefaults.standard.set(archivedSaturnData, forKey: kSaturnDataKey)
            SaturnStorage.storage().saturnData = SaturnStorage.getSaturnData()
        }
    }
    
}
