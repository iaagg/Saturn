//
//  SaturnStorage.swift
//  Pods
//
//  Created by Alexey Getman on 22/10/2016.
//
//

import UIKit

let kSaturnDataKey = "kSaturnData.com.saturn"

class SaturnStorage: NSObject {
    
    var saturnData: SaturnDataObject {
        return SaturnStorage.getSaturnData()
    }
    
    class func storage() -> SaturnStorage {
        struct Static {
            static var instance: SaturnStorage = SaturnStorage()
        }
        return Static.instance
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
    
    private func saveSaturnData() {
        UserDefaults.standard.set(self.saturnData, forKey: kSaturnDataKey)
    }
    
    func saturnDataChangedFor(saturnData dataObject: SaturnDataObject) {
        if dataObject.isEqual(self.saturnData) {
            self.saveSaturnData()
        }
    }
    
}
