//
//  AEElement.h
//  Aether
//
//  Created by Allen on 2024/12/30.
//

#import <Foundation/Foundation.h>


@class AEComponent;

@interface AEElement : NSObject

@property (nonatomic,assign) BOOL isBehaviour;
@property (nonatomic,weak) AEComponent *component;

- (AEComponent*)getComponent;

- (void)initObject;
- (void)update;
- (void)unload;




@end


