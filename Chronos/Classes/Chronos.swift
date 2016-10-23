//
//  Chronos.swift
//  Pods
//
//  Created by Alexey Getman on 22/10/2016.
//
//

import UIKit

public class Chronos: NSObject {

    public class func protect() {
    
    //FETCHING SAVED TIME
    let cronosData: ChronosDataObject = ChronosStorage.storage().chronosData
        
        ChronosJustice.justice().checkForRebootStatus()
        
        //OBSERVING
        NotificationCenter.default.addObserver(ChronosKeeper.keeper(), selector: #selector(ChronosKeeper.saveAtomicTime), name: NSNotification.Name(rawValue: kSaveTimeOrder), object: nil)
    }
    
    public class func date(hereYouAre: (Date, DateCraftingResultType) -> ()) {
        var date: Date
        let chronosData = ChronosStorage.storage().chronosData
        
        //SYNC DATA AVAILABLE
        if chronosData.syncPoint.serverTime != 0 {
            ChronosDateSmithy.craftDate {(date, resultType) in
                hereYouAre(date, resultType)
            }
            
        //NO SYNC DATA YET
        } else {
            
            //Can't get calculated time -> return users's device time
            date = Date()
            let resultType: DateCraftingResultType = .CraftingReliableDateIsInpossible
            hereYouAre(date, resultType)
            ChronosPsychic.tryToSyncTimeWithGlobalWeb()
        }
    }
    
}
