//
//  AEEngine.h
//  Aether
//

#import <Foundation/Foundation.h>
#import <Metal/Metal.h>
#import <QuartzCore/CAMetalLayer.h>

@class AEMesh;
@class AERenderer;
@class AECamera;

NS_ASSUME_NONNULL_BEGIN

@interface AEEngine : NSObject

/// Default system Metal device (lazily created).
@property (class, nonatomic, readonly) id<MTLDevice> device;

@property (nonatomic, readonly) AERenderer *renderer;
@property (nonatomic, strong, nullable) AEMesh *model;

- (instancetype)initWithLayer:(CAMetalLayer *)layer;

/// Start the display-link-driven render loop at the given FPS.
- (void)startWithFPS:(NSInteger)fps;
- (void)stop;

@end

NS_ASSUME_NONNULL_END
