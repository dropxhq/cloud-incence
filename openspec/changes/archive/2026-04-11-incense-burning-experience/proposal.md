## Why

用户希望在 iOS / iPadOS / macOS 上体验线上烧香祈福，将传统的庙堂仪式数字化，让无法亲临寺庙的人随时随地完成虔诚的祈祷。

## What Changes

- 新增主界面：展示香案场景（深色背景，三炷未燃立香）
- 新增心愿输入：用户写下一段祈祷文，三炷香共同承载同一心愿
- 新增点燃交互：长按中间那炷香，三炷依次点燃（中 → 左 → 右，间隔 0.3s）
- 新增燃烧动画：香棒从顶端逐渐缩短（21 分钟燃尽），SpriteKit 粒子系统呈现写实烟雾
- 新增燃烧状态管理：状态机驱动 `.idle → .composing → .lighting → .burning → .complete`
- 新增后台通知：燃尽时发送本地通知"您的心愿已达天听 🙏"
- 新增完成动画：心愿文字随最后一缕烟雾消散，屏幕淡出祝语

## Capabilities

### New Capabilities

- `incense-scene`: 主场景渲染——香案、三炷立香、香台的静态与动态展示
- `prayer-input`: 心愿输入界面——单段祈祷文的输入与确认流程
- `ignition-interaction`: 点燃交互——长按手势触发三炷依次点燃动画
- `burning-animation`: 燃烧动画——香棒缩短几何动画 + SpriteKit 粒子烟雾
- `burn-timer`: 燃烧计时器——21 分钟倒计时与后台本地通知
- `completion-experience`: 完成体验——心愿文字消散动画与结束祝语展示

### Modified Capabilities

## Impact

- 替换 `ContentView.swift` 默认模板内容
- 新增多个 SwiftUI View 文件及 SpriteKit 场景文件
- 新增 `UserNotifications` 权限（需在 Info.plist 配置）
- 依赖：SwiftUI、SpriteKit、UserNotifications（均为系统框架，无第三方依赖）
- 支持平台：iOS 17+、iPadOS 17+、macOS 14+（Sonoma）
