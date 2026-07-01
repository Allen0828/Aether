//
//  AEModelView.h
//  Aether
//

#import <UIKit/UIKit.h>

@class AEEngine;
@class AECamera;
@class AEMesh;

NS_ASSUME_NONNULL_BEGIN

/// Drop-in UIKit view for loading and displaying one glTF model.
@interface AEModelView : UIView

@property (nonatomic, readonly) AEEngine *engine;
@property (nonatomic, readonly) AECamera *camera;
@property (nonatomic, strong, nullable, readonly) AEMesh *model;
@property (nonatomic) NSInteger framesPerSecond;

- (BOOL)loadModelNamed:(NSString *)name
              inBundle:(NSBundle *)bundle
                 error:(NSError * _Nullable *)error NS_SWIFT_NAME(loadModel(named:in:));

- (BOOL)loadModelAtPath:(NSString *)path
                  error:(NSError * _Nullable *)error NS_SWIFT_NAME(loadModel(atPath:));

- (void)startRenderingWithFPS:(NSInteger)fps NS_SWIFT_NAME(startRendering(fps:));
- (void)stopRendering NS_SWIFT_NAME(stopRendering());

@end

NS_ASSUME_NONNULL_END