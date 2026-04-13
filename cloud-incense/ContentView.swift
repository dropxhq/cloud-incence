//
//  ContentView.swift
//  cloud-incense
//
//  Created by Monster 林 on 2026/4/11.
//

import SwiftUI

struct ContentView: View {
    @Environment(BurnSession.self) private var session
    @Environment(TiltManager.self) private var tiltManager
    @Environment(\.scenePhase) private var scenePhase

    var body: some View {
        ZStack {
            // Pure black background — mirrors the icon's deep void aesthetic
            Color.black
                .ignoresSafeArea()
            .onTapGesture {
                // Tapping outside dismisses keyboard and exits composing
                if session.state == .composing {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        session.state = .idle
                    }
                }
            }

            VStack(spacing: 0) {
                Spacer()

                IncenseCanvasView()

                Spacer().frame(height: 28)

                PrayerInputView()
                    .padding(.horizontal, 32)

                Spacer()
            }

            // Full-screen completion overlay
            if session.state == .complete {
                CompletionView()
                    .transition(.opacity)
            }
        }
        .preferredColorScheme(.dark)
        #if os(macOS)
        .frame(width: 400, height: 700)
        #endif
        // Resume progress when app returns to foreground
        .onChange(of: scenePhase) { _, phase in
            if phase == .active {
                session.updateProgress()
            }
        }
        // 1-second tick loop while burning; restarts on state change
        .task(id: session.state) {
            while session.state == .burning {
                session.updateProgress()
                try? await Task.sleep(for: .seconds(1))
            }
        }
        // Start tilt sensing only while incense is burning; stop otherwise to save battery
        .onChange(of: session.state) { _, state in
            if state == .burning {
                tiltManager.start()
            } else {
                tiltManager.stop()
            }
        }
    }
}

#Preview {
    ContentView()
        .environment(BurnSession())
        .environment(TiltManager())
}
