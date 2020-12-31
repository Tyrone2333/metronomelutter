# metronomelutter

基于 flutter 技术打造的极简全平台节拍器,目前只是初版,后续把功能完善.

不会弃坑,把这个项目列入 2021 年度计划

# TODO
- 样式修改
- 节拍
- 暗黑模式
- iOS App Clip
- 动画优化

# 常见问题

## AnimationController : The named parameter 'vsync' isn't defined. 

https://github.com/flutter/flutter/issues/63486

The "required" 漏了 @ 注解

执行 flutter clean 可解
