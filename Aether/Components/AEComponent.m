//
//  Component.m
//  Aether
//
//  Created by Allen on 2024/12/30.
//

#import "AEComponent.h"
#import "AEBehaviour.h"

@interface AEComponent ()

@property (nonatomic, strong) NSMutableArray<AEComponent *> *children;
@property (nonatomic, strong) NSMutableArray<AEBehaviour *> *elements;

@property (nonatomic, strong) NSMutableDictionary<NSNumber *, AEComponent *> *idIndex;
@property (nonatomic, strong) NSMutableDictionary<NSString *, NSMutableArray<AEComponent *> *> *nameIndex;
@property (nonatomic, strong) NSMutableDictionary<NSNumber *, NSMutableArray<AEComponent *> *> *typeIndex;
@property (nonatomic, assign) BOOL indexNeedsUpdate;


@end

@implementation AEComponent

- (instancetype)init {
    self = [super init];
    if (self) {
        _children = [NSMutableArray array];
        _elements = [NSMutableArray array];
        _idIndex = [NSMutableDictionary dictionary];
        _nameIndex = [NSMutableDictionary dictionary];
        _typeIndex = [NSMutableDictionary dictionary];
        _indexNeedsUpdate = NO;
    }
    return self;
}

- (void)addChildComponent:(AEComponent *)component {
    [self.children addObject:component];
    component.parent = self;
    self.indexNeedsUpdate = YES;
}

- (void)removeChildComponent:(AEComponent *)component {
    [self.children removeObject:component];
    component.parent = nil;
    self.indexNeedsUpdate = YES;
}

- (void)updateIndexIfNeeded {
    if (self.indexNeedsUpdate) {
        [self.idIndex removeAllObjects];
        [self.nameIndex removeAllObjects];
        [self.typeIndex removeAllObjects];
        
        for (AEComponent *component in self.children) {
            // 更新 ID 索引
            self.idIndex[@(component.componentID)] = component;
            // 更新名称索引
            NSString *componentName = component.componentName;
            if (componentName) {
                if (!self.nameIndex[componentName]) {
                    self.nameIndex[componentName] = [NSMutableArray array];
                }
                [self.nameIndex[componentName] addObject:component];
            } else {
                NSLog(@"Component with ID %ld has a nil componentName. Skipping indexing by name.", (long)component.componentID);
            }
            
            // 更新类型索引
            NSNumber *typeNumber = @(component.classType);
            if (!self.typeIndex[typeNumber]) {
                self.typeIndex[typeNumber] = [NSMutableArray array];
            }
            [self.typeIndex[typeNumber] addObject:component];
        }
        self.indexNeedsUpdate = NO;
    }
}

- (void)update {
    // 更新组件的状态
    // 例如，更新位置、旋转、缩放等
    for (AEComponent *child in self.children) {
        [child update];
    }
    for (AEBehaviour *beh in self.elements) {
        [beh update];
    }
}

- (void)render {
    // 渲染组件
    // 例如，绘制网格、应用材质等
    for (AEComponent *child in self.children) {
        [child render];
    }
}



- (void)attachBehaviour:(AEBehaviour*)beh {
    beh.component = self;
    [self.elements addObject:beh];
}
- (void)detachBehaviour:(AEBehaviour*)beh {
    [self.elements removeObject:beh];
}
- (void)detachAllBehaviour {
    [self.elements removeAllObjects];
}

- (NSArray<AEComponent*>*)getChildren {
    return [self.children copy];
}

- (AEComponent*)findChildComponentByID:(NSInteger)eid {
    [self updateIndexIfNeeded];
    return self.idIndex[@(eid)];
}

- (NSArray<AEComponent*>*)findChildComponentByName:(NSString*)name {
    [self updateIndexIfNeeded];
    return self.nameIndex[name] ?: @[];
}

- (NSArray<AEComponent*>*)findChildComponentByType:(EComponent_ClassType)type {
    [self updateIndexIfNeeded];
    return self.typeIndex[@(type)] ?: @[];
}

- (AEComponent*)findFirstChildComponentByName:(NSString*)name {
    [self updateIndexIfNeeded];
    NSArray<AEComponent *> *components = self.nameIndex[name];
    return components.firstObject;
}

- (AEComponent*)findFirstChildComponentByType:(EComponent_ClassType)type {
    [self updateIndexIfNeeded];
    NSArray<AEComponent *> *components = self.typeIndex[@(type)];
    return components.firstObject;
}




@end
