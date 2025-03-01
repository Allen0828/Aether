//
//  ViewController.swift
//  Aether-swift
//
//  Created by Allen on 2025/2/16.
//

import UIKit

class ViewController: UIViewController {

    private let mLayer : CAMetalLayer = CAMetalLayer()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.red
        
        let test = Bundle.main.path(forResource: "texture.png", ofType: nil);
        print(test)
        
        
        mLayer.frame = self.view.layer.frame;
        mLayer.backgroundColor = UIColor.green.cgColor;
        self.view.layer.addSublayer(mLayer);
        
        
        TestLog.show();
        let engine = AEEngine(layer: mLayer)
        engine?.createEngineLoopContext()
        let context = engine?.getRuntimeContext()
        
        context?.load(DemoScene())
    }


}

