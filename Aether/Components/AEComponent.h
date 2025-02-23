//
//  Component.h
//  Aether
//
//  Created by Allen on 2024/12/30.
//

#import <Foundation/Foundation.h>



@interface AEComponent : NSObject

@property (nonatomic, assign) NSInteger componentID;
@property (nonatomic, strong) NSString *componentName;

@property (nonatomic, weak) AEComponent *parent;

- (instancetype)init;
- (void)update;
- (void)render;

@end
