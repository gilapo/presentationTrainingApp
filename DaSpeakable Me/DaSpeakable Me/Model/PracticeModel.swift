//
//  PracticeModel.swift
//  DaSpeakable Me
//
//  Created by Agil Sulapohan Suaga on 01/07/22.
//

import Foundation

struct PracticeModel: Codable{
    
    //var id:String?

    var practiceTitle: String = ""
    var practiceWPM: Double = 0
    var practiceArticulation: Double = 0
    var practiceSmoothRate: Double = 0
    var practiceVideoUrl:String = ""
    // fw -> filler word
    var practiceFwEh: Int = 0
    var practiceFwHa: Int = 0
    var practiceFwHm: Int = 0
    
    var currentDate: String = ""
    
    var overallScore:Double = 0.0
    
    init(practiceTitle: String, practiceWPM: Double, practiceArticulation: Double, practiceSmoothRate: Double, practiceVideoUrl: String, practiceFwEh: Int, practiceFwHa: Int, practiceFwHm: Int, currentDate:String) {
        self.practiceTitle = practiceTitle
        self.practiceWPM = practiceWPM
        self.practiceArticulation = practiceArticulation
        self.practiceSmoothRate = practiceSmoothRate
        self.practiceVideoUrl = practiceVideoUrl
        self.practiceFwEh = practiceFwEh
        self.practiceFwHa = practiceFwHa
        self.practiceFwHm = practiceFwHm
        
        self.currentDate = currentDate
        
        self.overallScore = ((practiceWPM+practiceArticulation+practiceSmoothRate)/3)
    }
}
