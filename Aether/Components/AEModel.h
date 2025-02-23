//
//  AEElement.h
//  Aether
//
//  Created by Allen on 2024/12/30.
//

/*
 model 负责管理mesh
 */

// AEModel.h
#import <Foundation/Foundation.h>
#import <Metal/Metal.h>
#import <ModelIO/ModelIO.h>

@class MTKMesh;

@interface AEModel : NSObject

@property (nonatomic, strong) NSArray<MTKMesh *> *meshes;
@property (nonatomic, strong) NSArray<MDLMaterial *> *materials;
@property (nonatomic, assign) simd_float4x4 transform;

- (instancetype)initWithURL:(NSURL *)modelURL device:(id<MTLDevice>)device;


- (void)setMaterialFromFile:(NSString*)path;

- (void)renderWithRenderEncoder:(id<MTLRenderCommandEncoder>)renderEncoder;

@end

