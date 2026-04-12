## Why

当前版本的烧香流程可运行，但在输入退出、完成态节奏和烟雾对齐上存在体验与规格偏差，导致用户感知不连贯。该修复需要尽快完成，以提升仪式感一致性并避免“输入丢失/动画空档”的误解。

## What Changes

- 修复输入区交互：在 idle 状态保留并展示已输入心愿文本，不再仅显示占位入口。
- 修复完成态节奏：空心愿场景跳过文字消散等待，直接进入祝语淡入。
- 修复烟雾几何一致性：统一香柱与粒子发射点布局常量，避免烟雾与香头错位。
- 补充交互一致性约束：点击外部退出输入时，同时保证输入焦点正确收起。

## Capabilities

### New Capabilities
- None.

### Modified Capabilities
- `prayer-input`: 调整退出输入后的展示要求，明确 idle 状态应保留并展示已输入内容。
- `completion-experience`: 调整空心愿完成分支，要求跳过文字消散阶段并立即显示祝语。
- `burning-animation`: 增加烟雾发射点与香棒几何对齐约束，要求布局常量保持单一来源或等值同步。

## Impact

- Affected code:
  - `cloud-incense/PrayerInputView.swift`
  - `cloud-incense/CompletionView.swift`
  - `cloud-incense/IncenseCanvasView.swift`
  - `cloud-incense/SmokeScene.swift`
  - `cloud-incense/ContentView.swift`（输入焦点收起一致性）
- API/Dependency impact: 无新增外部依赖，无平台 API 变更。
- Risk: 低到中，主要风险为动画时序调整引发视觉回归，需要在 iOS 与 macOS 双端回归验证。
