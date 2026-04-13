import SwiftUI

struct CompletionView: View {
    @Environment(BurnSession.self) private var session
    @State private var prayerOpacity: Double = 1
    @State private var prayerOffset: CGFloat = 0
    @State private var blessingVisible = false
    @State private var blessingOpacity: Double = 0

    var body: some View {
        ZStack {
            Color.black.opacity(0.7)
                .ignoresSafeArea()

            VStack(spacing: 48) {
                // Prayer text that dissolves upward with the last smoke
                if !session.prayerText.isEmpty {
                    Text(session.prayerText)
                        .font(.title3)
                        .fontWeight(.light)
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 36)
                        .opacity(prayerOpacity)
                        .offset(y: prayerOffset)
                }

                // Blessing + replay button
                if blessingVisible {
                    VStack(spacing: 28) {
                        VStack(spacing: 10) {
                            Text("愿您所愿")
                                .font(.title)
                                .fontWeight(.light)
                                .foregroundColor(Color(red: 1, green: 0.92, blue: 0.72))
                            Text("皆得圆满")
                                .font(.title2)
                                .fontWeight(.ultraLight)
                                .foregroundColor(Color(red: 1, green: 0.85, blue: 0.60))
                                .tracking(4)
                        }

                        Button {
                            withAnimation(.easeInOut(duration: 0.4)) {
                                session.reset()
                            }
                        } label: {
                            Text("再次祈祷")
                                .font(.callout)
                                .foregroundColor(.white.opacity(0.85))
                                .padding(.horizontal, 32)
                                .padding(.vertical, 12)
                                .overlay(
                                    Capsule()
                                        .stroke(Color.white.opacity(0.35), lineWidth: 1)
                                )
                                .shadow(color: .white.opacity(0.25), radius: 8)
                        }
                        .buttonStyle(.plain)
                    }
                    .opacity(blessingOpacity)
                }
            }
        }
        .onAppear {
            let hasPrayer = !session.prayerText.isEmpty
            prayerOpacity = 1
            prayerOffset = 0
            blessingVisible = false
            blessingOpacity = 0

            if hasPrayer {
                // Phase 1: prayer text dissolves upward (2 s)
                withAnimation(.easeIn(duration: 2.0)) {
                    prayerOpacity = 0
                    prayerOffset = -30
                }
                // Phase 2: blessing fades in after dissolution completes
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.3) {
                    blessingVisible = true
                    withAnimation(.easeIn(duration: 1.2)) {
                        blessingOpacity = 1
                    }
                }
            } else {
                blessingVisible = true
                withAnimation(.easeIn(duration: 1.0)) {
                    blessingOpacity = 1
                }
            }
        }
    }
}
