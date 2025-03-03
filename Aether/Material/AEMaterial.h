//
//  AEMaterial.h
//  Aether
//
//  Created by Allen on 2025/1/1.
//

#import <Foundation/Foundation.h>
#import <Metal/Metal.h>

typedef enum : NSUInteger {
    BlendDisabled,
    BlendAlphaBlending,
    BlendAdditiveBlending,
    BlendOIT,
    BlendPremultiplyAlphaBlending,
    BlendMasked,
} EBlendFunc;

typedef enum : NSUInteger {
    None,
    Back,
    Front,
} EFaceCullingMode;

typedef enum : NSUInteger {
    Default,
    TwoPass,
    DepthPreTransparency,
} ETransparencyMode;

typedef enum : NSUInteger {
    Never,
    Less,
    LessEqual,
    Greater,
    GreaterEqual,
    Equal,
    NotEqual,
    Alawys,
} EStencilFunc;

typedef enum : NSUInteger {
    Keep,
    Zero,
    Replace,
    Increment,
    IncrementWrap,
    Decrement,
    DecrementWrap,
    Invert,
} EStencilOp;


@interface AEMaterial : NSObject

@property (nonatomic,assign) BOOL DoubleSided;
@property (nonatomic,assign) EBlendFunc BlendFuncion;
@property (nonatomic,assign) EFaceCullingMode FaceCullingMode;
@property (nonatomic,assign) ETransparencyMode TransparencyMode;
@property (nonatomic,assign) EStencilFunc StencilFunction;
@property (nonatomic,assign) EStencilOp StencilOperation;
@property (nonatomic,assign) NSInteger ActiveDynamicPropertiesLine;
@property (nonatomic,assign) BOOL CacheGraphBasedShader;

- (BOOL)IsForceTransparent;
- (void)SetAdditiveBlending:(BOOL)bAdditive;
- (CGFloat)GetOpacity;
- (BOOL)GetUseLinearColor;
- (BOOL)HasDynamicProperties;

- (void)SetTexture:(NSString*)filePath;
- (id<MTLTexture>)getTexture;

- (NSArray*)GetTextureList;

@end


@interface AEUnlitMaterial : AEMaterial

@end
