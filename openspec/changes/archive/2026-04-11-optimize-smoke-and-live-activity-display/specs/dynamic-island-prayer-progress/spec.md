## ADDED Requirements

### Requirement: 灵动岛展示祈愿摘要
系统 SHALL 在燃烧阶段的灵动岛和锁屏 Live Activity 中展示“正在祈祷”的简短内容摘要，并对超长内容进行截断处理。

#### Scenario: 有祈愿内容时显示摘要
- **WHEN** 用户在点香前输入了祈愿文本并进入 burning 状态
- **THEN** 灵动岛 expanded 视图与锁屏卡片 SHALL 展示祈愿摘要文本

#### Scenario: 祈愿内容超长时截断
- **WHEN** 祈愿文本超过展示长度上限
- **THEN** 系统 MUST 对摘要执行截断并以尾部省略样式展示

### Requirement: 灵动岛进度条优先展示
系统 SHALL 在燃烧阶段使用进度条作为主要状态可视化，替代倒计时文本读数。

#### Scenario: Expanded 视图展示完整进度
- **WHEN** 用户展开灵动岛
- **THEN** 系统 SHALL 展示阶段文案、祈愿摘要与可读进度条

#### Scenario: 紧凑视图使用精简进度指示
- **WHEN** 用户查看 compact 或 minimal 视图
- **THEN** 系统 SHALL 展示精简进度指示，不出现倒计时文本