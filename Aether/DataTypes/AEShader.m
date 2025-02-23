//
//  AEElement.m
//  Aether
//
//  Created by Allen on 2024/12/30.
//

// AEShader.m
#import "AEShader.h"

@implementation AEShader

- (instancetype)initWithDevice:(id<MTLDevice>)device
                  vertexShader:(NSString *)vertexShader
                 fragmentShader:(NSString *)fragmentShader {
    self = [super init];
    if (self) {
        id<MTLLibrary> library = [device newDefaultLibrary];
        self.vertexFunction = [library newFunctionWithName:vertexShader];
        self.fragmentFunction = [library newFunctionWithName:fragmentShader];
    }
    return self;
}

@end
