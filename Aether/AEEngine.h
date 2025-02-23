//
//  AEEngine.h
//  Aether
//
//  Created by Allen on 2025/1/1.
//

/*
 AEEngine include AEWorldContext
 AEWorldContext include AEScene
 */

#import <Foundation/Foundation.h>
#import <QuartzCore/CAMetalLayer.h>
#import "AEWorldContext.h"



@interface AEEngine : NSObject

// 默认使用 MTLCreateSystemDefaultDevice()  如果需要指定GPU 请在engine 初始化之前进行配置
+ (id<MTLDevice>)device;
+ (void)setDevice:(id<MTLDevice>)device;


/// 默认60帧
@property (nonatomic,assign) NSInteger fps;

- (instancetype)initWithLayer:(CAMetalLayer*)layer;

- (BOOL)Shutdown;

/// create a context for engine loop init/update/unload
- (BOOL)CreateEngineLoopContext;


- (AEWorldContext*)GetRuntimeContext;

- (void)UpdateWorld;


@end


