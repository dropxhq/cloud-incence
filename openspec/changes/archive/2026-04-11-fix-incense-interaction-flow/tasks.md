## 1. 输入态保留展示修复

- [x] 1.1 调整 `PrayerInputView` 的 idle 渲染逻辑：`prayerText` 非空时显示心愿文本，空值时显示占位按钮
- [x] 1.2 保持 idle -> composing 的现有进入方式，并验证非空文本状态下仍可重新进入编辑
- [x] 1.3 增加退出输入回归检查：点击外部收起后文本保持可见且内容不变

## 2. 完成态空心愿节奏修复

- [x] 2.1 调整 `CompletionView` 的 `onAppear` 时序为双分支：空心愿直接祝语淡入，非空心愿保留 2 秒消散流程
- [x] 2.2 验证空心愿场景无额外空白等待，完成态进入后即出现祝语淡入
- [x] 2.3 验证非空心愿场景维持原有文字消散体验并在结束后展示祝语

## 3. 烟雾与香棒几何一致性修复

- [x] 3.1 统一 `IncenseCanvasView` 与 `SmokeScene` 的布局常量来源（或注入同值参数）
- [x] 3.2 校准并验证三路烟雾发射点在不同燃烧进度下持续贴合香棒顶端
- [x] 3.3 在完成态确认 `extinguishAll` 后粒子仅自然消散，不出现定位跳变

## 4. 输入焦点一致性修复

- [x] 4.1 在 composing -> idle 的外部点击退出路径中显式收起输入焦点
- [x] 4.2 验证 iOS 与 macOS 下键盘/焦点行为一致，不出现残留焦点或无法再次聚焦

## 5. 回归验证与收尾

- [x] 5.1 按流程执行回归：idle -> composing -> lighting -> burning -> complete -> reset
- [x] 5.2 对照变更 specs 验证三个修改能力（prayer-input、completion-experience、burning-animation）全部满足
- [x] 5.3 更新 OpenSpec 任务状态并准备进入 `/opsx:apply` 实施
