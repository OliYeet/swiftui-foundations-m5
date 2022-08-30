//
//  LearningAppApp.swift
//  LearningApp
//
//  Created by Oliwier Woznicki on 30.08.22.
//

import SwiftUI

@main
struct LearningApp: App {
    var body: some Scene {
        WindowGroup {
            HomeView()
                .environmentObject(ContentModel())
        }
    }
}
