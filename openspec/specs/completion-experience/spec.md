## ADDED Requirements

### Requirement: 心愿文字消散动画
燃尽时 SHALL 触发心愿文字消散动画：文字透明度渐变至 0，同时向上漂移约 30pt，与最后一缕烟雾粒子在视觉上融为一体，整体动画时长约 2 秒。

#### Scenario: 文字随烟消散
- **WHEN** 进入 complete 状态
- **THEN** 心愿文字以淡出 + 上飘动画消失，仿佛随烟雾升天

#### Scenario: 空心愿跳过文字动画
- **WHEN** 用户未填写心愿，燃烧结束
- **THEN** 跳过文字消散阶段，直接进入结束祝语显示

### Requirement: 烟雾熄灭动画
complete 状态下三炷香的粒子发射器 SHALL 停止发射新粒子（`particleBirthRate = 0`），已有粒子自然消散，消散时间约 3 秒。

#### Scenario: 粒子自然消散
- **WHEN** 进入 complete 状态
- **THEN** 三路烟雾粒子停止新增，存量粒子在 3 秒内自然飘散消失

### Requirement: 结束祝语展示
文字与烟雾消散后 SHALL 淡入一行祝语（如"愿您所愿，皆得圆满"），祝语 SHALL 停留至用户主动操作。

#### Scenario: 祝语淡入
- **WHEN** 心愿文字消散动画完成后
- **THEN** 祝语文字以 1 秒淡入动画出现在屏幕中央

### Requirement: 再次祈祷入口
complete 状态 SHALL 在祝语下方展示"再次祈祷"按钮，点击后重置全部状态至 idle，场景恢复三炷未燃立香。

#### Scenario: 再次祈祷重置场景
- **WHEN** 用户点击"再次祈祷"
- **THEN** 状态重置为 idle，香棒恢复原始长度，烟雾粒子清空，心愿输入框清空
