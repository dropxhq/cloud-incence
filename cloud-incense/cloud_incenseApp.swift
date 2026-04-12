//
//  cloud_incenseApp.swift
//  cloud-incense
//
//  Created by Monster 林 on 2026/4/11.
//

import SwiftUI

@main
struct cloud_incenseApp: App {
    @State private var session = BurnSession()
    @State private var tiltManager = TiltManager()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(session)
                .environment(tiltManager)
        }
        #if os(macOS)
        .windowResizability(.contentSize)
        #endif
    }
}
