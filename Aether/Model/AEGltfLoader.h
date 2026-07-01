//
//  AEGltfLoader.h
//  Aether
//

#import <Foundation/Foundation.h>
#import "AEMesh.h"

NS_ASSUME_NONNULL_BEGIN

/// Minimal glTF loader: loads the first mesh -> first primitive and constructs an AEMesh.
/// Supports .gltf + external .bin buffer, accessor componentType FLOAT (5126) for vertex attributes,
/// indices as UNSIGNED_SHORT (5123). Only POSITION, NORMAL, TEXCOORD_0 are read.
@interface AEGltfLoader : NSObject

- (nullable AEMesh*)loadMeshFromGLTFAtPath:(NSString*)path error:(NSError * _Nullable *)error;

@end

NS_ASSUME_NONNULL_END
