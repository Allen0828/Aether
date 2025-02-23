//
//  Scene.m
//  Aether
//
//  Created by Allen on 2024/12/30.
//

#import "AEScene.h"
#import "AEMesh.h"
#import "AECamera.h"
#import "AESkybox.h"

@interface AEScene ()

@property (nonatomic, strong) AECamera *mainCamera;
@property (nonatomic, strong) AESkybox *mainSkybox;

@end

@implementation AEScene

- (instancetype)init {
    self = [super init];
    if (self) {
        _objects = [NSMutableArray array];
    }
    return self;
}

- (void)setCamera:(AECamera *)camera {
    _mainCamera = camera;
}

- (AESkybox*)getSkybox {
    return _mainSkybox;
}
- (AECamera*)getCamera {
    return _mainCamera;
}

- (void)addObject:(AEComponent *)object {
    [self.objects addObject:object];
}

- (void)removeObject:(AEComponent *)object {
    [self.objects removeObject:object];
}

- (void)update {
    for (AEComponent *object in self.objects) {
        [object update];
    }
}



@end
