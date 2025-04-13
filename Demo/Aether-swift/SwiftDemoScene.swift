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
        print("test scene Beh update")
        
        let name = getComponent().componentName
        print("test comp Beh update: ", name)
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
        comp?.position = simd_float3(0, 0, 0+posZ)
        
    }
    
}

class SwiftDemoScene: AEScene {
    override init() {
        super.init()
        self.componentName = "demoScene"
        self.setCamera(AECamera());
        
        let box = AEBoxGeometry(extent: [1.0, 1.0, 1.0], segments: [1, 1, 1], normals: false)
        box?.position = simd_float3(1.0, 1.0, 0);
        
        let mat = AEUnlitMaterial()
        
        
        let path = Bundle.main.path(forResource: "panorama_1", ofType: "png")
        mat.setTexture(path ?? "")
        
        box?.setMaterial(mat)
        
        self.addObject(box!)
        
        box?.attach(testCompBeh())
        self.attach(testBeh())
    }
}
