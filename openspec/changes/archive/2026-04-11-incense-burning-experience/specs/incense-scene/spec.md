## ADDED Requirements

### Requirement: 主场景初始渲染
应用启动后 SHALL 展示香案场景：深色背景（近黑色渐变）、三炷未燃立香（中间略高于两侧）、香台底座。场景 SHALL 在 iOS、iPadOS、macOS 上均正常显示，无布局溢出。

#### Scenario: 初次启动显示香案
- **WHEN** 用户首次打开应用
- **THEN** 屏幕中央显示三炷未燃立香与香台，背景为深色渐变，无任何烟雾粒子

#### Scenario: 三炷香高度排布
- **WHEN** 场景渲染完成
- **THEN** 中间香棒高度大于左右两侧香棒高度，符合传统插香习惯

### Requirement: 跨平台布局适配
场景 SHALL 在 iOS 全屏、iPadOS 全屏、macOS 固定窗口三种尺寸下保持视觉比例一致，香台居中且不被系统 UI 元素遮挡。

#### Scenario: macOS 窗口固定尺寸
- **WHEN** 应用运行在 macOS
- **THEN** 窗口使用固定内容尺寸，用户无法将窗口缩至香案变形的尺寸

#### Scenario: iOS 安全区适配
- **WHEN** 应用运行在带刘海/动态岛的 iPhone
- **THEN** 香案场景内容不被状态栏或 Home Indicator 遮挡
