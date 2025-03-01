//
//  AEMaterial.m
//  Aether
//
//  Created by Allen on 2025/1/1.
//

#import "AEMaterial.h"
#import <MetalKit/MTKTextureLoader.h>
#import "AEEngine.h"

@interface AEMaterial ()

@property (nonatomic,strong,readonly) id<MTLTexture> texture;

@end

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

- (void)SetTexture:(NSString*)filePath {
    NSError *error;
    MTKTextureLoader *texLoader = [[MTKTextureLoader alloc] initWithDevice:AEEngine.device];
    NSURL *url = [NSURL fileURLWithPath:filePath];
    if (url == nil) {
        NSLog(@"Material Error: file path not find");
    }
    NSDictionary *options = @{
        MTKTextureLoaderOptionTextureUsage: @(MTLTextureUsageShaderRead),
        MTKTextureLoaderOptionTextureStorageMode: @(MTLStorageModePrivate),
        MTKTextureLoaderOptionSRGB: @(NO),
        MTKTextureLoaderOptionGenerateMipmaps: @(NO)
    };
    id<MTLTexture> uv = [texLoader newTextureWithContentsOfURL:url options:options error:&error];
    if (error != nil) {
        NSLog(@"Material Error: load tex filed %@", error);
    }
    _texture = uv;
}

- (id<MTLTexture>)getTexture {
    return _texture;
}

@end




@implementation AEUnlitMaterial



@end
