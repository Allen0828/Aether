//
//  AEGltfLoader.h
//  Aether
//

#import <Foundation/Foundation.h>
#import "../AEResourceManager.h"
#import "../../Components/AEMesh.h"

NS_ASSUME_NONNULL_BEGIN

/// Minimal glTF loader: loads the first mesh -> first primitive and constructs an AEMesh.
/// Limitations: supports only .gltf + external .bin buffer, accessor componentType FLOAT (5126) for vertex attributes,
/// indices as UNSIGNED_SHORT (5123). Only POSITION, NORMAL, TEXCOORD_0 are read.
@interface AEGltfLoader : NSObject

/// Load a mesh synchronously from a .gltf file path. Returns nil and sets error on failure.
- (nullable AEMesh*)loadMeshFromGLTFAtPath:(NSString*)path error:(NSError * _Nullable *)error;

@end

NS_ASSUME_NONNULL_END
