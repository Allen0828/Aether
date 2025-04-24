//
//  Component.h
//  Aether
//
//  Created by Allen on 2024/12/30.
//

#import <Foundation/Foundation.h>
#import <simd/simd.h>


typedef enum : NSUInteger {
    None = 0,
    Component,
    Model,
    Light,
    Camera,
    Scene,
    BoxGeometry,
} EComponent_ClassType;


@class AEBehaviour;

@interface AEComponent : NSObject

@property (nonatomic,assign) NSInteger componentID;
@property (nonatomic,strong) NSString *componentName;
@property (nonatomic,assign) EComponent_ClassType classType;
@property (nonatomic,assign) simd_float3 position;

@property (nonatomic,weak) AEComponent *parent;

- (instancetype)init;
- (void)update;
- (void)render;

- (void)attachBehaviour:(AEBehaviour*)beh;
- (void)detachBehaviour:(AEBehaviour*)beh;
- (void)detachAllBehaviour;

- (void)addChildComponent:(AEComponent*)component;
- (void)removeChildComponent:(AEComponent*)component;

- (NSArray<AEComponent*>*)getChildren;
- (AEComponent*)findChildComponentByID:(NSInteger)eid;
- (NSArray<AEComponent*>*)findChildComponentByName:(NSString*)name;
- (NSArray<AEComponent*>*)findChildComponentByType:(EComponent_ClassType)type;
- (AEComponent*)findFirstChildComponentByName:(NSString*)name;
- (AEComponent*)findFirstChildComponentByType:(EComponent_ClassType)type;


@end
