## Context

项目起点是 Xcode 默认 SwiftUI 模板（`ContentView.swift` 仅含 Hello World）。目标是将其构建为一款跨 iOS / iPadOS / macOS 的线上烧香应用，核心体验是写下心愿、点燃三炷香、等待燃尽、收到祝福通知。无后端、无账号、无持久化需求——纯本地体验。

## Goals / Non-Goals

**Goals:**
- 实现完整的烧香仪式体验（输入 → 点燃 → 燃烧 → 完成）
- 写实烟雾视觉效果（SpriteKit 粒子系统）
- 跨平台单一代码库（SwiftUI + Conditional layout for macOS）
- 后台本地通知（21 分钟后提醒）
- 心愿文字随烟消散，不持久化存储

**Non-Goals:**
- 后端/云同步
- 用户账号与历史记录
- 社交/许愿墙功能
- 3D 渲染（RealityKit）
- 音效（可作后续迭代）

## Decisions

### 1. 状态机驱动 UI

使用 `@Observable` 的 `BurnSession` 类持有状态枚举：

```
enum BurnState {
    case idle              // 初始香案
    case composing         // 输入心愿（键盘弹出）
    case lighting          // 点燃动画进行中（~1s）
    case burning(progress: Double)  // 燃烧中，0.0→1.0
    case complete          // 燃尽
}
```

**为什么不用多个 @State？** 状态间有严格顺序依赖，枚举可在编译期防止非法状态组合。

---

### 2. 香棒燃烧动画：SwiftUI `Shape` + `withAnimation`

香棒用 `Rectangle` Shape 表示，通过 `scaleEffect(y: 1 - progress, anchor: .bottom)` 从顶端缩短。`progress` 由 `Timer.publish` 每秒推进（21分钟 = 1260步）。

**为什么不用 CAAnimation？** SwiftUI 动画与状态机天然绑定，避免两套驱动逻辑。

---

### 3. 烟雾：SpriteKit `SKEmitterNode` 嵌入 `SpriteView`

每炷香对应一个 `SKEmitterNode`，粒子参数：
- 向上漂移 + 横向随机扰动（模拟气流）
- 粒子从白色→透明，模拟烟雾消散
- 燃尽后 `particleBirthRate = 0`，存量粒子自然消散

**为什么不用 Canvas 手绘？** SpriteKit 粒子编辑器可视化调参，烟雾质感更自然，且有内置物理模拟。

---

### 4. 点燃手势：`LongPressGesture(minimumDuration: 0.8)`

触发后用 `withAnimation(.easeIn(duration: 0.3))` 依次将三根香的 `isLit` 标志置为 true，间隔 `Task.sleep(nanoseconds: 300_000_000)`。

**为什么长按而非单击？** 强化仪式感，避免误触。

---

### 5. 后台通知：`UNUserNotificationCenter`

点燃时注册一个 `timeInterval = 1260` 秒的本地通知。用户锁屏或切换 app 后仍能收到。

**边界情况**：若用户在燃烧中强制关闭 app 再重新打开，`BurnSession` 重置到 `.idle`，通知仍会在后台触发（无需处理重建状态）。

---

### 6. 跨平台布局

使用 `#if os(macOS)` 条件编译处理：
- macOS：固定窗口尺寸（`windowResizability(.contentSize)`）
- iOS/iPadOS：全屏，安全区适配

核心 View 不区分平台，布局差异通过 `ViewModifier` 隔离。

---

### 7. 心愿消散动画

燃尽后，心愿文字 `opacity` 渐变到 0，同时 `offset(y: -30)` 向上漂移，配合最后一次烟雾粒子爆发，视觉上融为一体。

## Risks / Trade-offs

- **[SpriteKit 与 SwiftUI 布局对齐]** `SpriteView` 坐标系与 SwiftUI 不同，粒子发射点需手动换算 → 用固定 frame + geometry 计算偏移量
- **[macOS 粒子性能]** 三路烟雾粒子在 macOS 低性能 Mac 上可能掉帧 → 可通过 `particleBirthRate` 动态降级
- **[通知权限拒绝]** 用户拒绝通知权限时无法提醒 → UI 上说明用途，拒绝后降级为 app 内 badge 或无提醒（不阻断主流程）

## Migration Plan

无现有用户数据，替换 `ContentView.swift` 即可，无迁移步骤。
