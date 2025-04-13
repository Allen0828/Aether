# Aether 库说明文档

Aether 库基于 Metal 框架开发，专为高效图形渲染和计算任务打造，充分发挥 GPU 并行计算能力，旨在为开发者提供一套简洁、易用且高性能的工具集，以应对诸如游戏开发、虚拟现实、科学计算可视化等对图形处理和计算性能要求严苛的应用场景。

[English Document](https://github.com/Allen0828/AAEngine/blob/master/README_EN.md)


## Features
- [x] 光照
- [x] 基础材质
- [x] 法线
- [x] 纹理
- [ ] 阴影
- [ ] 粒子
- [ ] PBR
- [ ] 动画
- [ ] gLTF


## 使用方式
#### Swift Package Manager  推荐

- File > Swift Packages > Add Package Dependency
- Add `https://github.com/Allen0828/AAEngine.git`
- Select "Up to Next Major" with "0.0.5"

#### CocoaPods

```ruby
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '12.0'
use_frameworks!

target 'MyApp' do
  pod 'AAEngine', '~> 0.0.3'
end
```
#### 手动安装
下载仓库，将Aether文件夹放到工程中，即可运行。


#### 使用示例
##### 1 简单图形渲染
初始化 Aether 环境
```swift

let mLayer = CAMetalLayer()
mLayer.frame = self.view.layer.frame
self.view.layer.addSublayer(mLayer)

let engine = AEEngine(layer: mLayer)
engine?.createEngineLoopContext()

let context = engine?.getRuntimeContext()
context?.load(DemoScene())    // demo scene 在仓库中内置

```




## 展示全景地图
<view><img src="https://github.com/Allen0828/AAEngine/blob/main/images/img_01.jpg" width="400"></img><img src="https://github.com/Allen0828/AAEngine/blob/main/images/img_02.jpg" width="400"></img>
</view>

请参考demo中代码进行设置，如果只是加载全景地图，请对相机的位移增加限制。
