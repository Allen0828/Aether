//
//  AEPipelineStateManager.m
//  Aether
//
//  Created by Allen on 2025/1/1.
//

#import "AEPipelineStateManager.h"

@interface AEPipelineStateManager ()

@property (nonatomic, strong) NSMutableDictionary<NSString *, AEPipelineState *> *pipelineStates;

@end

@implementation AEPipelineStateManager

- (instancetype)init {
    self = [super init];
    if (self) {
        _pipelineStates = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (void)addPipelineState:(AEPipelineState *)pipelineState withName:(NSString *)name {
    self.pipelineStates[name] = pipelineState;
}

- (AEPipelineState *)pipelineStateWithName:(NSString *)name {
    return self.pipelineStates[name];
}

@end
