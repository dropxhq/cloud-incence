//
//  OnboardingView.swift
//  cloud-incense
//

import SwiftUI

// MARK: - Data Model

enum OnboardingCardAnchor { case top, center, bottom }

/// 箭头要指向的真实 UI 元素
enum OnboardingArrowTarget {
    /// 指向香棒（箭头从下方朝上指）
    case incenseStick
    /// 指向祈祷输入框（箭头从上方朝下指）
    case prayerInput
}

struct OnboardingStep {
    let title: LocalizedStringKey
    let description: LocalizedStringKey
    let cardAnchor: OnboardingCardAnchor
    let arrowTarget: OnboardingArrowTarget?
}

// MARK: - Overlay View

struct OnboardingView: View {
    let onComplete: () -> Void
    @State private var currentStep = 0

    private let steps: [OnboardingStep] = [
        OnboardingStep(
            title: "onboarding.step1.title",
            description: "onboarding.step1.description",
            cardAnchor: .center,
            arrowTarget: nil
        ),
        // 卡片在上方；箭头指向下方输入框
        OnboardingStep(
            title: "onboarding.step2.title",
            description: "onboarding.step2.description",
            cardAnchor: .top,
            arrowTarget: .prayerInput
        ),
        // 卡片在下方；箭头指向上方香棒
        OnboardingStep(
            title: "onboarding.step3.title",
            description: "onboarding.step3.description",
            cardAnchor: .bottom,
            arrowTarget: .incenseStick
        )
    ]

    var body: some View {
        ZStack {
            Color.black.opacity(0.72).ignoresSafeArea()

            ZStack {
                ForEach(steps.indices, id: \.self) { index in
                    if index == currentStep {
                        OnboardingStepOverlay(
                            step: steps[index],
                            totalSteps: steps.count,
                            currentStep: currentStep,
                            onNext: advance
                        )
                        .transition(.opacity)
                    }
                }
            }
            .animation(.easeInOut(duration: 0.3), value: currentStep)
        }
        .ignoresSafeArea()
    }

    private func advance() {
        if currentStep < steps.count - 1 { currentStep += 1 } else { onComplete() }
    }
}

// MARK: - Single Step Overlay

private struct OnboardingStepOverlay: View {
    let step: OnboardingStep
    let totalSteps: Int
    let currentStep: Int
    let onNext: () -> Void

    @State private var arrowPulse = false

