//
//  AEPipelineState.m
//  Aether
//
//  Created by Allen on 2025/1/1.
//

#import "AEPipelineState.h"

@implementation AEPipelineState

- (instancetype)initWithDevice:(id<MTLDevice>)device
                   vertexFunction:(id<MTLFunction>)vertexFunction
                  fragmentFunction:(id<MTLFunction>)fragmentFunction
                  vertexDescriptor:(MTLVertexDescriptor *)vertexDescriptor
                     pixelFormat:(MTLPixelFormat)pixelFormat {
    self = [super init];
    if (self) {
        MTLRenderPipelineDescriptor *pipelineDescriptor = [[MTLRenderPipelineDescriptor alloc] init];
        pipelineDescriptor.vertexFunction = vertexFunction;
        pipelineDescriptor.fragmentFunction = fragmentFunction;
        pipelineDescriptor.vertexDescriptor = vertexDescriptor;
        pipelineDescriptor.colorAttachments[0].pixelFormat = pixelFormat;

        NSError *error = nil;
        self.pipelineState = [device newRenderPipelineStateWithDescriptor:pipelineDescriptor error:&error];
        if (!self.pipelineState) {
            NSLog(@"Error occurred when creating render pipeline state: %@", error);
        }
    }
    return self;
}

@end
