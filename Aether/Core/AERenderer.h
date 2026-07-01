//
//  AERenderer.h
//  Aether
//

#import <Foundation/Foundation.h>
#import <Metal/Metal.h>
#import <QuartzCore/CAMetalLayer.h>

@class AEMesh;
@class AECamera;

NS_ASSUME_NONNULL_BEGIN

@interface AERenderer : NSObject

@property (nonatomic, strong, nullable) AECamera *camera;

- (instancetype)initWithDevice:(id<MTLDevice>)device;
- (void)renderMesh:(AEMesh *)mesh inLayer:(CAMetalLayer *)layer;

@end

NS_ASSUME_NONNULL_END
