//
//  AEPipelineStateManager.h
//  Aether
//
//  Created by Allen on 2025/1/1.
//

#import <Foundation/Foundation.h>
#import "AEPipelineState.h"

@interface AEPipelineStateManager : NSObject

- (void)addPipelineState:(AEPipelineState *)pipelineState withName:(NSString *)name;
- (AEPipelineState *)pipelineStateWithName:(NSString *)name;

@end


/*
 // 在渲染流程中
 AEPipelineStateManager *pipelineStateManager = [[AEPipelineStateManager alloc] init];

 // 创建和添加管线状态
 AEPipelineState *basicPipelineState = [[AEPipelineState alloc] initWithDevice:device
                                                                    vertexFunction:vertexFunction
                                                                   fragmentFunction:fragmentFunction
                                                                   vertexDescriptor:vertexDescriptor
                                                                      pixelFormat:MTLPixelFormatBGRA8Unorm];
 [pipelineStateManager addPipelineState:basicPipelineState withName:@"BasicPipeline"];

 // 获取管线状态并设置到渲染命令编码器
 id<MTLRenderCommandEncoder> renderEncoder = [commandBuffer renderCommandEncoderWithDescriptor:renderPassDescriptor];
 AEPipelineState *pipelineState = [pipelineStateManager pipelineStateWithName:@"BasicPipeline"];
 [renderEncoder setRenderPipelineState:pipelineState.pipelineState];
 */
