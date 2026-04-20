# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

**Cloud Incense (云香)** is a multi-platform meditation app for iOS, macOS, and visionOS. Users write a prayer/intention, ignite virtual incense sticks, and watch them burn with physics-based smoke and ash effects. It includes Live Activity integration for Dynamic Island and lock screen progress tracking.

## Build & Development

Open in Xcode 26 with Swift 6:

```bash
open cloud-incense.xcodeproj
```

Select the `cloud-incense` scheme and run on device/simulator. There is no external package manager — only system frameworks are used.

**Deployment targets**: iOS 26.4+, macOS 26.3+, visionOS 26.4+

**Targets**:
- `cloud-incense` — main app (`top.dropx.cloud-incense`)
- `cloud-incense-liveExtension` — Live Activity widget (`top.dropx.cloud-incense.cloud-incense-live`)

There are no automated tests in the project. Ash physics and smoke behavior must be verified visually.

## Architecture

The app is structured around a central state machine (`BurnSession`) and uses `@Observable` classes (Swift 5.9+, no Combine).

**State machine phases**: `idle → composing → lighting → burning → complete`

```
cloud_incenseApp (@main)
  ├─ BurnSession        — central state machine + progress tracking
  ├─ TiltManager        — CoreMotion gravity vector → screen-space offset
  └─ ContentView
       ├─ IncenseCanvasView
       │    ├─ SmokeScene (SpriteKit particle emitters, tilt-reactive)
       │    ├─ IncenseStickView × 3 (AshTrailShape physics)
       │    └─ IncenseHolderView
       ├─ PrayerInputView
       └─ CompletionView

Services:
  ├─ BurnActivityService   — ActivityKit Live Activity lifecycle
  └─ NotificationService   — local notification on burn completion
```

**Key files**:

| File | Role |
|------|------|
| `BurnSession.swift` | State machine; ignition sequence (center → left → right); 1260s burn duration |
| `TiltManager.swift` | CoreMotion integration; orientation-aware gravity remapping; low-pass filter (α=0.12) |
| `IncenseCanvasView.swift` | All visual components; `AshTrailShape` chain-integration physics |
| `SmokeScene.swift` | SpriteKit scene; smoke driven via SwiftUI `onChange` callbacks |
| `BurnActivityAttributes.swift` | Shared ActivityKit data model — must stay in sync with widget extension |
| `BurnActivityService.swift` | Live Activity start/update/end; prayer summary truncation |

## Critical Constraints

**`BurnActivityAttributes` must match exactly** between the main app and the widget extension. A field mismatch causes silent runtime crashes with no useful error output.

**Do not add `@Observable` to SpriteKit classes.** `SmokeScene` is driven by SwiftUI `onChange` callbacks — direct observation breaks the bridge.

**`TiltManager` gravity mapping is complex on purpose.** It remaps `CMDeviceMotion` gravity vectors per device orientation (portrait, landscape-left, landscape-right, upside-down). Do not simplify.

**`AshTrailShape` is a physics engine.** Treat it as such — test visually after any change to ash parameters.

**Platform guards are required.** Wrap `CoreMotion`, `ActivityKit`, and `UserNotifications` in `#if os(iOS)` — macOS/visionOS silently skip these frameworks.

**Burn duration** is 1260s (21 minutes). Do not change without a deliberate decision.

## Design Language

Pure black background with neon white elements — no warm colors:

- Background: `Color.black`
- Strokes and fills: white with layered `.shadow()` for glow/bloom
- Fill opacity: `0.04–0.08`; secondary text opacity: `0.35–0.55`

See [docs/ui-style-guide.md](air-file://0j8mrfj6pscdj8ppjf1h/Users/max/workspace/code/cloud-incense/docs/ui-style-guide.md?type=file&root=%252F) for component-level styling specifications.

## Localization

The app is localized in 5 languages: English, Simplified Chinese, Traditional Chinese, Japanese, Korean. Strings live in `.lproj` folders; the app display name is set via `InfoPlist.strings` (not build settings). See [docs/localization.md](air-file://0j8mrfj6pscdj8ppjf1h/Users/max/workspace/code/cloud-incense/docs/localization.md?type=file&root=%252F) for conventions.
