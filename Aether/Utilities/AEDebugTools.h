//
//  AEElement.h
//  Aether
//
//  Created by Allen on 2024/12/30.
//

// AEDebugTools.h
#import <Foundation/Foundation.h>
#import <Metal/Metal.h>
#import <MetalKit/MetalKit.h>

@interface AEDebugTools : NSObject

@property (nonatomic, assign) BOOL isDebugModeEnabled;

- (instancetype)initWithMetalView:(MTKView *)metalView;
- (void)update;
- (void)render;
- (void)toggleDebugMode;

@end

