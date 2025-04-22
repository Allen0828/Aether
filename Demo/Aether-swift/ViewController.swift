//
//  ViewController.swift
//  Aether-swift
//
//  Created by Allen on 2025/2/16.
//


//#if TARGET_OS_IOS
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
        
        context?.load(SwiftDemoScene())
        
        let path = Bundle.main.path(forResource: "texture.png", ofType: "")
        
        let img = UIImageView(image: UIImage(contentsOfFile: path!)!) // UIImage(named: "bricks")!
        img.frame = CGRect(x: 0, y: 0, width: 300, height: 300)
        //self.view.addSubview(img)
    }


}

//#endif


#if TARGET_OS_OSX

import Cocoa


class ViewController: NSViewController {

    private let mLayer : CAMetalLayer = CAMetalLayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let sceneView = NSView(frame: NSRect(x: 0, y: 0, width: 300, height: 300))
        
        self.view.addSubview(sceneView)
        

        mLayer.frame = CGRect(x: 0, y: 0, width: 300, height: 300)
        mLayer.backgroundColor = CGColor(red: 1, green: 0.5, blue: 0.5, alpha: 1)
        sceneView.layer = mLayer
        
        
        let engine = AEEngine(layer: mLayer)
        engine?.createEngineLoopContext()
        
        let context = engine?.getRuntimeContext()
        context?.load(SwiftDemoScene())
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
}

#endif

