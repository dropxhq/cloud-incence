## MODIFIED Requirements

### Requirement: 点香后发布 Live Activity
系统 SHALL 在点香成功进入燃烧阶段后发布 Live Activity，用于持续展示燃烧状态，并携带用于进度展示的时间基准信息与祈愿摘要信息。

#### Scenario: 点香成功后开启状态展示
- **WHEN** 用户完成点香并进入 burning 状态
- **THEN** 系统 SHALL 启动对应 Live Activity 实例

#### Scenario: 状态载荷包含进度与祈愿摘要字段
- **WHEN** Live Activity 被创建或更新
- **THEN** 状态数据 MUST 包含可推导燃烧进度的时间基准字段，并 SHALL 包含可展示的祈愿摘要字段（可为空）

### Requirement: 灵动岛/锁屏展示剩余时间与阶段
系统 SHALL 在 Live Activity 中展示当前阶段与燃烧进度；在支持灵动岛的设备上可在灵动岛显示，在其他支持设备上至少在锁屏可见。该展示 MUST 使用进度条语义，不显示倒计时文本。

#### Scenario: 过程状态持续更新
- **WHEN** 燃烧进度按时间推进
- **THEN** Live Activity 的阶段与进度信息 SHALL 同步更新

#### Scenario: 灵动岛移除倒计时文本
- **WHEN** 用户查看灵动岛 compact 或 expanded 视图
- **THEN** 系统 MUST 不显示倒计时文本，且 SHALL 提供进度条或等价进度指示