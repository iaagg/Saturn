//
//  ChronosStorage.swift
//  Pods
//
//  Created by Alexey Getman on 22/10/2016.
//
//

import UIKit

let kChronosDataKey = "kChronosData.com.chronos"

public class ChronosStorage: NSObject {
    
    var chronosData: ChronosDataObject
    
    public class func storage() -> ChronosStorage {
        struct Static {
            static var instance: ChronosStorage = ChronosStorage()
        }
        return Static.instance
    }
    
    override init() {
        self.chronosData = ChronosStorage.getChronosData()
    }
 
    private class func getChronosData() -> ChronosDataObject {
        
        var chronosDataObject: ChronosDataObject
        
        if let fetchedData = UserDefaults.standard.value(forKey: kChronosDataKey) {
            chronosDataObject = NSKeyedUnarchiver.unarchiveObject(with: fetchedData as! Data) as! ChronosDataObject
        } else {
            chronosDataObject = ChronosDataObject()
        }
        
        chronosDataObject.syncPoint.weakChronosData = chronosDataObject
        
        return chronosDataObject
    }
    
    public class func saveChronosData(_ chronosData: ChronosDataObject) {
        if chronosData.isEqual(ChronosStorage.storage().chronosData) {
            let archivedChronosData = NSKeyedArchiver.archivedData(withRootObject: ChronosStorage.storage().chronosData)
            UserDefaults.standard.set(archivedChronosData, forKey: kChronosDataKey)
            ChronosStorage.storage().chronosData = ChronosStorage.getChronosData()
        }
    }
    
}
