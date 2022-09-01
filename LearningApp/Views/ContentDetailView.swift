//
//  ContentDetailView.swift
//  LearningApp
//
//  Created by Oliwier Woznicki on 31.08.22.
//

import SwiftUI
import AVKit

struct ContentDetailView: View {
    
    @EnvironmentObject var model: ContentModel
    
    var body: some View {
        
        let lesson = model.currentLesson
        let url = URL(string: Constants.videoHostUrl + (lesson?.video ?? ""))
        
        VStack {
        
        if url != nil {
        
        VideoPlayer(player:AVPlayer(url:url!) )
                .cornerRadius(10)
        }
        
        // TODO: Description
            
            CodeTextView()
        
        // Show Next lesson Button only if there is a next lesson
            
            if model.hasNextLesson() {
                
                Button(action: {
                    
                    // Advance lesson
                    model.nextLesson()
                    
                }, label: {
                    
                    ZStack {
                        RectangleCard(color: Color.green)
                            .frame(height: 48)
                        
                        
                        Text("Next Lesson: \(model.currentModule!.content.lessons[model.currentLessonIndex + 1].title)")
                            .foregroundColor(Color.white)
                            .bold()
                    }
           
                })
            }
            else {
                // Show the complete button instead
                Button(action: {
                    
                    // Take the user backt to home view
                    model.cuurrentContentSelected = nil
                  
                    
                }, label: {
                    
                    ZStack {
                        RectangleCard(color: Color.green)
                            .frame(height: 48)
                        
                        Text("Complete")
                            .foregroundColor(Color.white)
                            .bold()
                    }
           
                })
                
            }
            
        }
        .padding()
        .navigationTitle(lesson?.title ?? "")
        
    }
}

struct ContentDetailView_Previews: PreviewProvider {
    static var previews: some View {
        ContentDetailView()
    }
}
