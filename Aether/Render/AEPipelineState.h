//
//  AEPipelineState.h
//  Aether
//
//  Created by Allen on 2025/1/1.
//

#import <Foundation/Foundation.h>
#import <Metal/Metal.h>

@interface AEPipelineState : NSObject

@property (nonatomic, strong) id<MTLRenderPipelineState> pipelineState;

- (instancetype)initWithDevice:(id<MTLDevice>)device
                   vertexFunction:(id<MTLFunction>)vertexFunction
                  fragmentFunction:(id<MTLFunction>)fragmentFunction
                  vertexDescriptor:(MTLVertexDescriptor *)vertexDescriptor
                     pixelFormat:(MTLPixelFormat)pixelFormat;

@end


