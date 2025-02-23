//
//  Component.m
//  Aether
//
//  Created by Allen on 2024/12/30.
//

#import "AEComponent.h"

@interface AEComponent ()

@property (nonatomic, strong) NSMutableArray<AEComponent *> *children;

@end

@implementation AEComponent

- (instancetype)init {
    self = [super init];
    if (self) {
        _children = [NSMutableArray array];
    }
    return self;
}

- (void)update {
    // 更新组件的状态
    // 例如，更新位置、旋转、缩放等
    for (AEComponent *child in self.children) {
        [child update];
    }
}

- (void)render {
    // 渲染组件
    // 例如，绘制网格、应用材质等
    for (AEComponent *child in self.children) {
        [child render];
    }
}

- (void)addComponent:(AEComponent *)component {
    component.parent = self;
    [self.children addObject:component];
}

- (void)removeComponent:(AEComponent *)component {
    [self.children removeObject:component];
    component.parent = nil;
}

@end
