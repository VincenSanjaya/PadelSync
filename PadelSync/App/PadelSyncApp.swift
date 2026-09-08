//
//  PadelSyncApp.swift
//  PadelSync
//
//  Created by Vincen Sanjaya on 04/09/26.
//

import SwiftUI
import SwiftData

@main
struct PadelSyncApp: App {
    @State private var showSplash = true
    
    var body: some Scene {
        WindowGroup {
            if showSplash {
                SplashView(isFinished: $showSplash)
                    .transition(.opacity)
            } else {
                MainTabView() // <-- Diarahkan ke Tab Bar utama kita
                    .transition(.opacity)
            }
        }
        .modelContainer(for: [Match.self, Partner.self])
    }
}
