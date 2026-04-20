## Why

新用户首次打开云香时，面对纯黑屏幕和抽象的香棒场景，缺乏任何操作引导，容易感到困惑而流失。引导教程能帮助用户快速理解「写祈祷词 → 点燃 → 冥想等待」的核心使用流程，提升留存率。

## What Changes

- 新增首次启动检测逻辑（基于 `UserDefaults`），判断是否展示引导
- 新增全屏引导界面 `OnboardingView`，以分步卡片形式介绍核心功能
- 引导完成后跳转至正常主界面，标记"已完成引导"避免重复展示
- 引导流程支持多语言（与现有本地化架构保持一致）

## Capabilities

### New Capabilities

- `onboarding`: 首次启动引导流程，包括分步卡片展示、完成状态持久化及语言本地化支持

### Modified Capabilities

（无，现有规格无需更改）

## Impact

- `cloud_incenseApp.swift`：在应用入口判断引导状态，决定加载 `OnboardingView` 还是 `ContentView`
- 新文件 `OnboardingView.swift`：引导界面（SwiftUI，纯黑 + 发光白描边风格）
- 各语言 `Localizable.strings` / `InfoPlist.strings`：引导文案需本地化
- `UserDefaults`：写入 `hasCompletedOnboarding` 布尔标记