    var body: some View {
        GeometryReader { geo in
            ZStack {
                // ── 卡片 ──────────────────────────────────────────
                cardView
                    .padding(.horizontal, 28)
                    .frame(maxWidth: .infinity, maxHeight: .infinity,
                           alignment: cardAlignment)
                    .padding(cardEdgePadding(geo: geo))

                // ── 箭头（精确坐标定位）────────────────────────────
                if let target = step.arrowTarget {
                    let arrowY = targetY(target, geo: geo)
                    arrowView(pointingUp: target == .incenseStick)
                        .position(x: geo.size.width / 2, y: arrowY)
                }
            }
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 0.65).repeatForever(autoreverses: true)) {
                arrowPulse = true
            }
        }
    }

    // MARK: - 目标元素 Y 坐标计算
    //
    // ContentView 布局：
    //   Spacer() [flex]
    //   IncenseCanvasView  height = 340
    //   Spacer(height: 28)
    //   PrayerInputView    height ≈ 55
    //   Spacer() [flex]
    //
    // 两个 flex Spacer 平分剩余空间。

    private func targetY(_ target: OnboardingArrowTarget, geo: GeometryProxy) -> CGFloat {
        let safeTop    = geo.safeAreaInsets.top
        let safeBottom = geo.safeAreaInsets.bottom
        let totalH     = geo.size.height

        let canvasH: CGFloat  = 340   // IncenseLayout.canvasHeight
        let holderH: CGFloat  = 50    // IncenseLayout.holderHeight
        let stickH:  CGFloat  = 200   // IncenseLayout.centerStickHeight
        let gapH:    CGFloat  = 28    // ContentView 固定间距
        let inputH:  CGFloat  = 55    // PrayerInputView 估算高度

        let usable    = totalH - safeTop - safeBottom
        let fixed     = canvasH + gapH + inputH
        let spacer    = max(0, (usable - fixed) / 2)

        let canvasTop = safeTop + spacer

        switch target {
        case .incenseStick:
            // 香棒从 holder 顶端向上延伸
            // holder 顶端 = canvasTop + canvasH - holderH
            // 香棒中心   = holderTop - stickH / 2
            let holderTop  = canvasTop + canvasH - holderH
            let stickCenter = holderTop - stickH / 2
            // 箭头放在香棒中心下方约 30pt，向上指
            return stickCenter + 30

        case .prayerInput:
            // 输入框中心 = canvasTop + canvasH + gapH + inputH/2
            let inputCenter = canvasTop + canvasH + gapH + inputH / 2
            // 箭头放在输入框上方约 30pt，向下指
            return inputCenter - 30
        }
    }

    // MARK: - 箭头视图

    private func arrowView(pointingUp: Bool) -> some View {
        let symbol = pointingUp ? "arrow.up" : "arrow.down"
        let pulse: CGFloat = arrowPulse ? 7 : -7
        return VStack(spacing: 5) {
            Image(systemName: symbol)
                .font(.system(size: 32, weight: .ultraLight))
                .foregroundStyle(.white.opacity(0.95))
            Image(systemName: symbol)
                .font(.system(size: 20, weight: .ultraLight))
                .foregroundStyle(.white.opacity(0.4))
        }
        .shadow(color: .white.opacity(0.8), radius: 6)
        .shadow(color: .white.opacity(0.3), radius: 16)
        .offset(y: pointingUp ? -pulse : pulse)
    }

    // MARK: - 信息卡片

    private var cardView: some View {
        VStack(spacing: 18) {
            VStack(spacing: 10) {
                Text(step.title)
                    .font(.system(size: 22, weight: .semibold))
                    .foregroundStyle(.white)
                    .multilineTextAlignment(.center)
                    .shadow(color: .white.opacity(0.5), radius: 8)

                Text(step.description)
                    .font(.system(size: 15))
                    .foregroundStyle(.white.opacity(0.6))
                    .multilineTextAlignment(.center)
                    .lineSpacing(5)
            }

            VStack(spacing: 16) {
                HStack(spacing: 7) {
                    ForEach(0..<totalSteps, id: \.self) { i in
                        Circle()
                            .fill(Color.white.opacity(i == currentStep ? 1.0 : 0.25))
                            .frame(width: i == currentStep ? 7 : 4,
                                   height: i == currentStep ? 7 : 4)
                            .shadow(color: .white.opacity(i == currentStep ? 0.75 : 0), radius: 4)
                    }
                }

                Button(action: onNext) {
                    Text(currentStep < totalSteps - 1
                         ? LocalizedStringKey("onboarding.button.next")
                         : LocalizedStringKey("onboarding.button.start"))
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .overlay(Capsule().stroke(Color.white.opacity(0.6), lineWidth: 1))
                        .shadow(color: .white.opacity(0.7), radius: 5)
                        .shadow(color: .white.opacity(0.2), radius: 12)
                }
                .buttonStyle(.plain)
            }
        }
        .padding(24)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.white.opacity(0.06))
                .overlay(RoundedRectangle(cornerRadius: 20)
                    .stroke(Color.white.opacity(0.14), lineWidth: 1))
        )
    }

    // MARK: - 卡片布局辅助

    private var cardAlignment: Alignment {
        switch step.cardAnchor {
        case .top:    .top
        case .center: .center
        case .bottom: .bottom
        }
    }

    private func cardEdgePadding(geo: GeometryProxy) -> EdgeInsets {
        let safeTop    = geo.safeAreaInsets.top + 24
        let safeBottom = geo.safeAreaInsets.bottom + 24
        switch step.cardAnchor {
        case .top:    return EdgeInsets(top: safeTop,  leading: 0, bottom: 0,           trailing: 0)
        case .center: return EdgeInsets(top: 0,        leading: 0, bottom: 0,           trailing: 0)
        case .bottom: return EdgeInsets(top: 0,        leading: 0, bottom: safeBottom,  trailing: 0)
        }
    }
}


