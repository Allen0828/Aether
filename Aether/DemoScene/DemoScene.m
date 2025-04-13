//
//  DemoScene.m
//  Aether-swift
//
//  Created by Allen on 2025/4/13.
//

#import "DemoScene.h"

@implementation DemoScene

- (instancetype)init {
    if (self = [super init]) {
        self.componentName = @"demoScene";
        [self setCamera:[AECamera new]];
        
        
    }
    return self;
}


@end
