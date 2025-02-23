//
//  AEWorldContext.h
//  Aether
//
//  Created by Allen on 2025/1/1.
//

#import <Foundation/Foundation.h>
#import <Metal/Metal.h>
#import "AEScene.h"

@class AERenderer;

@interface AEWorldContext : NSObject

@property (nonatomic, strong) AEScene *currentScene;


- (instancetype)initWithRenderer:(AERenderer *)renderer;

- (void)loadScene:(AEScene *)scene;
- (void)update;
- (void)render;

@end
