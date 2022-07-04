//
//  TimeHelper.swift
//  DaSpeakable Me
//
//  Created by Agil Sulapohan Suaga on 28/06/22.
//

import Foundation

class TimerHelper{
    
    func getTime(timerCounting:Int) -> String{
        
        let time = secondsToHoursMinutesSeconds(seconds: timerCounting)
        let timeString = makeTimeString(hours: time.0, minutes: time.1, seconds: time.2)
        
        return timeString
        
    }
    
    func secondsToHoursMinutesSeconds(seconds: Int) -> (Int, Int, Int) {
        return ((seconds / 3600), ((seconds % 3600) / 60),((seconds % 3600) % 60))
    }
    
    func makeTimeString(hours: Int, minutes: Int, seconds : Int) -> String {
        var timeString = ""
        timeString += String(format: "%02d", hours)
        timeString += " : "
        timeString += String(format: "%02d", minutes)
        timeString += " : "
        timeString += String(format: "%02d", seconds)
        return timeString
    }
    
    func getCurrentDate() -> String{
        let date = Date()
        let calendar = Calendar.current
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        
        let normalDate =  dateFormatter.string(from: date)
        let hour = calendar.component(.hour, from: date)
        let minutes = calendar.component(.minute, from: date)
        
        let currDate:String =  String("\(normalDate), \(hour).\(minutes)")
        
        return currDate
    }
}
