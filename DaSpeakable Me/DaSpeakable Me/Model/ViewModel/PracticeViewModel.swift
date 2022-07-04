//
//  PracticeViewModel.swift
//  DaSpeakable Me
//
//  Created by Agil Sulapohan Suaga on 01/07/22.
//

import Foundation

class PracticeViewModel {
    
    var items: [PracticeModel] = [] {
        didSet{
            savePractice()
        }
    }
    
    init() {
        getItems()
    }
    
    func getItems() {
        guard
            let data = UserDefaults.standard.data(forKey: "PracticeList"),
            let savedPractices = try? JSONDecoder().decode([PracticeModel].self, from: data)
        else { return }
        
        self.items = savedPractices
    }
    
    func addPractice(practiceTitle: String, practiceWPM: Double, practiceArticulation: Double, practiceSmoothRate: Double, practiceVideoUrl: String, practiceFwEh: Int, practiceFwHa: Int, practiceFwHm: Int, currentDate:String) {
        
        let newPractice = PracticeModel(practiceTitle: practiceTitle, practiceWPM: practiceWPM, practiceArticulation: practiceArticulation, practiceSmoothRate: practiceSmoothRate, practiceVideoUrl: practiceVideoUrl, practiceFwEh: practiceFwEh, practiceFwHa: practiceFwHa, practiceFwHm: practiceFwHm, currentDate: currentDate)
        
        items.append(newPractice)
    }
    
    func savePractice() {
        if let encodedData = try? JSONEncoder().encode(items) {
            UserDefaults.standard.set(encodedData, forKey: "PracticeList")
        }
    }
}
