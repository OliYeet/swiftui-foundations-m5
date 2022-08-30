//
//  ContentModel.swift
//  LearningApp
//
//  Created by Oliwier Woznicki on 30.08.22.
//

import Foundation

class ContentModel: ObservableObject {
    
    @Published var modules = [Module]()
    
    var styleData: Data?
    
    init() {
        
        getLocalData()
    }
    
    func getLocalData() {
        
        let jsonURL = Bundle.main.url(forResource: "data", withExtension: "json")
        
        do {
        
        let jsonData = try Data(contentsOf: jsonURL!)
            
            let jsonDecoder = JSONDecoder()
            
           let modules = try jsonDecoder.decode([Module].self, from: jsonData)
            
            self.modules = modules
            
        }
        catch {
            print("Couldnt parse local data")
            
            
        }
        
        let styleURl = Bundle.main.url(forResource: "style", withExtension: "html")
        
        do {
            
            let styleData = try Data(contentsOf: styleURl!)
            
            self.styleData = styleData
            
        }catch {
            print("Couldnt parse style data")
        }
        
    }
    
}
