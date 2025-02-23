//
//  AERenderSystem.h
//  Aether
//
//  Created by Allen on 2025/1/1.
//


#import <Metal/Metal.h>
#import <QuartzCore/CAMetalLayer.h>

@class AEView;
@class AEScene;

@interface AERenderer : NSObject

@property (nonatomic,weak) AEView *view;

- (instancetype)initWithDevice:(id<MTLDevice>)device;
- (void)renderWithScene:(AEScene*)scene;





@end


