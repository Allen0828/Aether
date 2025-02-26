//
//  Component.h
//  Aether
//
//  Created by Allen on 2024/12/30.
//

#import <Foundation/Foundation.h>
#import <simd/simd.h>

@class AEBehaviour;

@interface AEComponent : NSObject

@property (nonatomic,assign) NSInteger componentID;
@property (nonatomic,strong) NSString *componentName;
@property (nonatomic,assign) simd_float3 position;

@property (nonatomic,weak) AEComponent *parent;

- (instancetype)init;
- (void)update;
- (void)render;

- (void)attachBehaviour:(AEBehaviour*)beh;
- (void)detachBehaviour:(AEBehaviour*)beh;
- (void)detachAllBehaviour;

@end
