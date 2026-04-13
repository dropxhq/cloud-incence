import SwiftUI

struct PrayerInputView: View {
    @Environment(BurnSession.self) private var session
    @FocusState private var isFocused: Bool

    var body: some View {
        @Bindable var bindableSession = session

        Group {
            switch session.state {
            case .idle:
                Button {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        session.state = .composing
                    }
                } label: {
                    Group {
                        if session.prayerText.isEmpty {
                            HStack(spacing: 8) {
                                Image(systemName: "pencil.line")
                                    .foregroundColor(.white.opacity(0.35))
                                Text("点此写下心愿")
                                    .foregroundColor(.white.opacity(0.35))
                            }
                        } else {
                            Text(session.prayerText)
                                .font(.body)
                                .foregroundColor(.white.opacity(0.55))
                                .multilineTextAlignment(.center)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .padding(.horizontal, 10)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.white.opacity(0.18), lineWidth: 1)
                            .background(Color.white.opacity(0.04).cornerRadius(12))
                    )
                    .cornerRadius(12)
                }
                .buttonStyle(.plain)

            case .composing:
                VStack(spacing: 10) {
                    TextField("写下您的心愿...", text: $bindableSession.prayerText, axis: .vertical)
                        .lineLimit(3...5)
                        .focused($isFocused)
                        .foregroundColor(.white)
                        .tint(.white)
                        .padding(14)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.white.opacity(0.22), lineWidth: 1)
                                .background(Color.white.opacity(0.05).cornerRadius(12))
                        )
                        .cornerRadius(12)

                    Text("点击或长按中间那炷香，点燃心愿")
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.35))
                }
                .onAppear { isFocused = true }

            case .lighting, .burning:
                if !session.prayerText.isEmpty {
                    Text(session.prayerText)
                        .font(.body)
                        .foregroundColor(.white.opacity(0.55))
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: .infinity)
                        .padding()
                } else {
                    EmptyView()
                }

            case .complete:
                EmptyView()
            }
        }
        .animation(.easeInOut(duration: 0.25), value: session.state)
        .onChange(of: session.state) { _, newState in
            isFocused = (newState == .composing)
        }
    }
}
