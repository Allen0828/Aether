# Aether 库说明文档

Aether 库基于 Metal 框架开发，专为高效图形渲染和计算任务打造，充分发挥 GPU 并行计算能力，旨在为开发者提供一套简洁、易用且高性能的工具集，以应对诸如游戏开发、虚拟现实、科学计算可视化等对图形处理和计算性能要求严苛的应用场景。

[English Document](https://github.com/Allen0828/AAEngine/blob/master/README_EN.md)


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
engine.createEngineLoopContext()

let context = engine.getRuntimeContext()
context.load(DemoScene())    // demo scene 在仓库中内置

```

##### 2 为组件添加 Behaviour
```swift
class testCompBeh: AEBehaviour {
    
    private var posZ: Float = 0.0
    
    override init() {
        super.init()
    }
    
    override func update() {
        posZ += 0.001
        let comp = getComponent()
        comp?.position = simd_float3(0, 0, 0+posZ)
        
    }
}

class SwiftDemoScene: AEScene {
    override init() {
        super.init()
        // ...
        let box1 = AEBoxGeometry(extent: [1.0, 1.0, 1.0], segments: [1, 1, 1], normals: false)
        box1.position = simd_float3(0.0, -0.04, 0.0);
        self.addChildComponent(box1)
        box.attach(testCompBeh())
        // ...
    }
}

```

##### 3 材质
```swift
let unlit = AEUnlitMaterial()
let path = Bundle.main.path(forResource: "texture.png", ofType: "")
mat.setTexture(path ?? "")

box1.setMaterial(unlit)

let standard = AEStandardMaterial()
standard.setTexture(path ?? "")

box2.setMaterial(standard)

```

##### 4 灯光
```swift
let light = AELight()
light?.componentName = "light"
light?.lightType = DirectionalLight
light?.position = simd_make_float3(3, 3, -2)
light?.diffuse = LightColor(r: 1, g: 1, b: 1)
light?.specular = LightColor(r: 0.6, g: 0.6, b: 0.6)
        
self.addChildComponent(light!)
```



## 展示全景地图
<view><img src="https://github.com/Allen0828/AAEngine/blob/main/images/img_01.jpg" width="400"></img><img src="https://github.com/Allen0828/AAEngine/blob/main/images/img_02.jpg" width="400"></img>
</view>

请参考demo中代码进行设置，如果只是加载全景地图，请对相机的位移增加限制。
