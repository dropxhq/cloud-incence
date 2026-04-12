## MODIFIED Requirements

### Requirement: 退出输入状态
用户 SHALL 能通过点击键盘收起按钮或点击输入区外部来收起键盘，回到 idle 场景。若当前心愿文本非空，idle 场景 SHALL 保留并展示该文本，不得仅显示占位提示。

#### Scenario: 点击外部收起键盘
- **WHEN** 键盘处于弹出状态，用户点击输入框以外区域
- **THEN** 键盘收起，输入的心愿文字保留显示

#### Scenario: 非空心愿回到 idle 仍可见
- **WHEN** 用户已输入心愿并退出输入状态回到 idle
- **THEN** 界面 SHALL 展示已输入心愿文本，且文本内容与 composing 阶段保持一致
