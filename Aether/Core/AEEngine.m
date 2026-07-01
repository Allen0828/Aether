//
//  AEEngine.m
//  Aether
//

#import "AEEngine.h"
#import "AERenderer.h"
#import "../Model/AEMesh.h"
#import <QuartzCore/CADisplayLink.h>

static id<MTLDevice> _device;

#pragma mark - AETargetProxy (weak-reference proxy for CADisplayLink)

@interface AETargetProxy : NSObject
- (instancetype)initWithBlock:(void (^)(void))block;
- (void)proxySelector;
@end

@interface AEEngine ()
@property (nonatomic, strong) CAMetalLayer *layer;
@property (nonatomic, strong) AERenderer *renderer;
@property (nonatomic, strong) CADisplayLink *displayLink;
@end

@implementation AEEngine

+ (id<MTLDevice>)device {
    if (!_device) _device = MTLCreateSystemDefaultDevice();
    return _device;
}

- (instancetype)initWithLayer:(CAMetalLayer *)layer {
    if (self = [super init]) {
        _layer = layer;
        _layer.device = AEEngine.device;
        _layer.pixelFormat = MTLPixelFormatBGRA8Unorm;
        _layer.framebufferOnly = YES;
        _renderer = [[AERenderer alloc] initWithDevice:AEEngine.device];
    }
    return self;
}

- (void)startWithFPS:(NSInteger)fps {
    [self stop];
    __weak typeof(self) ws = self;
    self.displayLink = [CADisplayLink displayLinkWithTarget:[[AETargetProxy alloc] initWithBlock:^{
        [ws _tick];
    }] selector:@selector(proxySelector)];
    if (@available(iOS 15.0, *)) {
        self.displayLink.preferredFrameRateRange = CAFrameRateRangeMake(fps, fps, fps);
    } else {
        self.displayLink.preferredFramesPerSecond = fps;
    }
    [self.displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
}

- (void)stop {
    [self.displayLink invalidate];
    self.displayLink = nil;
}

- (void)_tick {
    [self.renderer renderMesh:self.model inLayer:self.layer];
}

@end

#pragma mark - AETargetProxy implementation

@interface AETargetProxy ()
@property (nonatomic, copy) void (^block)(void);
@end

@implementation AETargetProxy
- (instancetype)initWithBlock:(void (^)(void))block {
    if (self = [super init]) { _block = block; }
    return self;
}
- (void)proxySelector { if (_block) _block(); }
@end
