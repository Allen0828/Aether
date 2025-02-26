//
//  DemoScene.swift
//  Aether-swift
//
//  Created by Allen on 2025/2/18.
//

import UIKit

class testBeh: AEBehaviour {
    
    override init() {
        super.init()
    }
    
    override func update() {
        print("test scene Beh update")
    }
    
}

class testCompBeh: AEBehaviour {
    
    override init() {
        super.init()
    }
    
    override func update() {
        //getComponent()
        print("test comp Beh update")
    }
    
}

class DemoScene: AEScene {
    override init() {
        super.init()
        self.componentName = "demoScene"
        self.setCamera(AECamera());
        
        let box = AEBoxGeometry(extent: [1.0, 1.0, 1.0], segments: [1, 1, 1], normals: false)
        box?.position = simd_float3(1.0, 1.0, 0);
        
        self.addObject(box!)
        
        box?.attach(testCompBeh())
        self.attach(testBeh())
    }
}
