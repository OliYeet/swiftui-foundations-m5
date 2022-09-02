//
//  ContentModel.swift
//  LearningApp
//
//  Created by Oliwier Woznicki on 30.08.22.
//

import Foundation

class ContentModel: ObservableObject {
    
    @Published var modules = [Module]()
    
    // Current module
    
    @Published var currentModule: Module?
    var currentModuleIndex = 0
    
    // Current lesson
    @Published var currentLesson: Lesson?
    var currentLessonIndex = 0
    
    // Current question
    
    @Published var currentQuestion: Question?
    var currentQuestionIndex = 0
    
    // Current lesson explanation
    
    @Published var codeText = NSAttributedString()
    

    var styleData: Data?
    
    // Current selected content and test
    @Published var cuurrentContentSelected: Int?
    @Published var currentTestSelected: Int?
    
    init() {
        
        getLocalData()
    }
    
    // MARK: - Data Methods
    
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
    
    // MARK: - Module navigation methods
    
    func beginModule(_ moduleid: Int) {
        
        // Find the indec for this module id
        for index in 0..<modules.count {
            if modules[index].id == moduleid {
                
                // Found the matching module
                currentModuleIndex = index
                break
            }
        }
        currentModule = modules[currentModuleIndex]
    }
    
    func beginLesson(_ lessonIndex: Int) {
        
        if lessonIndex < currentModule!.content.lessons.count {
            currentLessonIndex = lessonIndex 
            
        }else {
            currentLessonIndex = 0
        }
        // Set the current lesson
        currentLesson = currentModule!.content.lessons[currentLessonIndex]
        codeText = addStyling(currentLesson!.explanation)
    }
    
    func nextLesson() {
        
        // advance the lesson index
        
        currentLessonIndex += 1
        
        // Check that is within range
        
        if currentLessonIndex < currentModule!.content.lessons.count {
            
            currentLesson = currentModule!.content.lessons[currentLessonIndex]
            codeText = addStyling(currentLesson!.explanation)
        }else  {
            
            // Reset the lesson state
            currentLessonIndex = 0
            currentLesson = nil
        }
        
        // Set the current lesson property
        
    }
    
    func hasNextLesson() -> Bool {
        
        return (currentLessonIndex + 1 < currentModule!.content.lessons.count)
            
       
    }
    
    func beginTest(_ moduleId:Int) {
        
        // Set the current module
        beginModule(moduleId)
        
        // set the current question index
        currentQuestionIndex = 0
        
        // If there are questions, set the current question to the first one
        if currentModule?.test.questions.count ?? 0  > 0 {
            
            currentQuestion = currentModule!.test.questions[currentQuestionIndex]
            
            // Set the question content
            codeText = addStyling(currentQuestion!.content)
            
        }
       
    }
    
    // MARK: - Code Styling
    
    private func addStyling(_ htmlString: String) -> NSAttributedString {
        
        var resultString = NSAttributedString()
        var data = Data()
        
        // Add the styling data
        if styleData != nil {
            data.append(self.styleData!)
        }
        // Add the html data
        
        data.append(Data(htmlString.utf8))
        
        if let attributedString = try? NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil) {
            resultString = attributedString
        }
          
        return resultString
        
    }
    
}
