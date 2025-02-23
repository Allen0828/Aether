//
//  AEMaterial.m
//  Aether
//
//  Created by Allen on 2025/1/1.
//

#import "AEMaterial.h"

@implementation AEMaterial

- (CGFloat)GetOpacity {
    return 0.0;
}

- (NSArray *)GetTextureList {
    return [NSArray new];
}

- (BOOL)GetUseLinearColor {
    return false;
}

- (BOOL)HasDynamicProperties {
    return false;
}

- (BOOL)IsForceTransparent {
    return false;
}

- (void)SetAdditiveBlending:(BOOL)bAdditive {
    
}

@end
