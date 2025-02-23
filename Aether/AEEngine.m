//
//  AEEngine.m
//  Aether
//
//  Created by Allen on 2025/1/1.
//

#import "AEEngine.h"
#import <TargetConditionals.h>
#import "Render/AERenderer.h"
#import "World/AEWorldContext.h"
#import "View/AEView.h"

#if TARGET_OS_OSX
#include <QuartzCore/CVDisplayLink.h>
#endif

#if TARGET_OS_IOS
#import <UIKit/UIKit.h>
#endif

static id<MTLDevice> m_device;

@interface AEEngine ()

@property (nonatomic,strong) id<MTLCommandQueue> commandQueue;
@property (nonatomic,strong) AEWorldContext *context;
@property (nonatomic,strong) AERenderer *renderer;
@property (nonatomic,strong) AEView *view;

#if TARGET_OS_IOS
@property (nonatomic,strong) CADisplayLink *displayLink;
#elif TARGET_OS_OSX
@property (nonatomic,assign) CVDisplayLinkRef displayLink;
#endif

- (void)drawFrame;

@end

#if TARGET_OS_OSX
CVReturn DisplayLinkCallback(CVDisplayLinkRef displayLink,
                             const CVTimeStamp *inNow,
                             const CVTimeStamp *inOutputTime,
                             CVOptionFlags flagsIn,
                             CVOptionFlags *flagsOut,
                             void *displayLinkContext) {
    @autoreleasepool {
        AEEngine *engine = (__bridge AEEngine *)displayLinkContext;
        [engine drawFrame];
    }
    return kCVReturnSuccess;
}
#endif

@implementation AEEngine

+ (id<MTLDevice>)device {
    if (m_device) {
        return m_device;
    }
    m_device = MTLCreateSystemDefaultDevice();
    return m_device;
}
+ (void)setDevice:(id<MTLDevice>)device {
    m_device = device;
}

- (instancetype)initWithLayer:(CAMetalLayer*)layer {
    if (self = [super init]) {
#if TARGET_OS_IOS
        layer.backgroundColor = [UIColor blueColor].CGColor;
#elif TARGET_OS_OSX
        layer.backgroundColor = CGColorCreateGenericRGB(1.0, 1.0, 1.0, 1.0); // macOS equivalent
#endif
        self.fps = 30;
        [self setupMetal];
        [self setupView:layer];
        [self setupRenderer];
        [self setupWorldContext];
    }
    return self;
}

- (void)setupView:(CAMetalLayer*)layer {
    self.view = [[AEView alloc] initWithLayer:layer];
}

- (void)setupMetal {
    self.commandQueue = [AEEngine.device newCommandQueue];
}

- (void)setupRenderer {
    self.renderer = [[AERenderer alloc] initWithDevice:AEEngine.device];
    self.renderer.view = self.view;
}

- (void)setupWorldContext {
   self.context = [[AEWorldContext alloc] initWithRenderer:self.renderer];
    
}


- (BOOL)CreateEngineLoopContext {
    NSLog(@"engine fps %ld", self.fps);
    // create loop
#if TARGET_OS_IOS
    [self.displayLink invalidate];
    self.displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(drawFrame)];
    self.displayLink.preferredFramesPerSecond = self.fps;
    [self.displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
#elif TARGET_OS_OSX
    CVDisplayLinkCreateWithActiveCGDisplays(&_displayLink);
    CVDisplayLinkSetOutputCallback(_displayLink, &DisplayLinkCallback, (__bridge void *)(self));
    CVDisplayLinkStart(_displayLink);
#endif
    return true;
}

- (BOOL)Shutdown {
#if TARGET_OS_IOS
    [self.displayLink invalidate];
    self.displayLink = nil;
#elif TARGET_OS_OSX
    CVDisplayLinkStop(_displayLink);
    CVDisplayLinkRelease(_displayLink);
    _displayLink = NULL;
#endif
    return true;
}

- (void)drawFrame {
    
    if (self.context) [self.context update];
    if (self.context) [self.context render];
    
}

- (void)processEvents {
    // 处理用户输入和其他事件
}


- (AEWorldContext*)GetRuntimeContext {
    return _context;
}


- (void)UpdateWorld {
    
}

@end

