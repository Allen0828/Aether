//
//  Scene.h
//  Aether
//
//  Created by Allen on 2024/12/30.
//

#import "AEComponent.h"
#import "AECamera.h"
#import "AESkybox.h"
#import "AEBasicGeometry.h"
#import "AEBehaviour.h"



@interface AEScene : AEComponent

//@property (nonatomic, strong) NSMutableArray<AEComponent *> *objects;


//- (void)addObject:(AEComponent *)object;
//- (void)removeObject:(AEComponent *)object;

- (void)setCamera:(AECamera*)camera;
- (AESkybox*)getSkybox;
- (AECamera*)getCamera;


- (void)update;

@end

