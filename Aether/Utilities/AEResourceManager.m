//
//  AEResourceManager.m
//  Aether
//

#import "AEResourceManager.h"
#import <MetalKit/MetalKit.h>
#import "AEEngine.h"

@interface _AETextureEntry : NSObject
@property (nonatomic, strong) id<MTLTexture> texture;
@property (nonatomic, assign) NSUInteger refCount;
@end

@implementation _AETextureEntry
@end

@interface AEResourceManager ()
@property (nonatomic, strong) NSMutableDictionary<NSString*, _AETextureEntry*> *textures;
@property (nonatomic, strong) dispatch_queue_t syncQueue;
@property (nonatomic, strong) MTKTextureLoader *textureLoader;
@end

@implementation AEResourceManager

+ (instancetype)sharedManager {
    static AEResourceManager *s_shared = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        s_shared = [[AEResourceManager alloc] initPrivate];
    });
    return s_shared;
}

- (instancetype)initPrivate {
    if (self = [super init]) {
        _textures = [NSMutableDictionary dictionary];
        _syncQueue = dispatch_queue_create("com.aether.resourcemanager.queue", DISPATCH_QUEUE_SERIAL);
        id<MTLDevice> device = [AEEngine device];
        if (!device) device = MTLCreateSystemDefaultDevice();
        _textureLoader = [[MTKTextureLoader alloc] initWithDevice:device];
    }
    return self;
}

- (instancetype)init {
    NSAssert(NO, @"Use +[AEResourceManager sharedManager]");
    return [self initPrivate];
}

- (void)loadTextureAtPath:(NSString*)path completion:(void(^)(id<MTLTexture> _Nullable texture, NSError * _Nullable error))completion {
    if (!path) {
        if (completion) completion(nil, [NSError errorWithDomain:@"AEResourceManager" code:-1 userInfo:@{NSLocalizedDescriptionKey: @"path is nil"}]);
        return;
    }

    __weak typeof(self) weakSelf = self;
    dispatch_async(_syncQueue, ^{
        _AETextureEntry *entry = weakSelf.textures[path];
        if (entry && entry.texture) {
            entry.refCount += 1;
            id<MTLTexture> tex = entry.texture;
            dispatch_async(dispatch_get_main_queue(), ^{
                if (completion) completion(tex, nil);
            });
            return;
        }

        NSURL *url = [NSURL fileURLWithPath:path];
        NSDictionary *opts = @{ MTKTextureLoaderOptionSRGB: @NO };
        [weakSelf.textureLoader newTextureWithContentsOfURL:url options:opts completionHandler:^(id<MTLTexture>  _Nullable texture, NSError * _Nullable error) {
            dispatch_async(weakSelf.syncQueue, ^{
                if (texture && !error) {
                    _AETextureEntry *e = weakSelf.textures[path];
                    if (!e) {
                        e = [_AETextureEntry new];
                        weakSelf.textures[path] = e;
                    }
                    e.texture = texture;
                    e.refCount = (e.refCount == 0) ? 1 : (e.refCount + 1);
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (completion) completion(texture, error);
                });
            });
        }];
    });
}

- (id<MTLTexture>)textureForPath:(NSString*)path {
    if (!path) return nil;
    __block id<MTLTexture> tex = nil;
    dispatch_sync(_syncQueue, ^{
        _AETextureEntry *e = self.textures[path];
        if (e) {
            e.refCount += 1;
            tex = e.texture;
        }
    });
    return tex;
}

- (void)releaseTextureForPath:(NSString*)path {
    if (!path) return;
    dispatch_async(_syncQueue, ^{
        _AETextureEntry *e = self.textures[path];
        if (!e) return;
        if (e.refCount > 0) e.refCount -= 1;
        if (e.refCount == 0) {
            [self.textures removeObjectForKey:path];
        }
    });
}

@end
