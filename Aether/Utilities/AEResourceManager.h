//
//  AEResourceManager.h
//  Aether
//

#import <Foundation/Foundation.h>
#import <Metal/Metal.h>

NS_ASSUME_NONNULL_BEGIN

/// Lightweight resource manager for textures/meshes/shaders.
/// Thread-safe; uses reference counting for cached resources.
@interface AEResourceManager : NSObject

+ (instancetype)sharedManager;

/// Load a texture from disk asynchronously. Path should be a local file path.
- (void)loadTextureAtPath:(NSString*)path completion:(void(^)(id<MTLTexture> _Nullable texture, NSError * _Nullable error))completion;

/// Get an already-loaded texture synchronously (returns nil if not loaded).
- (nullable id<MTLTexture>)textureForPath:(NSString*)path;

/// Decrement reference for texture; when refcount reaches zero the cached texture is released.
- (void)releaseTextureForPath:(NSString*)path;

@end

NS_ASSUME_NONNULL_END
