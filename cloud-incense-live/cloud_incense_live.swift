//
//  cloud_incense_live.swift
//  cloud-incense-live
//
//  Created by Monster 林 on 2026/4/11.
//

import SwiftUI
import WidgetKit
import ActivityKit

// MARK: - Shared model
// Must stay in sync with BurnActivityAttributes in the main app target.
// Fields must match exactly:
// - phase: String
// - endDate: Date
// - startDate: Date (for progress calculation)
// - prayerSummary: String (for display in expanded/lock screen views)

struct BurnActivityAttributes: ActivityAttributes {
    struct ContentState: Codable, Hashable {
        var phase: String     // "燃烧中" | "已完成"
        var endDate: Date
        var startDate: Date
        var prayerSummary: String
    }
}

// MARK: - Helpers

/// Calculates burn progress as a percentage (0.0 to 1.0)
func calculateBurnProgress(startDate: Date, endDate: Date) -> Double {
    let elapsed = Date().timeIntervalSince(startDate)
    let duration = endDate.timeIntervalSince(startDate)
    guard duration > 0 else { return 0 }
    return min(max(elapsed / duration, 0), 1.0)
}

/// Truncates prayer text to fit display constraints
func truncatePrayer(_ text: String, maxLength: Int = 30) -> String {
    guard text.count > maxLength else { return text }
    return String(text.prefix(maxLength - 1)) + "…"
}

// MARK: - Lock Screen / Notification Banner View

struct BurnLockScreenView: View {
    let context: ActivityViewContext<BurnActivityAttributes>
    
    private var progress: Double {
        calculateBurnProgress(startDate: context.state.startDate, endDate: context.state.endDate)
    }
    
    private var displayPhase: String {
        switch context.state.phase {
        case "燃烧中":
            let remainingPercent = Int((1 - progress) * 100)
            return "燃烧中 (\(remainingPercent)%)"
        default:
            return "已完成"
        }
    }

    var body: some View {
        VStack(spacing: 8) {
            HStack(spacing: 10) {
                Image(systemName: "flame.fill")
                    .foregroundStyle(.orange)
                    .font(.title3)

                VStack(alignment: .leading, spacing: 2) {
                    Text(displayPhase)
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(.primary)
                    
                    if context.state.phase == "燃烧中" {
                        // Progress bar with percentage
                        ProgressView(value: progress)
                            .frame(height: 4)
                            .tint(.orange)
                    } else {
                        Text("心愿已达天听")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }

                Spacer()
            }
            
            // Prayer summary if available
            if !context.state.prayerSummary.isEmpty && context.state.phase == "燃烧中" {
                Text(truncatePrayer(context.state.prayerSummary))
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .lineLimit(1)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
    }
}

// MARK: - Widget Configuration

struct BurnLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: BurnActivityAttributes.self) { context in
            // Lock Screen banner / Notification Center card
            BurnLockScreenView(context: context)
                .activityBackgroundTint(Color(red: 0.06, green: 0.03, blue: 0.02))
                .activitySystemActionForegroundColor(.orange)

        } dynamicIsland: { context in
            let progress = calculateBurnProgress(startDate: context.state.startDate, endDate: context.state.endDate)
            
            return DynamicIsland {
                // Expanded island
                DynamicIslandExpandedRegion(.leading) {
                    Label("云烟", systemImage: "flame.fill")
                        .foregroundStyle(.orange)
                        .font(.caption)
                }
                
                DynamicIslandExpandedRegion(.center) {
                    VStack(spacing: 4) {
                        Text(context.state.phase)
                            .font(.caption.weight(.semibold))
                        
                        if context.state.phase == "燃烧中" {
                            // Progress bar in expanded view
                            ProgressView(value: progress)
                                .tint(.orange)
                                .frame(maxWidth: 80)
                        }
                    }
                }
                
                DynamicIslandExpandedRegion(.trailing) {
                    if context.state.phase == "燃烧中" {
                        let percent = Int(progress * 100)
                        Text("\(percent)%")
                            .font(.caption.weight(.semibold))
                            .foregroundStyle(.orange)
                    } else {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundStyle(.green)
                    }
                }
                
                DynamicIslandExpandedRegion(.bottom) {
                    if !context.state.prayerSummary.isEmpty && context.state.phase == "燃烧中" {
                        Text("正在祈祷："  + truncatePrayer(context.state.prayerSummary, maxLength: 40))
                            .font(.caption2)
                            .foregroundStyle(.secondary)
                            .lineLimit(1)
                    }
                }
                
            } compactLeading: {
                Image(systemName: "flame.fill")
                    .foregroundStyle(.orange)
                    .font(.caption2)
            } compactTrailing: {
                if context.state.phase == "燃烧中" {
                    let percent = Int(progress * 100)
                    Text("\(percent)%")
                        .font(.caption2.weight(.semibold))
                        .foregroundStyle(.orange)
                } else {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundStyle(.green)
                        .font(.caption2)
                }
            } minimal: {
                Image(systemName: "flame.fill")
                    .foregroundStyle(.orange)
                    .font(.caption2)
            }
            .widgetURL(URL(string: "cloud-incense://open"))
            .keylineTint(.orange)
        }
    }
}

// MARK: - Previews

extension BurnActivityAttributes {
    fileprivate static var preview: BurnActivityAttributes { .init() }
}

extension BurnActivityAttributes.ContentState {
    fileprivate static var burning: BurnActivityAttributes.ContentState {
        .init(
            phase: "燃烧中",
            endDate: Date().addingTimeInterval(1260),
            startDate: Date().addingTimeInterval(-300),
            prayerSummary: "祈愿世界和平"
        )
    }
    fileprivate static var complete: BurnActivityAttributes.ContentState {
        .init(
            phase: "已完成",
            endDate: Date(),
            startDate: Date().addingTimeInterval(-1260),
            prayerSummary: "祈愿世界和平"
        )
    }
}

#Preview("Lock Screen – burning", as: .content, using: BurnActivityAttributes.preview) {
    BurnLiveActivity()
} contentStates: {
    BurnActivityAttributes.ContentState.burning
    BurnActivityAttributes.ContentState.complete
}
