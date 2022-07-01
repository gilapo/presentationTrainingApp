//
//  PracticeModel.swift
//  DaSpeakable Me
//
//  Created by Agil Sulapohan Suaga on 01/07/22.
//

import Foundation

struct PracticeModel:Codable{
    
    //var id:String?
    
    var practiceTitle:String?
    var wordPerMinutes:Double?
    var articulation:Double?
    var smoothRate:Double?
    var fillerWords = [(label: String, confidence: Float)]()
    
    var videoUrl:String?
    
    
    init(practiceTitle:String, wordPerMinutes:Double, articulation:Double, smoothRate:Double, fillerWords:[(label: String, confidence: Float)], videoUrl:String){
        self.practiceTitle = practiceTitle
        self.wordPerMinutes = wordPerMinutes
        self.articulation = articulation
        self.smoothRate = smoothRate
        self.fillerWords = fillerWords
        self.videoUrl =  videoUrl
    }
    
}
