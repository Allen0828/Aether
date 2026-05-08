//
//  AEGltfLoader.m
//  Aether
//

#import "AEGltfLoader.h"
#import <Metal/Metal.h>
#import "../../AEEngine.h"

static uint32_t const GLTF_COMPONENT_FLOAT = 5126;
static uint32_t const GLTF_COMPONENT_UNSIGNED_SHORT = 5123;

@implementation AEGltfLoader

- (AEMesh*)loadMeshFromGLTFAtPath:(NSString*)path error:(NSError *__autoreleasing  _Nullable *)error {
    if (!path) {
        if (error) *error = [NSError errorWithDomain:@"AEGltfLoader" code:-1 userInfo:@{NSLocalizedDescriptionKey: @"path is nil"}];
        return nil;
    }

    NSData *jsonData = [NSData dataWithContentsOfFile:path options:0 error:error];
    if (!jsonData) return nil;

    NSError *jsonErr = nil;
    NSDictionary *gltf = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:&jsonErr];
    if (!gltf) {
        if (error) *error = jsonErr;
        return nil;
    }

    // load first buffer (assumes external .bin)
    NSArray *buffers = gltf[@"buffers"];
    if (!buffers || buffers.count == 0) {
        if (error) *error = [NSError errorWithDomain:@"AEGltfLoader" code:-2 userInfo:@{NSLocalizedDescriptionKey: @"no buffers in glTF"}];
        return nil;
    }
    NSDictionary *firstBuffer = buffers[0];
    NSString *uri = firstBuffer[@"uri"];
    if (!uri) {
        if (error) *error = [NSError errorWithDomain:@"AEGltfLoader" code:-3 userInfo:@{NSLocalizedDescriptionKey: @"buffer uri missing"}];
        return nil;
    }

    // resolve binary path relative to gltf
    NSString *baseDir = [path stringByDeletingLastPathComponent];
    NSString *binPath = [baseDir stringByAppendingPathComponent:uri];
    NSData *binData = [NSData dataWithContentsOfFile:binPath options:0 error:error];
    if (!binData) return nil;

    NSArray *bufferViews = gltf[@"bufferViews"] ?: @[];
    NSArray *accessors = gltf[@"accessors"] ?: @[];
    NSArray *meshes = gltf[@"meshes"] ?: @[];
    if (meshes.count == 0) {
        if (error) *error = [NSError errorWithDomain:@"AEGltfLoader" code:-4 userInfo:@{NSLocalizedDescriptionKey: @"no meshes in glTF"}];
        return nil;
    }

    NSDictionary *meshDict = meshes[0];
    NSArray *primitives = meshDict[@"primitives"];
    if (!primitives || primitives.count == 0) {
        if (error) *error = [NSError errorWithDomain:@"AEGltfLoader" code:-5 userInfo:@{NSLocalizedDescriptionKey: @"no primitives in mesh"}];
        return nil;
    }

    NSDictionary *prim = primitives[0];
    NSDictionary *attributes = prim[@"attributes"];
    if (!attributes) {
        if (error) *error = [NSError errorWithDomain:@"AEGltfLoader" code:-6 userInfo:@{NSLocalizedDescriptionKey: @"primitive attributes missing"}];
        return nil;
    }

    NSNumber *posAccessorIndex = attributes[@"POSITION"];
    NSNumber *normalAccessorIndex = attributes[@"NORMAL"];
    NSNumber *uvAccessorIndex = attributes[@"TEXCOORD_0"];
    NSNumber *indicesAccessorIndex = prim[@"indices"];

    if (!posAccessorIndex || !indicesAccessorIndex) {
        if (error) *error = [NSError errorWithDomain:@"AEGltfLoader" code:-7 userInfo:@{NSLocalizedDescriptionKey: @"POSITION or indices accessor missing"}];
        return nil;
    }

    NSDictionary *posAccessor = accessors[posAccessorIndex.intValue];
    NSDictionary *idxAccessor = accessors[indicesAccessorIndex.intValue];

    // helper block to read accessor data
    NSData *(^readAccessor)(NSDictionary *) = ^NSData*(NSDictionary *accessor){
        NSNumber *bufViewIdx = accessor[@"bufferView"];
        if (!bufViewIdx) return (NSData*)nil;
        NSDictionary *bv = bufferViews[bufViewIdx.intValue];
        NSUInteger bvOffset = [bv[@"byteOffset"] unsignedIntegerValue];
        NSUInteger bvLength = [bv[@"byteLength"] unsignedIntegerValue];
        NSUInteger accOffset = [accessor[@"byteOffset"] unsignedIntegerValue];
        NSUInteger start = bvOffset + accOffset;
        NSUInteger length = (bvLength > accOffset) ? (bvLength - accOffset) : 0;
        if (length == 0 || start + length > binData.length) {
            return (NSData*)nil;
        }
        return [binData subdataWithRange:NSMakeRange(start, length)];
    };

    NSData *posData = readAccessor(posAccessor);
    NSData *idxData = readAccessor(idxAccessor);
    if (!posData || !idxData) {
        if (error) *error = [NSError errorWithDomain:@"AEGltfLoader" code:-8 userInfo:@{NSLocalizedDescriptionKey: @"failed to read accessor data"}];
        return nil;
    }

    uint32_t posComponentType = [posAccessor[@"componentType"] unsignedIntValue];
    NSString *posType = posAccessor[@"type"]; // VEC3
    NSUInteger posCount = [posAccessor[@"count"] unsignedIntegerValue];
    if (posComponentType != GLTF_COMPONENT_FLOAT || ![posType isEqualToString:@"VEC3"]) {
        if (error) *error = [NSError errorWithDomain:@"AEGltfLoader" code:-9 userInfo:@{NSLocalizedDescriptionKey: @"unsupported POSITION accessor type"}];
        return nil;
    }

    uint32_t idxComponentType = [idxAccessor[@"componentType"] unsignedIntValue];
    NSUInteger idxCount = [idxAccessor[@"count"] unsignedIntegerValue];
    if (idxComponentType != GLTF_COMPONENT_UNSIGNED_SHORT) {
        if (error) *error = [NSError errorWithDomain:@"AEGltfLoader" code:-10 userInfo:@{NSLocalizedDescriptionKey: @"unsupported index componentType (only UNSIGNED_SHORT supported)"}];
        return nil;
    }

    // normals and uvs optional
    NSData *normalData = nil;
    if (normalAccessorIndex) {
        NSDictionary *normalAcc = accessors[normalAccessorIndex.intValue];
        if ([normalAcc[@"componentType"] unsignedIntValue] == GLTF_COMPONENT_FLOAT && [normalAcc[@"type"] isEqualToString:@"VEC3"]) {
            normalData = readAccessor(normalAcc);
        }
    }
    NSData *uvData = nil;
    if (uvAccessorIndex) {
        NSDictionary *uvAcc = accessors[uvAccessorIndex.intValue];
        if ([uvAcc[@"componentType"] unsignedIntValue] == GLTF_COMPONENT_FLOAT && [uvAcc[@"type"] isEqualToString:@"VEC2"]) {
            uvData = readAccessor(uvAcc);
        }
    }

    // build Vertex array
    NSUInteger vertexCount = posCount;
    Vertex *verts = malloc(sizeof(Vertex) * vertexCount);
    const float *posPtr = (const float*)posData.bytes;
    const float *normalPtr = normalData ? (const float*)normalData.bytes : NULL;
    const float *uvPtr = uvData ? (const float*)uvData.bytes : NULL;
    for (NSUInteger i = 0; i < vertexCount; i++) {
        verts[i].position = (vector_float3){ posPtr[i*3+0], posPtr[i*3+1], posPtr[i*3+2] };
        if (normalPtr) verts[i].normal = (vector_float3){ normalPtr[i*3+0], normalPtr[i*3+1], normalPtr[i*3+2] };
        else verts[i].normal = (vector_float3){0,0,0};
        if (uvPtr) verts[i].uv = (vector_float2){ uvPtr[i*2+0], uvPtr[i*2+1] };
        else verts[i].uv = (vector_float2){0,0};
    }

    // build indices (uint16)
    const uint16_t *idxPtr = (const uint16_t*)idxData.bytes;
    uint16_t *indices = malloc(sizeof(uint16_t) * idxCount);
    for (NSUInteger i = 0; i < idxCount; i++) indices[i] = idxPtr[i];

    id<MTLDevice> device = [AEEngine device];
    if (!device) device = MTLCreateSystemDefaultDevice();

    AEMesh *outMesh = [[AEMesh alloc] initWithDevice:device vertices:verts vertexCount:vertexCount indices:indices indexCount:idxCount];

    free(verts);
    free(indices);

    return outMesh;
}

@end
