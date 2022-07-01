//
//  PracticeViewModel.swift
//  DaSpeakable Me
//
//  Created by Agil Sulapohan Suaga on 01/07/22.
//

import Foundation

var practiceTitle:String?
var wordPerMinutes:Double?
var articulation:Double?
var smoothRate:Double?
var fillerWords = [(label: String, confidence: Float)]()

var videoUrl:String?

//class PracticeViewModel {
//
//    var items: [PracticeModel] = [] {
//        didSet{
//            savePractice()
//        }
//    }
//
//    init() {
//        getItems()
//    }
//
//    func getItems() {
//        guard
//            let data = UserDefaults.standard.data(forKey: "PracticeList")
//                let savedPractice = try? JSONDecoder.decode([PracticeModel])
//    }
//}

