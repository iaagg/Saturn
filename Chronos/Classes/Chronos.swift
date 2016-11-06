//
//  Chronos.swift
//  Pods
//
//  Created by Alexey Getman on 22/10/2016.
//
//

import UIKit

public class Chronos: NSObject {
    
    /*!
     * @discussion Call this method in the very beginning of your app's work, apllicationDidFinishLaunchingWithOptions in AppDelegate will be perfect place for it.
     * @param ownServerProvided It you will sync Chronos with your server by calling "syncWith" method -> pass true. If you want Chronos to sync with default server -> pass false.
     * @warning Before calling this method, chronos can't properly count time for you
     */
    public class func protect(ownServerProvided providedFlag: Bool) {
        let cronosData: ChronosDataObject = ChronosStorage.storage().chronosData
        ChronosJustice.justice().checkForRebootStatus()
        ChronosWard.ward().startSavingSchedule(withInterval: nil)
        ChronosKeeper.keeper().saveAtomicTime()
        
        if providedFlag {
            ChronosDateSmithy.ownServerProvided = true
        } else {
            ChronosPsychic.tryToSyncTimeWithGlobalWeb()
        }
    }
    
    /*!
     * @discussion Call method to make Chronos to count real time for you
     * @param hereYouAre implement this clusure with available date and result type in it. Follow the DateCraftingResultType enum doc for more info.
     * @warning It is no recommended to use date, which was made with result type "CraftedDateIsUnreliable"
     * @return crafted date and result type, which tells you additional info about created date
     */
    public class func date(hereYouAre: (Date, DateCraftingResultType) -> ()) {
            ChronosDateSmithy.craftDate {(date, resultType) in
                hereYouAre(date, resultType)
            }
    }
    
    /*!
     * @discussion You can call this mathod to force try to sync with default remote server.
     * @brief This syncronization is performing by default every time when you call "protect" method
     */
    public class func tryToMakeNewSyncPoint() {
        ChronosPsychic.tryToSyncTimeWithGlobalWeb()
    }
    
    /*!
     * @discussion Call this method to save current iformation about time on device. It is strongly recommended to call this method in methods of AppDelegate for saving actual info before quitting from your app.
     * @brief By default performed every 2.5 min
     */
    public class func performSavingOfTimeData() {
        ChronosKeeper.keeper().saveAtomicTime()
    }
    
    /*!
     * @discussion Call to sync Chronos with time, provided by your server.
     * @brief Recommended to switch off default server syncronization in "protect" method
     * @param serverTime timeInterval, provided by your server.
     */
    public class func syncWith(serverTime time: Double) {
        ChronosPsychic.saveSyncPoint(time)
    }
    
    /*!
     * @discussion Call this method if you want to change interval between saving of time information actions.
     * @brief There is no possibility to cancel saving at all, bacause it will lead to incorrect countings eventually.
     * @param withInterval timeInterval in seconds between savings. Default - 2.5 min
     */
    public class func relaunchAutoSavingProcess(withInterval interval: Double?) {
        ChronosWard.ward().startSavingSchedule(withInterval: interval)
    }
    
}
