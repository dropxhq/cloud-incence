## 1. 项目基础结构

- [x] 1.1 创建 `BurnState` 枚举（idle / composing / lighting / burning / complete）及 `@Observable BurnSession` 类，包含 `state`、`prayerText`、`startDate`、`progress` 属性
- [x] 1.2 在 `cloud_incenseApp.swift` 中将 `BurnSession` 注入环境（`.environment`），并在 macOS 上设置固定窗口尺寸（`windowResizability(.contentSize)`）
- [x] 1.3 替换 `ContentView.swift`，作为状态机路由容器，根据 `BurnState` 切换显示各子 View

## 2. 香案场景（incense-scene）

- [x] 2.1 创建 `IncenseSceneView.swift`：深色渐变背景（近黑到深棕）
- [x] 2.2 实现 `IncenseStickShape`（SwiftUI Shape）：矩形香棒，支持通过 `progress` 参数控制从顶端缩短（`scaleEffect(y:anchor:)`）
- [x] 2.3 实现 `IncenseHolderView`：香台底座（横条 + 圆形插口），三炷香居中排布，中间比两侧高 20pt
- [x] 2.4 创建 `IncenseCanvasView.swift`：组合背景、三炷香棒、香台，接受 `BurnSession` 驱动高度变化

## 3. 烟雾粒子（burning-animation）

- [x] 3.1 在 Xcode 中创建 `SmokeParticle.sks` SpriteKit 粒子文件：白色→透明，向上漂移，横向随机扰动（birthRate=8，lifetime=4s）
- [x] 3.2 创建 `SmokeEmitterNode` 封装：加载 `SmokeParticle.sks`，提供 `start()` / `stop()` 方法控制 `particleBirthRate`
- [x] 3.3 创建 `IncenseSmokeView.swift`（`SpriteView` 包装）：三个 `SmokeEmitterNode` 对应三炷香，位置与 `IncenseCanvasView` 中香棒顶端对齐
- [x] 3.4 实现后台/前台切换时的进度恢复：`scenePhase` 监听，返回前台时用 `Date()` 差值更新 `progress`

## 4. 心愿输入（prayer-input）

- [x] 4.1 创建 `PrayerInputView.swift`：香案下方"点此写下心愿"提示文字，点击进入 composing 状态
- [x] 4.2 实现文本输入框（`TextEditor` 或 `TextField`），composing 状态下显示，自动 focus，点击外部收起键盘
- [x] 4.3 心愿文字在 burning/complete 状态下以半透明方式展示在香棒下方

## 5. 点燃交互（ignition-interaction）

- [x] 5.1 在 `IncenseCanvasView` 中间香棒上添加 `LongPressGesture(minimumDuration: 0.8)`
- [x] 5.2 实现 `BurnSession.ignite()` 方法：cutting lighting 状态，用 `Task` + `sleep(nanoseconds:)` 依次将三炷 `isLit` 置为 true（间隔 300ms），触发粒子启动
- [x] 5.3 lighting 状态下禁用长按手势（`.disabled` 或 guard 检查）

## 6. 燃烧计时与通知（burn-timer）

- [x] 6.1 实现 `BurnSession.startBurning()`：记录 `startDate = Date()`，启动 `Timer.publish(every: 1, on: .main)` 推进 `progress`
- [x] 6.2 实现 `NotificationService`：请求通知权限，注册 `UNTimeIntervalNotificationTrigger(timeInterval: 1260)` 本地通知
- [x] 6.3 计时到达时（`progress >= 1.0`）停止 Timer，进入 complete 状态

## 7. 完成体验（completion-experience）

- [x] 7.1 创建 `CompletionView.swift`：心愿文字消散动画（`opacity` 0→0 + `offset(y: -30)`，duration 2s）
- [x] 7.2 实现粒子熄灭：complete 状态设置三路 `SmokeEmitterNode.stop()`，存量粒子自然消散
- [x] 7.3 文字消散后淡入祝语（"愿您所愿，皆得圆满"）及"再次祈祷"按钮
- [x] 7.4 实现 `BurnSession.reset()`：取消待发通知（`UNUserNotificationCenter.removePending`），重置所有状态到 idle

## 8. 收尾与适配

- [x] 8.1 在 `Info.plist` 添加通知权限描述字符串（`NSUserNotificationUsageDescription`）
- [x] 8.2 macOS 条件编译：`#if os(macOS)` 处理窗口尺寸与键盘收起差异
- [x] 8.3 在 iPhone / iPad 模拟器上走一遍完整流程（idle→composing→lighting→burning→complete），修复布局问题
- [x] 8.4 在 macOS 上验证 SpriteKit `SpriteView` 正常渲染粒子效果
