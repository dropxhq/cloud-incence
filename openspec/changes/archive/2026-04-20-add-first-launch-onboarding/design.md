## Context

云香目前没有任何首次使用引导。用户首次打开应用看到的是纯黑界面和三根香棒，缺乏任何操作提示。核心流程（写祈祷词 → 点燃 → 冥想等待）对新用户不直观，可能导致用户无法发现关键操作而流失。

现有技术栈：SwiftUI + `@Observable`，部署目标 iOS 26+，无 NavigationStack 依赖（使用 `@State` 驱动全屏 overlay），风格为纯黑底 + 发光白色描边。

## Goals / Non-Goals

**Goals:**
- 首次启动时展示多步引导卡片，介绍核心流程
- 引导完成后永久标记，后续启动直接进入主界面
- 与现有 UI 风格（纯黑 + 发光白描边）保持一致
- 支持所有现有语言（en / zh-Hans / zh-Hant / ja / ko）

**Non-Goals:**
- 不提供重新查看引导的入口（Settings 内复位超出本次范围）
- 不使用动态跳转式新手任务（Task-based onboarding）
- 不更改现有 `BurnSession` 状态机逻辑
- 不支持跳过单步（用户必须逐步滑过或点击 Next）

## Decisions

### D1：使用 `UserDefaults` 持久化引导完成状态，而非 SwiftData / CloudKit

**选择**：`UserDefaults.standard.bool(forKey: "hasCompletedOnboarding")`

**理由**：引导标记是纯本地、单布尔值、无需同步到其他设备。SwiftData 或 iCloud 同步反而会导致用户换设备后看不到引导，体验更差。`UserDefaults` 轻量且无依赖。

**备选**：SwiftData（过重）、AppStorage（等价 UserDefaults，可用 `@AppStorage` 简化）→ 最终采用 `@AppStorage("hasCompletedOnboarding")` 在 App 入口直接读写。

### D2：引导 UI 以全屏 `.fullScreenCover` 呈现，而非插入 NavigationStack

**选择**：在 `cloud_incenseApp` 的 `WindowGroup` 中，根据 `hasCompletedOnboarding` 条件渲染 `OnboardingView` 或 `ContentView`。

**理由**：当前架构无 NavigationStack；使用条件渲染比 `.fullScreenCover` 更简洁，避免模态弹出动画与沉浸感冲突。引导结束后通过回调将 `hasCompletedOnboarding` 置 `true`，SwiftUI 自动切换到 `ContentView`。

### D3：引导内容以静态分步卡片实现，每步一张卡

**选择**：`TabView(selection:)` + `.tabViewStyle(.page(indexDisplayMode: .never))`，配合自定义底部导航点和「开始」按钮。

**理由**：`TabView` 天然支持横向滑动翻页，iOS 26 上流畅，代码最少。自定义导航点保持风格统一（不用系统灰色小点）。

**步骤规划（3 步）**：
1. 欢迎页 — App 名称 + 一句话介绍
2. 写下祈祷 — 演示祈祷输入，说明文字随焦点浮现
3. 点燃与冥想 — 说明倾斜控烟、灰烬生长、Live Activity

## Risks / Trade-offs

- **[风险] 用户误删 UserDefaults 后引导重复出现** → 可接受，引导体验轻量，不构成干扰。
- **[风险] 未来新增功能无法追加引导步骤给老用户看** → 在本次范围外，若需可引入版本号键（`onboardingVersion`）。
- **[Trade-off] 条件渲染而非 fullScreenCover**：切换时无模态动画，首次加载即进入引导，符合沉浸感优先原则。
