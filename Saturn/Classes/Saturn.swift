//
//  Saturn.swift
//  Pods
//
//  Created by Alexey Getman on 22/10/2016.
//
//

import UIKit

class Saturn: NSObject {

    public class func protect() {
    
    //FETCHING SAVED TIME
    let cronosData: SaturnDataObject = SaturnStorage.storage().saturnData
        
        SaturnJustice.justice().checkForRebootStatus()
        
        //OBSERVING
        NotificationCenter.default.addObserver(SaturnKeeper.keeper(), selector: #selector(SaturnKeeper.saveAtomicTime), name: NSNotification.Name(rawValue: kSaveTimeOrder), object: nil)
    }
    
    class func date(hereYouAre: (Date, DateCraftingResultType) -> ()) {
        var date: Date
        let saturnData = SaturnStorage.storage().saturnData
        
        //SYNC DATA AVAILABLE
        if saturnData.syncPoint.serverTime != 0 {
            SaturnDateSmithy.craftDate {(date, resultType) in
                hereYouAre(date, resultType)
            }
            
        //NO SYNC DATA YET
        } else {
            
            //Can't get calculated time -> return users's device time
            date = Date()
            let resultType: DateCraftingResultType = .CraftingReliableDateIsInpossible
            hereYouAre(date, resultType)
            SaturnPsychic.tryToSyncTimeWithGlobalWeb()
        }
    }
    
}
