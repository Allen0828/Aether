//
//  AEView.m
//  Aether
//
//  Created by Allen on 2025/1/1.
//

#import "AEView.h"
#import "AERenderer.h"

@interface AEView ()

@property (nonatomic,strong) CAMetalLayer *layer;
@property (nonatomic,strong) AERenderer *renderer;

@end

@implementation AEView

- (instancetype)initWithLayer:(CAMetalLayer *)layer {
    if (self = [super init]) {
        NSLog(@"View Init %lu", layer.pixelFormat);  // MTLPixelFormatBGRA8Unorm
        _layer = layer;
        _layer.framebufferOnly = NO;  // 默认使用2重采样
    }
    return self;
}

- (void)setOffscreenMsaaType:(EMSAAQuality)msaaType {
    if (msaaType == Disabled) {
        _layer.framebufferOnly = YES;
    } else {
        _layer.framebufferOnly = NO;
    }
}

- (CAMetalLayer *)getLayer {
    return _layer;
}

- (void)render {
    
}

@end
