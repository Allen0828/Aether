//
//  DemoScene.swift
//  Aether-swift
//
//  Created by Allen on 2025/2/18.
//

import UIKit

class DemoScene: AEScene {
    override init() {
        super.init()
        self.componentName = "demoScene"
        self.setCamera(AECamera());
    }
}
