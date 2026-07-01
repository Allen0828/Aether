# Aether — Lightweight iOS glTF Viewer

Aether is a minimal Metal-based iOS library for loading a `.gltf` model and showing it quickly inside an app. The fastest path is `AEModelView`, a drop-in `UIView` that owns the Metal layer, render loop, glTF loader, camera, orbit gesture, and pinch zoom.

## Quick Start

1. Add the `Aether/` source folder to your iOS app target.
2. Add `Aether/Shaders/Basic.metal` to the app target sources.
3. Add your `.gltf` file and its external `.bin` buffer to the app bundle.
4. If your app is Swift, import Aether headers in your bridging header:

```objc
#import "Aether.h"
```

Then add a model view anywhere in UIKit:

```swift
import UIKit

final class ViewController: UIViewController {
    private let modelView = AEModelView()

    override func viewDidLoad() {
        super.viewDidLoad()

        modelView.frame = view.bounds
        modelView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(modelView)

        do {
            try modelView.loadModel(named: "Box", in: .main)
        } catch {
            print("glTF error: \(error)")
        }
    }
}
```

`AEModelView` starts rendering automatically when it is attached to a window and stops when it is removed. Users can drag to orbit and pinch to zoom.

## Lower-Level API

If you need to control the Metal layer yourself, use `AEEngine`, `AECamera`, and `AEGltfLoader` directly:

```swift
let engine = AEEngine(layer: metalLayer)
engine.renderer.camera = AECamera(position: simd_float3(3, 2, 5),
                                  target: simd_float3(0, 0, 0))

let path = Bundle.main.path(forResource: "model", ofType: "gltf")!
engine.model = try AEGltfLoader().loadMeshFromGLTF(atPath: path)
engine.start(withFPS: 60)
```

## Supported glTF Scope

- glTF 2.0 `.gltf` files with an external `.bin` buffer
- First mesh, first primitive
- `POSITION`, `NORMAL`, and `TEXCOORD_0` vertex attributes
- `FLOAT` vertex attributes and `UNSIGNED_SHORT` indices
- Single draw-call rendering with a built-in Metal shader

## Architecture

```
Aether/
├── Core/
│   ├── AEEngine.h/m       — Engine setup & render loop
│   ├── AECamera.h/m       — Camera (orbit, zoom, pan via touch)
│   └── AERenderer.h/m     — Metal renderer
├── Model/
│   ├── AEMesh.h/m         — Vertex/index buffer container
│   └── AEGltfLoader.h/m   — glTF 2.0 (.gltf + .bin) loader
├── Material/
│   └── AEMaterial.h/m     — Texture & base color
├── Math/
│   └── AEMath.h/m         — Matrix & vector utilities
└── Shaders/
    └── Basic.metal         — Vertex & fragment shaders
```

## Features

- Drop-in `AEModelView` for UIKit apps
- Metal rendering with single draw call
- Orbit camera and pinch zoom
- Small Objective-C API that is callable from Swift

## License

MIT
