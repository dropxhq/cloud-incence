## ADDED Requirements

### Requirement: First-launch onboarding detection
应用 SHALL 在每次冷启动时检查 `hasCompletedOnboarding`（`@AppStorage` / `UserDefaults`）。若值为 `false`（或键不存在），SHALL 展示 `OnboardingView`；若为 `true`，SHALL 直接展示 `ContentView`。

#### Scenario: First launch shows onboarding
- **WHEN** 用户首次安装并打开应用（`hasCompletedOnboarding` 不存在或为 false）
- **THEN** 应用展示 `OnboardingView` 全屏引导界面

#### Scenario: Subsequent launch skips onboarding
- **WHEN** 用户再次打开应用（`hasCompletedOnboarding` 为 true）
- **THEN** 应用直接展示 `ContentView`，不显示任何引导

### Requirement: Multi-step onboarding cards
`OnboardingView` SHALL 以分步卡片方式（`TabView` + page style）展示至少 3 步引导内容，每步包含图示区域、标题和说明文字。

#### Scenario: User swipes through all steps
- **WHEN** 用户在 `OnboardingView` 中向左滑动或点击「下一步」
- **THEN** 界面切换到下一张卡片，底部指示点相应高亮

#### Scenario: Last step shows start button
- **WHEN** 用户到达最后一张引导卡片
- **THEN** 底部显示「开始」按钮（替代「下一步」）

### Requirement: Onboarding completion and persistence
用户点击最后一步的「开始」按钮后，系统 SHALL 将 `hasCompletedOnboarding` 设置为 `true` 并切换至 `ContentView`，且此后任何重启均不再展示引导。

#### Scenario: Tapping start completes onboarding
- **WHEN** 用户在最后一步点击「开始」
- **THEN** `hasCompletedOnboarding` 写入 `true`，界面切换至 `ContentView`

#### Scenario: Onboarding state persists across launches
- **WHEN** 用户完成引导后退出并重新打开应用
- **THEN** `hasCompletedOnboarding` 仍为 `true`，引导不再出现

### Requirement: Visual style consistency
`OnboardingView` SHALL 遵循项目 UI 风格规范：纯黑背景（`Color.black`）、白色描边 + 多层 `.shadow` 模拟发光，字体使用系统字体，无任何暖色调。

#### Scenario: Onboarding renders on black background
- **WHEN** `OnboardingView` 展示
- **THEN** 背景为纯黑（`Color.black`），所有文字和图形为白色或低透明度白色，不出现暖色元素

### Requirement: Localization support
引导界面所有用户可见文字 SHALL 通过字符串本地化支持以下语言：English、简体中文、繁体中文、日本語、한국어，与现有本地化架构保持一致。

#### Scenario: Onboarding displays in system language
- **WHEN** 设备系统语言为受支持语言（en / zh-Hans / zh-Hant / ja / ko）
- **THEN** 引导界面所有文字以对应语言显示
