//
//  AEWorldContext.m
//  Aether
//
//  Created by Allen on 2025/1/1.
//

#import "AEWorldContext.h"
#import "AEScene.h"
#import "AEMesh.h"

#import <MetalKit/MetalKit.h>
#import <QuartzCore/CAMetalLayer.h>
#import "AEModel.h"

#import "AEWorldContext.h"
#import "AERenderer.h"

@interface AEWorldContext ()

@property (nonatomic, strong) AERenderer *renderer;
@property (nonatomic, strong) NSMutableArray *entities;
@property (nonatomic, strong) AECamera *mainCamera;

@end

@implementation AEWorldContext


- (instancetype)initWithRenderer:(AERenderer *)renderer {
    if ((self = [super init])) {
        _renderer = renderer;
        _entities = [[NSMutableArray alloc] init];
        _mainCamera = [[AECamera alloc] init];
        // 初始化其他世界状态
    }
    return self;
}

- (void)loadScene:(AEScene *)scene {
    self.currentScene = scene;
    NSLog(@"engine load scene: %@", scene.componentName);
    if ([scene getCamera] == NULL) {
        NSLog(@"%@ scene is not camera", scene.componentName);
    }
}

- (void)update {
    if (self.currentScene) {
        [self.currentScene update];
    } else {
        
    }
}

- (void)render {
    
    [self.renderer renderWithScene:self.currentScene];

}

@end
