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
        box?.position = simd_float3(0.01, 0.05, 0.01);
        
        let mat = AEUnlitMaterial()
        // Resources/bricks@2x.png
        
        let path = Bundle.main.path(forResource: "texture.png", ofType: "")
        print("img path:", path ?? "")
        mat.setTexture(path ?? "")
        box?.setMaterial(mat)
        self.addObject(box!)
        
        let box1 = AEBoxGeometry(extent: [1.0, 1.0, 1.0], segments: [1, 1, 1], normals: false)
        box1?.position = simd_float3(0.0, -0.04, 0.0);
        let stand = AEStandardMaterial()
        stand.setTexture(path ?? "")
        box1?.setMaterial(stand)
       
        self.addObject(box1!)
        
        box?.attach(testCompBeh())
        self.attach(testBeh())
        
    
        
        let light = AELight()
        light?.componentName = "light"
        light?.lightType = DirectionalLight
        light?.position = simd_make_float3(3, 3, -2)
        light?.diffuse = LightColor(r: 1, g: 1, b: 1)
        light?.specular = LightColor(r: 0.6, g: 0.6, b: 0.6)
        
        self.addObject(light!)
        
//        light.position = simd_make_float3(3, 3, -2);
//        light.color = simd_make_float3(1, 1, 1);
//        light.specularColor = simd_make_float3(0.6, 0.6, 0.6);
//        light.intensity = 1;
//        light.attenuation = simd_make_float3(1, 0, 0);
//        light.type = SunLight;
        
    }
}
