//
//  SpeakSevices.swift
//  DaSpeakable Me
//
//  Created by Agil Sulapohan Suaga on 27/06/22.
//

import Foundation
import Speech

class SpeakHelper{
    
    
    func getWordPerMinutes(speakResult : SFSpeechRecognitionResult?) -> (wpm:Double?, averagePause:TimeInterval?, wordCount:Int?) {
        
        guard let speechFinishedResult = speakResult else {
            print("No Result")
            return(0.0, 00.00, 0)
        }
        
        
        let wordSpoken = speechFinishedResult.bestTranscription.formattedString
        let chararacterSet = CharacterSet.whitespacesAndNewlines.union(.punctuationCharacters)
        let components = wordSpoken.components(separatedBy: chararacterSet)
        let words = components.filter { !$0.isEmpty }
        let totalWord = words.count
        
        
        let wordPerMinutes = speechFinishedResult.speechRecognitionMetadata?.speakingRate
        let averagePauseDuration = speechFinishedResult.speechRecognitionMetadata?.averagePauseDuration
        
        //let durationSpeak = speechFinishedResult.speechRecognitionMetadata?.speechDuration
        
        
        return (wpm:wordPerMinutes, averagePause:averagePauseDuration, wordCount:totalWord)
    }
    
    
}
