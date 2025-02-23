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

