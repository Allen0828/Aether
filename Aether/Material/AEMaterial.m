//
//  AEMaterial.m
//  Aether
//

#import "AEMaterial.h"
#import <MetalKit/MetalKit.h>
#import "../Core/AEEngine.h"

@implementation AEMaterial

- (instancetype)init {
    if (self = [super init]) {
        _baseColor = simd_make_float3(1.0, 1.0, 1.0);
    }
    return self;
}

- (void)loadTextureFromFile:(NSString *)path {
    NSError *error = nil;
    MTKTextureLoader *loader = [[MTKTextureLoader alloc] initWithDevice:AEEngine.device];
    NSURL *url = [NSURL fileURLWithPath:path];
    if (!url) { NSLog(@"AEMaterial: invalid path"); return; }
    NSDictionary *opts = @{
        MTKTextureLoaderOptionTextureUsage: @(MTLTextureUsageShaderRead),
        MTKTextureLoaderOptionSRGB: @(NO)
    };
    id<MTLTexture> tex = [loader newTextureWithContentsOfURL:url options:opts error:&error];
    if (error) { NSLog(@"AEMaterial: texture load error %@", error); }
    else { _diffuseTexture = tex; }
}

@end
