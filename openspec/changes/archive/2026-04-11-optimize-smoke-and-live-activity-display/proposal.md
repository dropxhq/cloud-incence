## Why

当前倾斜联动在横屏场景下会出现“烟向下飘”的违和感，破坏了“烟应持续上升”的核心感知。同时，灵动岛使用倒计时文本信息密度偏高，不符合快速扫视场景，且无法承载祈愿内容的状态表达。

## What Changes

- 调整倾斜联动语义：无论设备方向如何，烟雾主趋势保持向上，倾斜仅影响横向偏移与扰动强度。
- 增加屏幕方向感知与重力向量映射，修正横屏（尤其左横屏）下设备坐标与屏幕坐标错位。
- 优化 Live Activity / 灵动岛展示：移除倒计时文本，改为进度条表达燃烧进度。
- 在灵动岛与锁屏卡片中支持展示“正在祈祷”的简短内容（可截断），用于过程中的情感上下文。
- 保持不支持灵动岛设备的降级体验一致（锁屏 Live Activity 与应用内状态不回退）。

## Capabilities

### New Capabilities
- `dynamic-island-prayer-progress`: 定义灵动岛/锁屏以进度条 + 祈愿摘要展示燃烧状态的行为要求。

### Modified Capabilities
- `tilt-reactive-smoke`: 调整倾斜联动要求，明确“烟雾主趋势始终向上”与横竖屏方向一致性。
- `live-activity-burn-status`: 调整状态展示要求，从倒计时文本切换为进度表达，并纳入祈愿摘要字段。

## Impact

- Affected code:
  - `cloud-incense/TiltManager.swift`
  - `cloud-incense/SmokeScene.swift`
  - `cloud-incense/IncenseCanvasView.swift`
  - `cloud-incense/BurnActivityAttributes.swift`
  - `cloud-incense/BurnActivityService.swift`
  - `cloud-incense-live/cloud_incense_live.swift`
- Affected systems: CoreMotion, SpriteKit particle behavior, ActivityKit Live Activity rendering.
- Potential risks: 设备方向映射回归、灵动岛布局拥挤、祈愿文本隐私策略与截断规则。