# metronomelutter

操起吉他熟练地 53231323,然后发现市面上竟然没有一个干净无广告的节拍器?好吧那只能自己写一个了.

基于 flutter 技术打造的极简全平台(包括 web)节拍器,目前只是初版,后续把功能完善.

不会弃坑,把这个项目列入 2021 年度计划.

![preview](./screenshot/preview.png)
# TODO
- 高 bpm 声音准确性?
- 样式修改,优化 SliderRow 不跟手
- 拍号
- 暗黑模式
- iOS App Clip
- 动画优化

# 运行

flutter pub get

flutter run

flutter build apk && start build\app\outputs\apk\release

## 修改 mobx 文件,开启监听自动生成 .g 文件
flutter packages pub run build_runner watch --delete-conflicting-outputs

# 常见问题

## AnimationController : The named parameter 'vsync' isn't defined. 

https://github.com/flutter/flutter/issues/63486

The "required" 漏了 @ 注解

执行 flutter clean 可解
