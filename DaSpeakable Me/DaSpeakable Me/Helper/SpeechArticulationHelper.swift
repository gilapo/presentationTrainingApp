//
//  SpeechRecognizerHelper.swift
//  DaSpeakable Me
//
//  Created by Agil Sulapohan Suaga on 29/06/22.
//

import Foundation
import Speech

class SpeechArticulationHelper {
    
    let pauseDurationMin = 1.5
    let pauseDurationMax = 5.0
    let charDurationMin = 0.2
    let charDurationMax = 0.8
    
    func getClearAndSmoothRate(speechFinishedResult : SFSpeechRecognitionResult?) -> (clearRate : Double, smoothRate : Double) {
        
        guard let speechFinishedResult = speechFinishedResult else {
            print("No Result")
            return (-1.0, -1.0)
        }
        
        let totalSegments = speechFinishedResult.bestTranscription.segments.count
        
        var timeTemp = 0.0
        var timeNow = 0.0
        
        var clearResult : [Double] = [Double]()
        var smoothResult : [Double] = [Double]()
        
        print("Processing Result")
        
        for i in 0..<totalSegments {
            let segmentedResult = speechFinishedResult.bestTranscription.segments[i]
            let word = segmentedResult.substring
            
            print(segmentedResult.substring)
            print(segmentedResult.duration)
            
            let voicing = speechFinishedResult.speechRecognitionMetadata?.voiceAnalytics!.voicing.acousticFeatureValuePerFrame
            let sumVoicing = (voicing?.reduce(0, +))!
            let meanVoicing = sumVoicing / Double(voicing!.count)
            let confidence = segmentedResult.confidence
            let clear = (meanVoicing + Double(confidence)) / 2
            clearResult.append(clear*100)
            
            timeNow = segmentedResult.timestamp
            let duration = segmentedResult.duration
            let charInWord = Double(word.count)
            
            //MARK: Kecepatan Kata
            var wordSpeed = 0.0
            if ((charDurationMin * charInWord) < duration) {
                wordSpeed = duration / (charDurationMax * charInWord)
                wordSpeed = wordSpeed > 1.0 ? 1.0 : wordSpeed
            }
            
            let pause = timeNow - timeTemp
            var pauseFinal = 0.0
            if pause > pauseDurationMin {
                pauseFinal = pause / pauseDurationMax
                pauseFinal = pauseFinal > 1.0 ? 1.0 : pauseFinal
            }
            
            print("word speed \(wordSpeed) pausefinal \(pauseFinal)")
            
            let notSmoothRate = (wordSpeed + pauseFinal) / 2
            let smoothRate = 1 - notSmoothRate
            
            smoothResult.append(smoothRate*100)
            
            timeTemp = timeNow + segmentedResult.duration
        }
        
        print(clearResult)
        print(smoothResult)
        
        let clearResultMean = clearResult.reduce(0, +) / Double(totalSegments)
        let smoothResultMean = smoothResult.reduce(0, +) /  Double(totalSegments)

        print("Clear Rate = \(clearResultMean) ; Smooth Rate = \(smoothResultMean)")
        
        return (clearResultMean, smoothResultMean)
    }
    
    
}
