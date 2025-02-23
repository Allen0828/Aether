//
//  AESkybox.h
//  Aether
//
//  Created by Allen on 2024/12/30.
//

#import <Foundation/Foundation.h>
#import <Metal/Metal.h>
#import <MetalKit/MetalKit.h>
#import "AECamera.h"

@interface AESkybox : NSObject

@property (nonatomic, strong) id<MTLTexture> texture;
@property (nonatomic, strong) MTKMesh *mesh;

- (instancetype)initWithDevice:(id<MTLDevice>)device
                      texture:(id<MTLTexture>)texture;

- (void)renderWithRenderEncoder:(id<MTLRenderCommandEncoder>)renderEncoder
                        camera:(AECamera *)camera;

@end
