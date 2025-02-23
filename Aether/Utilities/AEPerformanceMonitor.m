//
//  AEElement.m
//  Aether
//
//  Created by Allen on 2024/12/30.
//

// AEPerformanceMonitor.m
#import "AEPerformanceMonitor.h"
#import <Metal/Metal.h>
#import <MetalKit/MetalKit.h>

@interface AEPerformanceMonitor ()

@property (nonatomic, strong) MTKView *metalView;
@property (nonatomic, strong) id<MTLDevice> device;
@property (nonatomic, strong) id<MTLCommandQueue> commandQueue;
@property (nonatomic, strong) id<MTLRenderPipelineState> pipelineState;
@property (nonatomic, strong) id<MTLBuffer> vertexBuffer;
@property (nonatomic, strong) id<MTLBuffer> indexBuffer;

@end

@implementation AEPerformanceMonitor

- (instancetype)initWithMetalView:(MTKView *)metalView {
    self = [super init];
    if (self) {
        _metalView = metalView;
        _device = metalView.device;
        _commandQueue = [_device newCommandQueue];
        [self setupPipeline];
    }
    return self;
}

- (void)setupPipeline {
    // 创建渲染管线状态
    MTLRenderPipelineDescriptor *pipelineDescriptor = [[MTLRenderPipelineDescriptor alloc] init];
    
    pipelineDescriptor.vertexFunction = [[self.device newDefaultLibrary] newFunctionWithName:@"vertexShader"];
    pipelineDescriptor.fragmentFunction = [[self.device newDefaultLibrary] newFunctionWithName:@"fragmentShader"];
    pipelineDescriptor.colorAttachments[0].pixelFormat = self.metalView.colorPixelFormat;
    self.pipelineState = [self.device newRenderPipelineStateWithDescriptor:pipelineDescriptor error:nil];
}

- (void)startMonitoring {
    self.updateInterval = CACurrentMediaTime();
    self.frameCount = 0;
}

- (void)stopMonitoring {
    self.updateInterval = 0;
    self.frameCount = 0;
}

- (void)update {
    self.frameCount++;
    NSTimeInterval currentTime = CACurrentMediaTime();
    NSTimeInterval deltaTime = currentTime - self.updateInterval;
    if (deltaTime >= 1.0) {
        self.frameTime = deltaTime / self.frameCount;
        self.frameCount = 0;
        self.updateInterval = currentTime;
    }
}

- (void)render {
    id<MTLCommandBuffer> commandBuffer = [self.commandQueue commandBuffer];
    MTLRenderPassDescriptor *renderPassDescriptor = [self.metalView currentRenderPassDescriptor];
    if (renderPassDescriptor) {
        id<MTLRenderCommandEncoder> renderEncoder = [commandBuffer renderCommandEncoderWithDescriptor:renderPassDescriptor];
        [renderEncoder setRenderPipelineState:self.pipelineState];
        [renderEncoder setVertexBuffer:self.vertexBuffer offset:0 atIndex:0];
        [renderEncoder drawPrimitives:MTLPrimitiveTypeTriangle vertexStart:0 vertexCount:3];
        [renderEncoder endEncoding];
    }
    [commandBuffer presentDrawable:self.metalView.currentDrawable];
    [commandBuffer commit];
}

@end
