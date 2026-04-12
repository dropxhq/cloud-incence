## Why

当前烧香体验已具备基础仪式流程，但缺少“与设备环境联动”和“烧香过程可视沉淀”的沉浸感。引入重力联动烟雾、香灰演化与灵动岛状态后，用户能更直观感知“香在燃烧、心愿在进行中”。

## What Changes

- 新增重力联动烟雾：设备倾斜时烟雾漂移方向与强度随之变化。
- 新增香灰演化表现：燃烧过程中香灰逐步形成勾炉香形态，燃尽后整体掉落至香炉内。
- 新增点香后系统状态展示：在支持设备上通过 Live Activity / 灵动岛展示燃烧状态与剩余时间。
- 新增多平台降级策略：不支持灵动岛或传感器的平台保持现有体验并提供应用内状态兜底。

## Capabilities

### New Capabilities
- `tilt-reactive-smoke`: 通过设备姿态驱动烟雾粒子受力方向，实现倾斜联动的实时视觉反馈。
- `ash-evolution`: 基于燃烧进度逐步显示香灰轨迹并在燃尽时触发掉落收束动画。
- `live-activity-burn-status`: 点香后发布 Live Activity，在灵动岛/锁屏展示燃烧阶段与剩余时间。

### Modified Capabilities
- None.

## Impact

- Affected code:
  - `cloud-incense/SmokeScene.swift`
  - `cloud-incense/BurnSession.swift`
  - `cloud-incense/IncenseCanvasView.swift`
  - `cloud-incense/cloud_incenseApp.swift`
  - 新增 ActivityKit 状态发布与 Widget/Live Activity 相关文件（如采用）
- APIs/Frameworks:
  - `CoreMotion`（姿态感应）
  - `ActivityKit`（Live Activity / 灵动岛）
  - 可能需要 `WidgetKit` 承载 Activity UI
- Platform considerations:
  - 灵动岛仅在支持机型可见；不支持设备需降级为锁屏 Live Activity 或应用内状态展示。
  - macOS 无重力传感器，需使用固定风向或关闭倾斜联动。
