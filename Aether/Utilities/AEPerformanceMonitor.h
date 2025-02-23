//
//  AEElement.h
//  Aether
//
//  Created by Allen on 2024/12/30.
//

// AEPerformanceMonitor.h
#import <Foundation/Foundation.h>

@interface AEPerformanceMonitor : NSObject

- (void)startMonitoring;
- (void)stopMonitoring;
- (void)update;
- (void)render;

@property (nonatomic, assign) NSInteger frameCount;
@property (nonatomic, assign) NSTimeInterval frameTime;
@property (nonatomic, assign) NSTimeInterval renderTime;
@property (nonatomic, assign) NSTimeInterval updateInterval;

@end
