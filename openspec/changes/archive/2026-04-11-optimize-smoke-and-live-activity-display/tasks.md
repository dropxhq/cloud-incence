## 1. 倾斜输入与坐标归一化

- [x] 1.1 在 `TiltManager` 增加设备方向感知，并将姿态/重力数据映射为屏幕坐标系输入
- [x] 1.2 为 portrait、landscapeLeft、landscapeRight 建立并验证方向映射表
- [x] 1.3 增加平滑与钳制参数，确保输出连续且可配置

## 2. 烟雾受力模型重构

- [x] 2.1 在 `SmokeScene` 将受力改为"向上主导 + 横向扰动"，设置向上分量下限
- [x] 2.2 收敛发射角偏移范围，避免大角度导致视觉下坠
- [x] 2.3 补充横屏场景下左/右倾斜的可视回归检查点

## 3. Live Activity 数据模型扩展

- [x] 3.1 扩展 `BurnActivityAttributes.ContentState` 以承载进度基准字段与祈愿摘要字段
- [x] 3.2 在 `BurnActivityService` 启动/更新逻辑中填充并同步新字段
- [x] 3.3 统一主 App 与 Widget Extension 的共享模型定义，避免字段漂移

## 4. 灵动岛与锁屏展示优化

- [x] 4.1 在 Live Activity UI 中移除倒计时文本展示
- [x] 4.2 为 expanded/lock screen 视图接入进度条展示与阶段文案
- [x] 4.3 在 expanded/lock screen 展示祈愿摘要，并实现超长文本截断策略
- [x] 4.4 为 compact/minimal 视图提供精简进度指示，保持可读性

## 5. 验证与收尾

- [x] 5.1 在支持与不支持 Live Activity/传感器的设备上执行降级验证
- [x] 5.2 完成横竖屏与前后台切换回归，确认状态同步与电量影响可接受
- [x] 5.3 更新相关说明文档与变更记录，准备进入 `/opsx:apply`