//
//  cloud_incenseApp.swift
//  cloud-incense
//
//  Created by Monster 林 on 2026/4/11.
//

import SwiftUI

@main
struct cloud_incenseApp: App {
    @AppStorage("hasCompletedOnboarding") var hasCompletedOnboarding: Bool = false
    @State private var session = BurnSession()
    @State private var tiltManager = TiltManager()

    var body: some Scene {
        WindowGroup {
            ZStack {
                ContentView()
                    .environment(session)
                    .environment(tiltManager)

                if !hasCompletedOnboarding {
                    OnboardingView {
                        hasCompletedOnboarding = true
                    }
                    .transition(.opacity)
                }
            }
            .animation(.easeInOut(duration: 0.4), value: hasCompletedOnboarding)
        }
        #if os(macOS)
        .windowResizability(.contentSize)
        #endif
    }
}
