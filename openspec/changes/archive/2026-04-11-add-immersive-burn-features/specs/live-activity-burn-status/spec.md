## ADDED Requirements

### Requirement: 点香后发布 Live Activity
系统 SHALL 在点香成功进入燃烧阶段后发布 Live Activity，用于持续展示燃烧状态。

#### Scenario: 点香成功后开启状态展示
- **WHEN** 用户完成点香并进入 burning 状态
- **THEN** 系统 SHALL 启动对应 Live Activity 实例

### Requirement: 灵动岛/锁屏展示剩余时间与阶段
系统 SHALL 在 Live Activity 中展示当前阶段与剩余时间；在支持灵动岛的设备上可在灵动岛显示，在其他支持设备上至少在锁屏可见。

#### Scenario: 过程状态持续更新
- **WHEN** 燃烧进度按时间推进
- **THEN** Live Activity 的剩余时间与阶段信息 SHALL 同步更新

### Requirement: 完成或重置后结束展示
系统 SHALL 在燃烧完成或用户手动重置时结束 Live Activity，避免过期状态残留。

#### Scenario: 完成态自动结束
- **WHEN** 系统进入 complete 状态
- **THEN** 当前 Live Activity SHALL 被结束或切换至完成态并短时后结束

#### Scenario: 重置时立即结束
- **WHEN** 用户触发再次祈祷并重置会话
- **THEN** 当前 Live Activity SHALL 立即终止并清理状态

### Requirement: 不支持 Live Activity 的降级处理
系统 MUST 在不支持 Live Activity 的设备保持主流程可用，并提供应用内状态提示作为降级方案。

#### Scenario: 能力不可用时降级
- **WHEN** 设备或系统版本不支持 Live Activity
- **THEN** 应用 SHALL 正常点香和计时，不因能力缺失中断流程
