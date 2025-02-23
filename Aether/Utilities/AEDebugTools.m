//
//  AEElement.m
//  Aether
//
//  Created by Allen on 2024/12/30.
//

// AEDebugTools.m
#import "AEDebugTools.h"
#import "AEPerformanceMonitor.h"

@interface AEDebugTools ()

@property (nonatomic, strong) MTKView *metalView;
@property (nonatomic, strong) id<MTLDevice> device;
@property (nonatomic, strong) id<MTLCommandQueue> commandQueue;
@property (nonatomic, strong) AEPerformanceMonitor *performanceMonitor;

@end

@implementation AEDebugTools

- (instancetype)initWithMetalView:(MTKView *)metalView {
    self = [super init];
    if (self) {
        _metalView = metalView;
        _device = metalView.device;
        _commandQueue = [_device newCommandQueue];
        _performanceMonitor = [[AEPerformanceMonitor alloc] init];
    }
    return self;
}

- (void)toggleDebugMode {
    self.isDebugModeEnabled = !self.isDebugModeEnabled;
}

- (void)update {
    [self.performanceMonitor update];
}

- (void)render {
    if (self.isDebugModeEnabled) {
        [self renderDebugInfo];
    }
}

- (void)renderDebugInfo {
    id<MTLCommandBuffer> commandBuffer = [self.commandQueue commandBuffer];
    MTLRenderPassDescriptor *renderPassDescriptor = [self.metalView currentRenderPassDescriptor];
    if (renderPassDescriptor) {
        id<MTLRenderCommandEncoder> renderEncoder = [commandBuffer renderCommandEncoderWithDescriptor:renderPassDescriptor];
        //[renderEncoder setRenderPipelineState:self.pipelineState];
        
        // 绘制调试信息文本
        // 例如，使用 Metal 的渲染管线状态和渲染命令编码器来绘制文本
        NSString *fpsText = [NSString stringWithFormat:@"FPS: %.2f", self.performanceMonitor.frameTime];
        [self drawText:fpsText atPosition:CGPointMake(10, 10)];
        
        [renderEncoder endEncoding];
    }
    [commandBuffer presentDrawable:self.metalView.currentDrawable];
    [commandBuffer commit];
}

- (void)drawText:(NSString *)text atPosition:(CGPoint)position {
    // 实现绘制文本的逻辑
    // 例如，使用 Metal 的渲染管线状态和渲染命令编码器来绘制文本
}

@end
