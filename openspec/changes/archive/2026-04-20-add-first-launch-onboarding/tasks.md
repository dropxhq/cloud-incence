## 1. 引导状态持久化

- [x] 1.1 在 `cloud_incenseApp.swift` 中添加 `@AppStorage("hasCompletedOnboarding") var hasCompletedOnboarding: Bool = false`
- [x] 1.2 在 `WindowGroup` body 中根据 `hasCompletedOnboarding` 条件渲染 `OnboardingView` 或 `ContentView`

## 2. OnboardingView 核心结构

- [x] 2.1 新建 `cloud-incense/OnboardingView.swift`，定义 `OnboardingView` 结构体，接收 `onComplete: () -> Void` 回调
- [x] 2.2 定义引导步骤数据模型 `OnboardingStep`（含 symbolName/imageName、标题、说明文字字段）
- [x] 2.3 创建 3 个引导步骤的静态数据：欢迎页、写下祈祷、点燃与冥想
- [x] 2.4 使用 `TabView(selection:)` + `.tabViewStyle(.page(indexDisplayMode: .never))` 实现分步翻页

## 3. OnboardingView UI 细节

- [x] 3.1 实现纯黑背景（`Color.black.ignoresSafeArea()`）
- [x] 3.2 实现底部自定义指示点（白色小圆点，当前步高亮放大）
- [x] 3.3 末步之前显示「下一步」按钮，末步显示「开始」按钮，按钮使用白色描边 + 发光 `.shadow` 风格
- [x] 3.4 「开始」按钮点击时调用 `onComplete()`，在 App 入口将 `hasCompletedOnboarding` 置 `true`

## 4. 本地化

- [x] 4.1 在 `cloud-incense/en.lproj/` 新建或追加 `Localizable.strings`，添加引导文案的英文键值
- [x] 4.2 在 `zh-Hans.lproj/`、`zh-Hant.lproj/`、`ja.lproj/`、`ko.lproj/` 对应添加各语言翻译
- [x] 4.3 在 `OnboardingView.swift` 中所有用户可见字符串改用 `String(localized:)` 或 `LocalizedStringKey`

## 5. Xcode 项目集成

- [x] 5.1 在 `cloud-incense.xcodeproj` 中将 `OnboardingView.swift` 添加到 `cloud-incense` Target
- [x] 5.2 若新增了 `Localizable.strings` 文件，确保各语言文件均已添加至 Target 的 Build Phases → Copy Bundle Resources

## 6. 验证

- [ ] 6.1 模拟器首次启动：清除 App Data 后确认引导界面正常出现
- [ ] 6.2 走完引导后重启应用，确认直接进入主界面（引导不再出现）
- [ ] 6.3 切换系统语言为 zh-Hans / zh-Hant / ja / ko，确认引导文案正确显示
- [ ] 6.4 在 macOS 和 visionOS 目标上验证引导界面渲染无异常
