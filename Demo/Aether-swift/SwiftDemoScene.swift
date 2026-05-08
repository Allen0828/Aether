//
//  DemoScene.swift
//  Aether-swift
//
//  Created by Allen on 2025/2/18.
//



class testBeh: AEBehaviour {
    
    override init() {
        super.init()
    }
    
    override func update() {
        //print("test scene Beh update")
        
        let name = getComponent().componentName
        //print("test comp Beh update: ", name)
    }
    
}

class testCompBeh: AEBehaviour {
    
    private var posZ: Float = 0.0
    
    override init() {
        super.init()
    }
    
    override func update() {
        //getComponent()
        posZ += 0.001
        let comp = getComponent()
        //comp?.position = simd_float3(0, 0, 0+posZ)
        
    }
}

class SwiftDemoScene: AEScene {
    override init() {
        super.init()
        self.componentName = "demoScene"
        self.setCamera(AECamera())
        
        let box = AEBoxGeometry(extent: [1.0, 1.0, 1.0], segments: [1, 1, 1], normals: false)
        box.position = simd_float3(0.01, 0.05, 0.01);
        
        let mat = AEUnlitMaterial()
        // Resources/bricks@2x.png
        
        let path = Bundle.main.path(forResource: "texture.png", ofType: "")
        print("img path:", path ?? "")
        mat.setTexture(path ?? "")

        // Demo: also load via AEResourceManager (cached, async)
        if let p = path {
            AEResourceManager.shared().loadTexture(atPath: p) { tex, err in
                if let e = err {
                    print("AEResourceManager load error:", e.localizedDescription)
                } else {
                    print("AEResourceManager loaded texture:", tex as Any)
                }
            }
        }
        box.setMaterial(mat)
        self.addChildComponent(box)
//        self.addObject(box!)
        
        let box1 = AEBoxGeometry(extent: [1.0, 1.0, 1.0], segments: [1, 1, 1], normals: false)
        box1.position = simd_float3(0.0, -0.04, 0.0);
        let stand = AEStandardMaterial()
        stand.setTexture(path ?? "")
        box1.setMaterial(stand)

        //self.addChildComponent(box1)
        box.attach(testCompBeh())
        self.attach(testBeh())
        
    
        
        let light = AELight()
        light?.componentName = "light"
        light?.lightType = DirectionalLight
        light?.position = simd_make_float3(3, 3, -2)
        light?.diffuse = LightColor(r: 1, g: 1, b: 1)
        light?.specular = LightColor(r: 0.6, g: 0.6, b: 0.6)
        
        self.addChildComponent(light!)

        // Instancing demo: create a grid of instance transforms and attach as instance buffer to `box`
        if let device = AEEngine.device() as? MTLDevice {
            let cols = 10
            let rows = 10
            var mats: [matrix_float4x4] = []
            mats.reserveCapacity(cols * rows)
            for i in 0..<cols {
                for j in 0..<rows {
                    let tx = Float(i) * 0.2 - Float(cols) * 0.1
                    let tz = Float(j) * 0.2 - Float(rows) * 0.1
                    var model = matrix_identity_float4x4
                    model.columns.3 = SIMD4<Float>(tx, 0.0, tz, 1.0)
                    mats.append(model)
                }
            }
            let dataSize = mats.count * MemoryLayout<matrix_float4x4>.stride
            let buffer = device.makeBuffer(bytes: mats, length: dataSize, options: [])
            if let buf = buffer {
                box.setInstanceBuffer(buf, instanceCount: UInt(mats.count))
                print("Instancing buffer set, instances:", mats.count)
            }
        }

        // glTF demo: if a model.gltf exists in bundle, load and add it to scene
        if let modelPath = Bundle.main.path(forResource: "Box", ofType: "gltf") {
            var loadErr: NSError?
            let loader = AEGltfLoader()
          
            if let mesh = try? loader.loadMeshFromGLTF(atPath: modelPath) {
                let geom = AEGeometry()
                geom?.setMeshData(mesh)
                let gmat = AEUnlitMaterial()
                geom?.setMaterial(gmat)
                geom?.position = simd_float3(0.0, -0.04, 0.0);
                self.addChildComponent(geom)
                print("Loaded glTF mesh and added to scene")
            } else {
                if let e = loadErr { print("gltf load error:", e.localizedDescription) }
            }
        } else {
            print("Box is not find")
        }
        
    }
}
