//
//  AEMaterial.h
//  Aether
//

#import <Foundation/Foundation.h>
#import <Metal/Metal.h>
#import <simd/simd.h>

NS_ASSUME_NONNULL_BEGIN

@interface AEMaterial : NSObject

@property (nonatomic, strong, nullable) id<MTLTexture> diffuseTexture;

/// Default base color used when no texture is set (RGB).
@property (nonatomic) simd_float3 baseColor;

- (void)loadTextureFromFile:(NSString *)path;

@end

NS_ASSUME_NONNULL_END
